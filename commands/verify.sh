#!/bin/bash

# 🔍 DevTools Verify Command
# =========================
# Descripción: Verificación completa de proyectos y configuraciones

# Función principal del comando verify
cmd_verify() {
    log_section "VERIFY" "🔍"
    log_info "Iniciando verificación del proyecto..."
    
    # Procesar argumentos
    local verbose=false
    local quiet=false
    local project_path="$(pwd)"
    local deps_only=false
    local config_only=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --verbose|-v)
                verbose=true
                set_log_level "DEBUG"
                shift
                ;;
            --quiet|-q)
                quiet=true
                set_log_level "ERROR"
                shift
                ;;
            --path)
                project_path="$2"
                shift 2
                ;;
            --deps-only)
                deps_only=true
                shift
                ;;
            --config-only)
                config_only=true
                shift
                ;;
            --help|-h)
                show_verify_help
                return 0
                ;;
            *)
                log_error "Opción desconocida: $1"
                show_verify_help
                return 1
                ;;
        esac
    done
    
    # Cambiar al directorio del proyecto
    if [[ ! -d "$project_path" ]]; then
        log_error "El directorio no existe: $project_path"
        return 1
    fi
    
    cd "$project_path" || return 1
    log_info "Verificando proyecto en: $(color_path "$project_path")"
    
    # Ejecutar verificaciones
    local exit_code=0
    
    if [[ "$deps_only" == "false" ]] && [[ "$config_only" == "false" ]]; then
        # Verificación completa
        verify_project_structure || ((exit_code++))
        verify_dependencies || ((exit_code++))
        verify_configuration || ((exit_code++))
        verify_tools || ((exit_code++))
    elif [[ "$deps_only" == "true" ]]; then
        verify_dependencies || ((exit_code++))
    elif [[ "$config_only" == "true" ]]; then
        verify_configuration || ((exit_code++))
    fi
    
    # Mostrar resumen
    show_verify_summary "$exit_code"
    
    return $exit_code
}

# Verificar estructura del proyecto
verify_project_structure() {
    log_subsection "Estructura del Proyecto" "📁"
    
    local issues=0
    
    # Archivos esenciales
    check_file "package.json" || ((issues++))
    check_file "README.md" || ((issues++))
    check_file ".gitignore" || ((issues++))
    
    # Directorios comunes
    check_directory "src" || log_warning "Directorio 'src' no encontrado"
    
    # Archivos de configuración comunes
    if [[ -f "package.json" ]]; then
        local project_type=$(detect_project_type)
        log_info "Tipo de proyecto detectado: $(color_info "$project_type")"
        
        case "$project_type" in
            "react")
                check_file "public/index.html" || log_warning "index.html no encontrado en public/"
                ;;
            "node")
                check_file "index.js" || check_file "server.js" || log_warning "Archivo de entrada no encontrado"
                ;;
        esac
    fi
    
    return $issues
}

# Verificar dependencias
verify_dependencies() {
    log_subsection "Dependencias" "📦"
    
    local issues=0
    
    if [[ -f "package.json" ]]; then
        # Verificar node_modules
        if [[ ! -d "node_modules" ]]; then
            log_error "node_modules no encontrado. Ejecutar: npm install"
            ((issues++))
        else
            log_success "node_modules presente"
            
            # Verificar integridad
            if command -v npm > /dev/null; then
                if npm ls > /dev/null 2>&1; then
                    log_success "Dependencias íntegras"
                else
                    log_warning "Algunas dependencias pueden estar rotas"
                    ((issues++))
                fi
            fi
        fi
        
        # Verificar vulnerabilidades
        if command -v npm > /dev/null; then
            log_process "Verificando vulnerabilidades..."
            if npm audit > /dev/null 2>&1; then
                log_success "Sin vulnerabilidades críticas"
            else
                log_warning "Vulnerabilidades detectadas. Ejecutar: npm audit fix"
            fi
        fi
    else
        log_error "package.json no encontrado"
        ((issues++))
    fi
    
    return $issues
}

