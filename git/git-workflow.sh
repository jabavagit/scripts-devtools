#!/bin/bash
# 🔧 Git Workflow Helper
# Comandos Git comunes para el flujo de trabajo del proyecto

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

show_help() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║              🔧 GIT WORKFLOW                 ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo "Uso: $0 <comando> [argumentos]"
    echo ""
    echo "Comandos disponibles:"
    echo ""
    echo -e "${GREEN}📝 Desarrollo:${NC}"
    echo "  save [mensaje]     - Hacer commit rápido con mensaje"
    echo "  sync              - Sincronizar rama actual con origin"
    echo "  status            - Estado completo del repositorio"
    echo ""
    echo -e "${GREEN}🔄 Branching:${NC}"
    echo "  switch <rama>     - Cambiar de rama con verificaciones"
    echo "  list              - Listar todas las ramas"
    echo "  clean             - Limpiar ramas mergeadas"
    echo ""
    echo -e "${GREEN}🚀 Release:${NC}"
    echo "  release           - Crear nueva rama release"
    echo "  hotfix            - Crear nueva rama hotfix"
    echo ""
    echo -e "${GREEN}🛠️ Utilidades:${NC}"
    echo "  undo              - Deshacer último commit (mantiene cambios)"
    echo "  reset             - Reset hard a estado limpio"
    echo "  stash             - Gestión de stash interactiva"
    echo ""
    echo "Ejemplos:"
    echo "  $0 save \"feat: nueva funcionalidad\""
    echo "  $0 switch develop"
    echo "  $0 clean"
}

# Función para commit rápido
quick_save() {
    local message="$1"

    if [ -z "$message" ]; then
        read -p "Mensaje del commit: " message
    fi

    if [ -z "$message" ]; then
        message="chore: cambios rápidos - $(date '+%Y-%m-%d %H:%M')"
    fi

    log "STEP" "Guardando cambios..."
    git add .
    git commit -m "$message"

    local current_branch=$(git branch --show-current)
    if git config --get branch.$current_branch.remote > /dev/null 2>&1; then
        read -p "¿Hacer push a origin? (Y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            git push
            log "SUCCESS" "Cambios guardados y enviados a origin"
        else
            log "SUCCESS" "Cambios guardados localmente"
        fi
    else
        log "SUCCESS" "Cambios guardados localmente"
        log "INFO" "Para hacer push: git push -u origin $current_branch"
    fi
}

# Función para sincronizar rama
sync_branch() {
    local current_branch=$(git branch --show-current)

    log "STEP" "Sincronizando rama '$current_branch'..."

    # Verificar cambios sin commit
    if ! git diff-index --quiet HEAD --; then
        log "WARNING" "Tienes cambios sin commit"
        read -p "¿Hacer stash automático? (Y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            git stash push -m "auto-sync-stash-$(date '+%Y%m%d-%H%M%S')"
            log "INFO" "Cambios guardados en stash"
        else
            log "ERROR" "No se puede sincronizar con cambios sin commit"
            return 1
        fi
    fi

    git fetch origin

    if git config --get branch.$current_branch.remote > /dev/null 2>&1; then
        git pull origin $current_branch
        log "SUCCESS" "Rama sincronizada con origin"
    else
        log "WARNING" "Rama no configurada para tracking con origin"
    fi

    # Recuperar stash si existe
    if git stash list | grep -q "auto-sync-stash"; then
        read -p "¿Recuperar cambios del stash? (Y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            git stash pop
            log "INFO" "Cambios recuperados del stash"
        fi
    fi
}

# Función para estado completo
show_status() {
    local current_branch=$(git branch --show-current)

    echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                ESTADO DEL REPO               ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
    echo ""

    echo -e "${GREEN}📍 Rama actual:${NC} $current_branch"
    echo ""

    echo -e "${GREEN}📊 Estado de archivos:${NC}"
    git status --porcelain
    echo ""

    echo -e "${GREEN}📝 Últimos commits:${NC}"
    git log --oneline -5
    echo ""

    echo -e "${GREEN}🌿 Ramas locales:${NC}"
    git branch
    echo ""

    if git stash list | grep -q .; then
        echo -e "${GREEN}📦 Stash:${NC}"
        git stash list
        echo ""
    fi
}

