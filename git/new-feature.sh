#!/bin/bash
# 🌟 Script de Creación de Rama Feature
# Automatiza la creación de nuevas ramas feature desde develop

set -e  # Salir en caso de error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para logging con colores
log() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%H:%M:%S')

    case $level in
        "INFO")
            echo -e "${CYAN}[INFO ${timestamp}]${NC} $message"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS ${timestamp}]${NC} $message"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING ${timestamp}]${NC} $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR ${timestamp}]${NC} $message"
            ;;
        "STEP")
            echo -e "${PURPLE}[STEP ${timestamp}]${NC} $message"
            ;;
    esac
}

# Función para mostrar banner
show_banner() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║           🌟 NEW FEATURE BRANCH             ║"
    echo "║                                              ║"
    echo "║    Crea nueva rama feature desde develop     ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Función para validar nombre de rama
validate_branch_name() {
    local branch_name=$1

    # Verificar que no esté vacío
    if [ -z "$branch_name" ]; then
        log "ERROR" "El nombre de la rama no puede estar vacío"
        return 1
    fi

    # Verificar caracteres válidos (solo letras, números, guiones y barras)
    if [[ ! $branch_name =~ ^[a-zA-Z0-9/_-]+$ ]]; then
        log "ERROR" "El nombre de la rama contiene caracteres inválidos"
        log "INFO" "Solo se permiten letras, números, guiones (-), barras (/) y guiones bajos (_)"
        return 1
    fi

    # Verificar que no empiece o termine con guión o barra
    if [[ $branch_name =~ ^[-/]|[-/]$ ]]; then
        log "ERROR" "El nombre de la rama no puede empezar o terminar con guión o barra"
        return 1
    fi

    # Verificar que la rama no exista ya
    if git show-ref --verify --quiet refs/heads/$branch_name; then
        log "ERROR" "La rama '$branch_name' ya existe localmente"
        return 1
    fi

    if git show-ref --verify --quiet refs/remotes/origin/$branch_name; then
        log "ERROR" "La rama '$branch_name' ya existe en origin"
        return 1
    fi

    return 0
}

# Función para sugerir nombres de rama
suggest_branch_names() {
    echo -e "${YELLOW}Sugerencias de nombres de rama:${NC}"
    echo "  • feat/nueva-funcionalidad"
    echo "  • fix/corregir-bug"
    echo "  • refactor/mejorar-codigo"
    echo "  • docs/actualizar-documentacion"
    echo "  • test/agregar-tests"
    echo "  • chore/tareas-mantenimiento"
    echo ""
    echo "Ejemplos específicos:"
    echo "  • feat/user-authentication"
    echo "  • fix/calendar-display-bug"
    echo "  • refactor/api-client-structure"
    echo "  • feat/add-notifications"
    echo ""
}

# Función para obtener nombre de rama
get_branch_name() {
    local branch_name=""

    # Si se pasó como argumento
    if [ ! -z "$1" ]; then
        branch_name="$1"
    else
        # Solicitar interactivamente
        suggest_branch_names
        read -p "Nombre de la nueva rama: " branch_name
    fi

    if validate_branch_name "$branch_name"; then
        echo "$branch_name"
    else
        exit 1
    fi
}

# Función para actualizar develop
update_develop() {
    log "STEP" "Actualizando rama develop..."

    # Verificar cambios sin commit
    if ! git diff-index --quiet HEAD --; then
        log "WARNING" "Tienes cambios sin commit"
        read -p "¿Quieres hacer stash de estos cambios? (Y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            git stash push -m "auto-stash antes de crear rama feature $(date)"
            log "INFO" "Cambios guardados en stash"
        else
            log "ERROR" "No se puede continuar con cambios sin commit"
            exit 1
        fi
    fi

    # Cambiar a develop
    git checkout develop

    # Actualizar desde origin
    log "INFO" "Haciendo fetch de origin..."
    git fetch origin

    log "INFO" "Actualizando develop desde origin/develop..."
    git pull origin develop

    log "SUCCESS" "Develop actualizado"
}