# Verificar configuración
verify_configuration() {
    log_subsection "Configuración" "⚙️"
    
    local issues=0
    
    # TypeScript
    if [[ -f "tsconfig.json" ]]; then
        if validate_json "tsconfig.json"; then
            log_success "tsconfig.json válido"
        else
            log_error "tsconfig.json inválido"
            ((issues++))
        fi
    fi
    
    # ESLint
    if [[ -f ".eslintrc.js" ]] || [[ -f ".eslintrc.json" ]] || [[ -f ".eslintrc.yml" ]]; then
        log_success "Configuración de ESLint encontrada"
    else
        log_warning "ESLint no configurado"
    fi
    
    # Prettier
    if [[ -f "prettier.config.js" ]] || [[ -f ".prettierrc" ]]; then
        log_success "Configuración de Prettier encontrada"
    else
        log_warning "Prettier no configurado"
    fi
    
    return $issues
}

# Verificar herramientas
verify_tools() {
    log_subsection "Herramientas" "🔧"
    
    local issues=0
    
    # Node.js
    if command -v node > /dev/null; then
        local node_version=$(node --version)
        log_success "Node.js: $node_version"
    else
        log_error "Node.js no instalado"
        ((issues++))
    fi
    
    # npm/yarn/pnpm
    local package_manager=$(detect_package_manager)
    if command -v "$package_manager" > /dev/null; then
        local pm_version=$($package_manager --version)
        log_success "$package_manager: $pm_version"
    else
        log_error "$package_manager no instalado"
        ((issues++))
    fi
    
    # Git
    if command -v git > /dev/null; then
        local git_version=$(git --version)
        log_success "$git_version"
    else
        log_warning "Git no instalado"
    fi
    
    return $issues
}

# Funciones auxiliares
check_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        log_success "$file encontrado"
        return 0
    else
        log_error "$file no encontrado"
        return 1
    fi
}

check_directory() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        log_success "Directorio $dir presente"
        return 0
    else
        log_warning "Directorio $dir no encontrado"
        return 1
    fi
}

validate_json() {
    local file="$1"
    if command -v jq > /dev/null; then
        jq empty "$file" 2>/dev/null
    elif command -v python3 > /dev/null; then
        python3 -m json.tool "$file" > /dev/null 2>&1
    else
        # Validación básica
        grep -q '{' "$file" && grep -q '}' "$file"
    fi
}

detect_project_type() {
    if [[ -f "package.json" ]] && grep -q '"react"' package.json; then
        echo "react"
    elif [[ -f "package.json" ]] && grep -q '"express"' package.json; then
        echo "node"
    elif [[ -f "package.json" ]]; then
        echo "javascript"
    else
        echo "unknown"
    fi
}

detect_package_manager() {
    if [[ -f "pnpm-lock.yaml" ]]; then
        echo "pnpm"
    elif [[ -f "yarn.lock" ]]; then
        echo "yarn"
    else
        echo "npm"
    fi
}

show_verify_summary() {
    local exit_code="$1"
    
    log_section "RESUMEN DE VERIFICACIÓN" "📊"
    
    if [[ "$exit_code" -eq 0 ]]; then
        log_success "Verificación completada sin errores críticos"
        echo "$(icon_celebrate) ¡Proyecto listo para desarrollo!"
    elif [[ "$exit_code" -lt 3 ]]; then
        log_warning "Verificación completada con $exit_code advertencias"
        echo "$(icon_thinking) El proyecto es funcional pero se recomiendan mejoras"
    else
        log_error "Verificación falló con $exit_code errores críticos"
        echo "$(icon_sad) Se requiere atención antes de continuar"
    fi
}

show_verify_help() {
    echo "$(icon_verify) DevTools Verify - Verificación de Proyectos"
    echo
    echo "DESCRIPCIÓN:"
    echo "  Verifica la estructura, dependencias y configuración del proyecto"
    echo
    echo "USO:"
    echo "  ./devTools verify [OPCIONES]"
    echo
    echo "OPCIONES:"
    echo "  --verbose, -v      Salida detallada"
    echo "  --quiet, -q        Solo errores críticos"
    echo "  --path <dir>       Verificar proyecto en ruta específica"
    echo "  --deps-only        Solo verificar dependencias"
    echo "  --config-only      Solo verificar configuraciones"
    echo "  --help, -h         Mostrar esta ayuda"
    echo
    echo "EJEMPLOS:"
    echo "  ./devTools verify"
    echo "  ./devTools verify --verbose"
    echo "  ./devTools verify --path ../mi-proyecto"
    echo "  ./devTools verify --deps-only"
}
