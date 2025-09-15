#!/bin/bash
# 🔄 Script de Merge Automático a Develop
# Automatiza el proceso de merge de la rama actual a develop
# con actualización previa y validaciones

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
    echo "║           🔄 MERGE TO DEVELOP SCRIPT         ║"
    echo "║                                              ║"
    echo "║  Automatiza el merge de rama actual a develop ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Función para verificar prerrequisitos
check_prerequisites() {
    log "STEP" "Verificando prerrequisitos..."

    # Verificar que estamos en un repositorio git
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log "ERROR" "No estás en un repositorio Git"
        exit 1
    fi

    # Verificar que existe la rama develop
    if ! git show-ref --verify --quiet refs/heads/develop; then
        if ! git show-ref --verify --quiet refs/remotes/origin/develop; then
            log "ERROR" "La rama 'develop' no existe local ni remotamente"
            exit 1
        else
            log "INFO" "Creando rama local 'develop' desde origin/develop"
            git checkout -b develop origin/develop
        fi
    fi

    log "SUCCESS" "Prerrequisitos verificados"
}

# Función para obtener información de la rama actual
get_current_branch() {
    local current_branch=$(git branch --show-current)
    if [ "$current_branch" = "develop" ]; then
        log "ERROR" "Ya estás en la rama 'develop'. No se puede hacer merge de develop a develop."
        exit 1
    fi
    echo "$current_branch"
}

# Función para verificar cambios pendientes
check_dirty_working_tree() {
    log "STEP" "Verificando estado del repositorio..."

    if ! git diff-index --quiet HEAD --; then
        log "WARNING" "Tienes cambios sin commit en el working tree"
        read -p "¿Quieres hacer commit de estos cambios? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log "INFO" "Agregando todos los cambios..."
            git add .
            read -p "Mensaje del commit: " commit_message
            if [ -z "$commit_message" ]; then
                commit_message="chore: commit automático antes de merge"
            fi
            git commit -m "$commit_message"
            log "SUCCESS" "Commit realizado"
        else
            log "ERROR" "No se puede continuar con cambios sin commit"
            exit 1
        fi
    fi

    log "SUCCESS" "Working tree limpio"
}

# Función para ejecutar verificaciones de calidad
run_quality_checks() {
    log "STEP" "Ejecutando verificaciones de calidad..."

    # Verificar que el script npm verify existe
    if npm run verify --dry-run > /dev/null 2>&1; then
        log "INFO" "Ejecutando 'npm run verify'..."
        if npm run verify; then
            log "SUCCESS" "Verificaciones de calidad pasadas"
        else
            log "ERROR" "Las verificaciones de calidad fallaron"
            read -p "¿Quieres continuar de todas formas? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
            log "WARNING" "Continuando a pesar de los errores de verificación"
        fi
    else
        log "WARNING" "Script 'npm run verify' no encontrado, saltando verificaciones"
    fi
}

# Función para actualizar ramas
update_branches() {
    log "STEP" "Actualizando ramas desde origin..."

    # Fetch latest changes
    log "INFO" "Haciendo fetch de origin..."
    git fetch origin

    # Actualizar develop
    log "INFO" "Actualizando rama develop..."
    git checkout develop
    git pull origin develop

    log "SUCCESS" "Ramas actualizadas"
}

# Función para hacer merge
perform_merge() {
    local source_branch=$1

    log "STEP" "Realizando merge de '$source_branch' a 'develop'..."

    # Cambiar a develop
    git checkout develop

    # Hacer merge
    log "INFO" "Ejecutando: git merge '$source_branch'"
    if git merge "$source_branch" --no-ff -m "feat: merge $source_branch into develop

- Integración de cambios de la rama $source_branch
- Merge automático realizado por script
- Fecha: $(date '+%Y-%m-%d %H:%M:%S')"; then
        log "SUCCESS" "Merge completado exitosamente"
    else
        log "ERROR" "Conflictos de merge detectados"
        log "INFO" "Resuelve los conflictos manualmente y ejecuta:"
        log "INFO" "  git add ."
        log "INFO" "  git commit"
        log "INFO" "  git push origin develop"
        exit 1
    fi
}

