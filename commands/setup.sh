#!/bin/bash

# ⚙️ DevTools Setup Command
# ========================
# Descripción: Configuración automática de entornos de desarrollo

cmd_setup() {
    log_section "SETUP" "⚙️"
    log_info "Iniciando configuración del entorno..."
    
    # Procesar argumentos
    local force=false
    local interactive=false
    local deps_only=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --force|-f) force=true; shift ;;
            --interactive|-i) interactive=true; shift ;;
            --deps-only) deps_only=true; shift ;;
            --help|-h) show_setup_help; return 0 ;;
            *) log_error "Opción desconocida: $1"; return 1 ;;
        esac
    done
    
    local exit_code=0
    
    if [[ "$deps_only" == "true" ]]; then
        setup_dependencies || ((exit_code++))
    else
        setup_dependencies || ((exit_code++))
        setup_configuration || ((exit_code++))
        setup_environment || ((exit_code++))
    fi
    
    show_setup_summary "$exit_code"
    return $exit_code
}

setup_dependencies() {
    log_subsection "Instalación de Dependencias" "📦"
    
    if [[ -f "package.json" ]]; then
        local pm=$(detect_package_manager)
        log_process "Instalando dependencias con $pm..."
        
        case "$pm" in
            "pnpm") pnpm install ;;
            "yarn") yarn install ;;
            *) npm install ;;
        esac
        
        if [[ $? -eq 0 ]]; then
            log_success "Dependencias instaladas exitosamente"
            return 0
        else
            log_error "Error instalando dependencias"
            return 1
        fi
    else
        log_warning "package.json no encontrado, omitiendo instalación"
        return 0
    fi
}

setup_configuration() {
    log_subsection "Configuración de Herramientas" "🔧"
    
    # Generar configuraciones básicas si no existen
    if [[ ! -f ".eslintrc.js" ]] && [[ -f "package.json" ]]; then
        log_process "Creando configuración de ESLint..."
        create_eslint_config
    fi
    
    if [[ ! -f "prettier.config.js" ]]; then
        log_process "Creando configuración de Prettier..."
        create_prettier_config
    fi
    
    return 0
}

setup_environment() {
    log_subsection "Variables de Entorno" "🌐"
    
    if [[ ! -f ".env.example" ]]; then
        log_process "Creando plantilla de variables de entorno..."
        create_env_template
    fi
    
    return 0
}

create_eslint_config() {
    cat > .eslintrc.js << 'EOF'
module.exports = {
  root: true,
  env: { browser: true, es2020: true, node: true },
  extends: ['eslint:recommended'],
  ignorePatterns: ['dist', '.eslintrc.cjs'],
  rules: {},
}
EOF
    log_success ".eslintrc.js creado"
}

create_prettier_config() {
    cat > prettier.config.js << 'EOF'
module.exports = {
  semi: true,
  trailingComma: 'es5',
  singleQuote: true,
  printWidth: 80,
  tabWidth: 2,
  useTabs: false,
}
EOF
    log_success "prettier.config.js creado"
}

create_env_template() {
    cat > .env.example << 'EOF'
# Variables de entorno para desarrollo
NODE_ENV=development
PORT=3000
# API_KEY=tu_api_key_aqui
EOF
    log_success ".env.example creado"
}

show_setup_summary() {
    local exit_code="$1"
    log_section "RESUMEN DE SETUP" "📊"
    
    if [[ "$exit_code" -eq 0 ]]; then
        log_success "Configuración completada exitosamente"
    else
        log_error "Setup completado con $exit_code errores"
    fi
}

show_setup_help() {
    echo "$(icon_setup) DevTools Setup - Configuración Automática"
    echo
    echo "DESCRIPCIÓN:"
    echo "  Configura automáticamente el entorno de desarrollo"
    echo
    echo "USO:"
    echo "  ./devTools setup [OPCIONES]"
    echo
    echo "OPCIONES:"
    echo "  --force, -f        Sobrescribir configuraciones existentes"
    echo "  --interactive, -i  Modo interactivo con confirmaciones"
    echo "  --deps-only        Solo instalar dependencias"
    echo "  --help, -h         Mostrar esta ayuda"
}