# Función para crear rama
create_branch() {
    local branch_name=$1

    log "STEP" "Creando nueva rama '$branch_name'..."

    # Crear y cambiar a la nueva rama
    git checkout -b "$branch_name"

    log "SUCCESS" "Rama '$branch_name' creada y activa"
}

# Función para configuración inicial
setup_branch() {
    local branch_name=$1

    log "STEP" "Configurando rama '$branch_name'..."

    # Push inicial para crear rama en origin
    read -p "¿Quieres hacer push inicial a origin? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        git push -u origin "$branch_name"
        log "SUCCESS" "Rama creada en origin y configurada para tracking"
    else
        log "INFO" "Rama solo creada localmente"
        log "INFO" "Para hacer push más tarde: git push -u origin $branch_name"
    fi
}

# Función para crear commit inicial
create_initial_commit() {
    local branch_name=$1

    read -p "¿Quieres crear un commit inicial vacío? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git commit --allow-empty -m "feat: inicia desarrollo de $branch_name

- Rama creada desde develop
- Commit inicial para tracking
- Fecha: $(date '+%Y-%m-%d %H:%M:%S')"

        log "SUCCESS" "Commit inicial creado"

        # Push del commit si la rama está configurada
        if git config --get branch.$branch_name.remote > /dev/null 2>&1; then
            git push
        fi
    fi
}

# Función para mostrar resumen
show_summary() {
    local branch_name=$1

    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║            ✅ RAMA CREADA                    ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"

    log "SUCCESS" "Nueva rama '$branch_name' lista para desarrollo"
    log "INFO" "Rama actual: $(git branch --show-current)"
    log "INFO" "Base: develop ($(git rev-parse --short develop))"

    echo -e "${BLUE}"
    echo "Próximos pasos:"
    echo "  • Comenzar desarrollo en la nueva rama"
    echo "  • Hacer commits regulares: git add . && git commit -m \"mensaje\""
    echo "  • Cuando esté lista: npm run merge:develop"
    echo -e "${NC}"

    # Mostrar información del stash si existe
    if git stash list | grep -q "auto-stash"; then
        echo -e "${YELLOW}"
        echo "📝 Recordatorio: Tienes cambios en stash"
        echo "   Para recuperarlos: git stash pop"
        echo -e "${NC}"
    fi
}

# Función principal
main() {
    show_banner

    # Verificar que estamos en un repositorio git
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log "ERROR" "No estás en un repositorio Git"
        exit 1
    fi

    # Obtener nombre de rama
    local branch_name=$(get_branch_name "$1")

    log "INFO" "Creando rama: '$branch_name'"
    log "INFO" "Base: develop"

    # Confirmar acción
    echo -e "${YELLOW}¿Continuar con la creación de la rama '$branch_name'? (Y/n)${NC}"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        log "INFO" "Operación cancelada por el usuario"
        exit 0
    fi

    # Ejecutar pasos
    update_develop
    create_branch "$branch_name"
    setup_branch "$branch_name"
    create_initial_commit "$branch_name"
    show_summary "$branch_name"

    log "SUCCESS" "¡Nueva rama lista para desarrollo! 🚀"
}

# Verificar argumentos
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Uso: $0 [nombre-rama]"
    echo ""
    echo "Script para crear nueva rama feature desde develop"
    echo ""
    echo "Opciones:"
    echo "  -h, --help    Mostrar esta ayuda"
    echo ""
    echo "Argumentos:"
    echo "  nombre-rama   Nombre de la nueva rama (opcional, se puede ingresar interactivamente)"
    echo ""
    echo "El script realiza las siguientes acciones:"
    echo "  1. Verifica que no exista la rama"
    echo "  2. Actualiza develop desde origin"
    echo "  3. Crea nueva rama desde develop"
    echo "  4. Opcionalmente hace push inicial"
    echo "  5. Opcionalmente crea commit inicial"
    echo ""
    echo "Ejemplos:"
    echo "  $0                           # Crear rama interactivamente"
    echo "  $0 feat/nueva-funcionalidad  # Crear rama con nombre específico"
    echo "  $0 fix/bug-calendario        # Crear rama para fix"
    exit 0
fi

# Ejecutar función principal
main "$1"