# Función para push automático
push_changes() {
    log "STEP" "Enviando cambios a origin..."

    read -p "¿Quieres hacer push automático a origin/develop? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        log "INFO" "Push manual requerido: git push origin develop"
        return
    fi

    if git push origin develop; then
        log "SUCCESS" "Push completado exitosamente"
    else
        log "ERROR" "Error en el push"
        exit 1
    fi
}

# Función para limpiar rama feature (opcional)
cleanup_feature_branch() {
    local source_branch=$1

    if [[ $source_branch == "master" || $source_branch == "main" || $source_branch == "develop" ]]; then
        log "INFO" "No se puede eliminar la rama principal '$source_branch'"
        return
    fi

    read -p "¿Quieres eliminar la rama '$source_branch'? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log "INFO" "Eliminando rama local '$source_branch'..."
        git branch -d "$source_branch"

        read -p "¿También eliminar la rama remota 'origin/$source_branch'? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if git push origin --delete "$source_branch"; then
                log "SUCCESS" "Rama remota eliminada"
            else
                log "WARNING" "No se pudo eliminar la rama remota (puede que no exista)"
            fi
        fi

        log "SUCCESS" "Rama local eliminada"
    fi
}

# Función para mostrar resumen final
show_summary() {
    local source_branch=$1

    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║              ✅ MERGE COMPLETADO             ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"

    log "SUCCESS" "Rama '$source_branch' mergeada exitosamente a 'develop'"
    log "INFO" "Resumen de cambios:"
    git log --oneline develop~5..develop

    echo -e "${BLUE}"
    echo "Próximos pasos sugeridos:"
    echo "  • Verificar que la aplicación funciona: npm run dev"
    echo "  • Crear PR para merge a master si es necesario"
    echo "  • Notificar al equipo sobre los cambios"
    echo -e "${NC}"
}

# Función principal
main() {
    show_banner

    # Obtener rama actual antes de cualquier cambio
    current_branch=$(get_current_branch)
    log "INFO" "Rama actual: '$current_branch'"
    log "INFO" "Destino: 'develop'"

    # Confirmar acción
    echo -e "${YELLOW}¿Continuar con el merge de '$current_branch' a 'develop'? (Y/n)${NC}"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        log "INFO" "Operación cancelada por el usuario"
        exit 0
    fi

    # Ejecutar pasos
    check_prerequisites
    check_dirty_working_tree
    run_quality_checks
    update_branches

    # Volver a la rama original para el merge
    log "INFO" "Volviendo a la rama '$current_branch'..."
    git checkout "$current_branch"

    perform_merge "$current_branch"
    push_changes
    cleanup_feature_branch "$current_branch"
    show_summary "$current_branch"

    log "SUCCESS" "¡Proceso completado exitosamente! 🎉"
}

# Verificar argumentos
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Uso: $0 [opciones]"
    echo ""
    echo "Script para automatizar el merge de la rama actual a develop"
    echo ""
    echo "Opciones:"
    echo "  -h, --help    Mostrar esta ayuda"
    echo ""
    echo "El script realiza las siguientes acciones:"
    echo "  1. Verifica prerrequisitos"
    echo "  2. Confirma que no hay cambios sin commit"
    echo "  3. Ejecuta verificaciones de calidad (npm run verify)"
    echo "  4. Actualiza las ramas desde origin"
    echo "  5. Realiza el merge"
    echo "  6. Opcionalmente hace push y limpia la rama"
    echo ""
    echo "Ejemplo:"
    echo "  $0                    # Merge de rama actual a develop"
    exit 0
fi

# Ejecutar función principal
main
