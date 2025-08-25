#!/bin/bash

# 🔄 DevTools Update Command
# =========================
# Descripción: Actualización de dependencias y herramientas

cmd_update() {
    log_section "UPDATE" "🔄"
    log_info "Iniciando actualización del sistema..."
    
    local check_only=false
    local security_only=false
    local interactive=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --check-only) check_only=true; shift ;;
            --security-only) security_only=true; shift ;;
            --interactive|-i) interactive=true; shift ;;
            --help|-h) show_update_help; return 0 ;;
            *) log_error "Opción desconocida: $1"; return 1 ;;
        esac
    done
    
    if [[ "$check_only" == "true" ]]; then
        check_updates
    else
        perform_updates "$security_only" "$interactive"
    fi
}

check_updates() {
    log_subsection "Verificando Actualizaciones" "🔍"
    
    if [[ -f "package.json" ]]; then
        local pm=$(detect_package_manager)
        
        case "$pm" in
            "npm")
                if command -v npm > /dev/null; then
                    log_process "Verificando actualizaciones con npm..."
                    npm outdated 2>/dev/null || log_info "Todas las dependencias actualizadas"
                fi
                ;;
            "yarn")
                if command -v yarn > /dev/null; then
                    log_process "Verificando actualizaciones con yarn..."
                    yarn outdated 2>/dev/null || log_info "Todas las dependencias actualizadas"
                fi
                ;;
            "pnpm")
                if command -v pnpm > /dev/null; then
                    log_process "Verificando actualizaciones con pnpm..."
                    pnpm outdated 2>/dev/null || log_info "Todas las dependencias actualizadas"
                fi
                ;;
        esac
    fi
    
    # Verificar vulnerabilidades
    if command -v npm > /dev/null && [[ -f "package.json" ]]; then
        log_process "Verificando vulnerabilidades de seguridad..."
        if npm audit --audit-level=high > /dev/null 2>&1; then
            log_success "Sin vulnerabilidades críticas"
        else
            log_warning "Vulnerabilidades detectadas. Usar --security-only para parchar"
        fi
    fi
}

perform_updates() {
    local security_only="$1"
    local interactive="$2"
    
    if [[ ! -f "package.json" ]]; then
        log_error "package.json no encontrado"
        return 1
    fi
    
    local pm=$(detect_package_manager)
    
    if [[ "$security_only" == "true" ]]; then
        log_subsection "Aplicando Parches de Seguridad" "🛡️"
        
        case "$pm" in
            "npm")
                log_process "Aplicando parches con npm audit fix..."
                npm audit fix
                ;;
            "yarn")
                log_process "Aplicando parches con yarn audit fix..."
                yarn audit fix 2>/dev/null || log_warning "yarn audit fix no disponible"
                ;;
            "pnpm")
                log_process "Aplicando parches con pnpm audit fix..."
                pnpm audit fix 2>/dev/null || log_warning "pnpm audit fix no disponible"
                ;;
        esac
    else
        log_subsection "Actualizando Dependencias" "📦"
        
        if [[ "$interactive" == "true" ]]; then
            log_info "Modo interactivo no implementado aún. Usando actualización automática."
        fi
        
        case "$pm" in
            "npm")
                log_process "Actualizando con npm update..."
                npm update
                ;;
            "yarn")
                log_process "Actualizando con yarn upgrade..."
                yarn upgrade
                ;;
            "pnpm")
                log_process "Actualizando con pnpm update..."
                pnpm update
                ;;
        esac
    fi
    
    log_success "Actualización completada"
}

show_update_help() {
    echo "$(icon_update) DevTools Update - Actualización del Sistema"
    echo
    echo "DESCRIPCIÓN:"
    echo "  Actualiza dependencias y aplica parches de seguridad"
    echo
    echo "USO:"
    echo "  ./devTools update [OPCIONES]"
    echo
    echo "OPCIONES:"
    echo "  --check-only       Solo verificar actualizaciones disponibles"
    echo "  --security-only    Solo aplicar parches de seguridad"
    echo "  --interactive, -i  Modo interactivo con confirmaciones"
    echo "  --help, -h         Mostrar esta ayuda"
}
