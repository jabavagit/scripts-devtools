#!/bin/bash
# 🚀 Setup inicial para nuevos desarrolladores
# Configura el entorno de desarrollo completo

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%H:%M:%S')

    case $level in
        "INFO") echo -e "${CYAN}[INFO ${timestamp}]${NC} $message" ;;
        "SUCCESS") echo -e "${GREEN}[SUCCESS ${timestamp}]${NC} $message" ;;
        "WARNING") echo -e "${YELLOW}[WARNING ${timestamp}]${NC} $message" ;;
        "ERROR") echo -e "${RED}[ERROR ${timestamp}]${NC} $message" ;;
        "STEP") echo -e "${PURPLE}[STEP ${timestamp}]${NC} $message" ;;
    esac
}

show_welcome() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║                    🚀 NEXTJS CALENDAR APP SETUP                     ║"
    echo "║                                                                      ║"
    echo "║  Configuración inicial para desarrolladores                         ║"
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

check_requirements() {
    log "STEP" "Verificando requisitos del sistema..."

    # Node.js
    if command -v node > /dev/null 2>&1; then
        local node_version=$(node --version)
        log "SUCCESS" "Node.js: $node_version"

        # Verificar versión mínima
        local required_major=18
        local current_major=$(echo $node_version | cut -d'.' -f1 | sed 's/v//')
        if [ "$current_major" -lt "$required_major" ]; then
            log "ERROR" "Node.js version >= v18.0.0 requerida. Actual: $node_version"
            exit 1
        fi
    else
        log "ERROR" "Node.js no encontrado. Instala Node.js >= v18.0.0"
        exit 1
    fi

    # npm
    if command -v npm > /dev/null 2>&1; then
        local npm_version=$(npm --version)
        log "SUCCESS" "npm: v$npm_version"
    else
        log "ERROR" "npm no encontrado"
        exit 1
    fi

    # Git
    if command -v git > /dev/null 2>&1; then
        local git_version=$(git --version)
        log "SUCCESS" "$git_version"
    else
        log "ERROR" "Git no encontrado"
        exit 1
    fi

    echo ""
}

setup_git() {
    log "STEP" "Configurando Git..."

    # Verificar configuración de usuario
    if ! git config user.name > /dev/null 2>&1; then
        read -p "Nombre para Git: " git_name
        git config --global user.name "$git_name"
        log "INFO" "Nombre configurado: $git_name"
    else
        local current_name=$(git config user.name)
        log "INFO" "Git usuario: $current_name"
    fi

    if ! git config user.email > /dev/null 2>&1; then
        read -p "Email para Git: " git_email
        git config --global user.email "$git_email"
        log "INFO" "Email configurado: $git_email"
    else
        local current_email=$(git config user.email)
        log "INFO" "Git email: $current_email"
    fi

    # Configuraciones recomendadas
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.autocrlf input

    log "SUCCESS" "Git configurado correctamente"
    echo ""
}

install_dependencies() {
    log "STEP" "Instalando dependencias..."

    if [ ! -d "node_modules" ]; then
        npm install
        log "SUCCESS" "Dependencias instaladas"
    else
        log "INFO" "Dependencias ya instaladas"
        read -p "¿Reinstalar dependencias? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf node_modules package-lock.json
            npm install
            log "SUCCESS" "Dependencias reinstaladas"
        fi
    fi
    echo ""
}

setup_database() {
    log "STEP" "Configurando base de datos..."

    # Generar cliente Prisma
    npx prisma generate

    # Verificar si la BD existe
    if [ ! -f "prisma/dev.db" ]; then
        log "INFO" "Creando base de datos SQLite..."
        npx prisma migrate dev --name init
        log "SUCCESS" "Base de datos creada"

        # Poblar con datos de ejemplo
        read -p "¿Poblar con datos de ejemplo? (Y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            npm run db:seed
            log "SUCCESS" "Datos de ejemplo agregados"
        fi
    else
        log "INFO" "Base de datos ya existe"

        # Verificar migraciones pendientes
        if npx prisma migrate status | grep -q "following migration have not yet been applied"; then
            log "WARNING" "Hay migraciones pendientes"
            read -p "¿Aplicar migraciones? (Y/n): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                npx prisma migrate dev
                log "SUCCESS" "Migraciones aplicadas"
            fi
        else
            log "SUCCESS" "Base de datos actualizada"
        fi
    fi
    echo ""
}

setup_environment() {
    log "STEP" "Configurando variables de entorno..."

    if [ ! -f ".env" ] && [ -f ".env.example" ]; then
        cp .env.example .env
        log "SUCCESS" "Archivo .env creado desde .env.example"
        log "INFO" "Revisa y actualiza las variables en .env"
    elif [ ! -f ".env" ]; then
        log "INFO" "Creando archivo .env básico..."
        cat > .env << EOF
# Database
DATABASE_URL="file:./dev.db"

# Next.js
NEXT_PUBLIC_APP_NAME="NextJS Calendar App"
NEXT_PUBLIC_APP_VERSION="0.2.1"

# Development
NODE_ENV="development"
EOF
        log "SUCCESS" "Archivo .env creado"
    else
        log "INFO" "Archivo .env ya existe"
    fi
    echo ""
}

run_quality_checks() {
    log "STEP" "Ejecutando verificaciones de calidad..."

    # Type checking
    log "INFO" "Verificando tipos..."
    npm run type-check

    # Linting
    log "INFO" "Verificando código..."
    npm run lint

    # Build test
    log "INFO" "Probando build..."
    npm run build

    log "SUCCESS" "Todas las verificaciones pasaron"
    echo ""
}

setup_husky() {
    log "STEP" "Configurando Git hooks..."

    if [ -d ".git" ]; then
        npm run prepare
        log "SUCCESS" "Husky configurado para Git hooks"
    else
        log "WARNING" "No es un repositorio Git, saltando configuración de hooks"
    fi
    echo ""
}

show_next_steps() {
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║                        ✅ SETUP COMPLETADO                          ║"
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo -e "${CYAN}🎯 Próximos pasos:${NC}"
    echo ""
    echo -e "${YELLOW}1. Desarrollo:${NC}"
    echo "   npm run dev                    # Iniciar servidor de desarrollo"
    echo "   npm run db:studio              # Abrir Prisma Studio"
    echo ""
    echo -e "${YELLOW}2. Git workflow:${NC}"
    echo "   npm run new:feature            # Crear nueva rama de feature"
    echo "   npm run git:save \"mensaje\"     # Commit rápido"
    echo "   npm run merge:develop          # Mergear a develop"
    echo ""
    echo -e "${YELLOW}3. Calidad de código:${NC}"
    echo "   npm run verify                 # Verificación completa"
    echo "   npm run fix                    # Arreglar formato y lint"
    echo ""
    echo -e "${YELLOW}4. Base de datos:${NC}"
    echo "   npm run db:migrate             # Crear migración"
    echo "   npm run db:reset               # Reset completo"
    echo "   npm run db:seed                # Datos de ejemplo"
    echo ""
    echo -e "${YELLOW}5. Documentación:${NC}"
    echo "   README.md                      # Documentación principal"
    echo "   .docs/                         # Documentación Docusaurus"
    echo ""
    echo -e "${CYAN}🎉 ¡Listo para desarrollar!${NC}"
    echo ""
}

# Función principal
main() {
    show_welcome

    check_requirements
    setup_git
    install_dependencies
    setup_environment
    setup_database
    setup_husky
    run_quality_checks

    show_next_steps
}

# Ejecutar setup
main