# Función para cambiar rama con verificaciones
safe_switch() {
    local target_branch="$1"

    if [ -z "$target_branch" ]; then
        log "ERROR" "Especifica la rama de destino"
        return 1
    fi

    # Verificar que la rama existe
    if ! git show-ref --verify --quiet refs/heads/$target_branch; then
        if git show-ref --verify --quiet refs/remotes/origin/$target_branch; then
            log "INFO" "Creando rama local '$target_branch' desde origin"
            git checkout -b $target_branch origin/$target_branch
            return
        else
            log "ERROR" "La rama '$target_branch' no existe"
            return 1
        fi
    fi

    # Verificar cambios sin commit
    if ! git diff-index --quiet HEAD --; then
        log "WARNING" "Tienes cambios sin commit"
        read -p "¿Hacer stash automático? (Y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            git stash push -m "auto-switch-stash-$(date '+%Y%m%d-%H%M%S')"
            log "INFO" "Cambios guardados en stash"
        else
            log "ERROR" "No se puede cambiar de rama con cambios sin commit"
            return 1
        fi
    fi

    git checkout $target_branch
    log "SUCCESS" "Cambiado a rama '$target_branch'"
}

# Función para limpiar ramas mergeadas
clean_branches() {
    log "STEP" "Identificando ramas mergeadas..."

    # Obtener ramas mergeadas (excluyendo develop y master)
    local merged_branches=$(git branch --merged | grep -v -E "(develop|master|main|\*)" | xargs)

    if [ -z "$merged_branches" ]; then
        log "INFO" "No hay ramas locales para limpiar"
        return
    fi

    echo -e "${YELLOW}Ramas mergeadas encontradas:${NC}"
    echo "$merged_branches"
    echo ""

    read -p "¿Eliminar estas ramas? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "$merged_branches" | xargs git branch -d
        log "SUCCESS" "Ramas limpias eliminadas"
    else
        log "INFO" "Limpieza cancelada"
    fi
}

# Función para deshacer último commit
undo_commit() {
    log "INFO" "Último commit:"
    git log --oneline -1
    echo ""

    read -p "¿Deshacer este commit? Los cambios se mantendrán. (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git reset --soft HEAD~1
        log "SUCCESS" "Commit deshecho, cambios mantenidos en staging"
    else
        log "INFO" "Operación cancelada"
    fi
}

# Función para gestión de stash
manage_stash() {
    if ! git stash list | grep -q .; then
        log "INFO" "No hay elementos en stash"
        return
    fi

    echo -e "${GREEN}📦 Elementos en stash:${NC}"
    git stash list
    echo ""

    echo "Opciones:"
    echo "  1) Ver diferencias"
    echo "  2) Aplicar último stash"
    echo "  3) Eliminar último stash"
    echo "  4) Limpiar todo el stash"
    echo "  5) Salir"

    read -p "Selecciona opción (1-5): " -n 1 -r
    echo

    case $REPLY in
        1) git stash show -p ;;
        2) git stash pop ;;
        3) git stash drop ;;
        4)
            read -p "¿Estás seguro de limpiar todo el stash? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                git stash clear
                log "SUCCESS" "Stash limpiado"
            fi
            ;;
        5) log "INFO" "Saliendo..." ;;
        *) log "ERROR" "Opción inválida" ;;
    esac
}

# Función principal
main() {
    if [ $# -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_help
        exit 0
    fi

    local command="$1"
    shift

    case $command in
        "save")
            quick_save "$*"
            ;;
        "sync")
            sync_branch
            ;;
        "status")
            show_status
            ;;
        "switch")
            safe_switch "$1"
            ;;
        "list")
            echo -e "${GREEN}🌿 Ramas locales:${NC}"
            git branch
            echo ""
            echo -e "${GREEN}🌐 Ramas remotas:${NC}"
            git branch -r
            ;;
        "clean")
            clean_branches
            ;;
        "undo")
            undo_commit
            ;;
        "reset")
            log "WARNING" "Esto eliminará TODOS los cambios sin commit"
            read -p "¿Estás seguro? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                git reset --hard HEAD
                git clean -fd
                log "SUCCESS" "Repositorio reseteado a estado limpio"
            fi
            ;;
        "stash")
            manage_stash
            ;;
        *)
            log "ERROR" "Comando desconocido: $command"
            echo "Usa '$0 --help' para ver comandos disponibles"
            exit 1
            ;;
    esac
}

main "$@"
