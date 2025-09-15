#!/bin/bash

# 🔧 Git Manager - Gestión centralizada de comandos Git
# Administra todos los flujos de trabajo relacionados con Git

set -euo pipefail

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Directorio base del proyecto
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
GIT_SCRIPTS_DIR="$PROJECT_ROOT/scripts/git"

# Función para mostrar ayuda
show_help() {
    echo -e "${CYAN}🔧 Git Manager - Gestión de Flujos de Trabajo Git${NC}"
    echo -e "${BLUE}Uso: $0 [COMANDO] [OPCIONES]${NC}"
    echo ""
    echo -e "${MAGENTA}📋 COMANDOS DISPONIBLES:${NC}"
    echo ""
    echo -e "${GREEN}🔄 Flujo de Trabajo:${NC}"
    echo -e "  ${YELLOW}save${NC}           Guardar cambios con mensaje automático"
    echo -e "  ${YELLOW}sync${NC}           Sincronizar con remote (pull + push)"
    echo -e "  ${YELLOW}status${NC}         Estado detallado del repositorio"
    echo -e "  ${YELLOW}clean${NC}          Limpiar archivos no tracked"
    echo -e "  ${YELLOW}stash${NC}          Gestionar stash (save/pop/list)"
    echo ""
    echo -e "${GREEN}🌿 Gestión de Ramas:${NC}"
    echo -e "  ${YELLOW}feature${NC}        Crear nueva rama de feature"
    echo -e "  ${YELLOW}merge${NC}          Mergear rama actual a develop"
    echo -e "  ${YELLOW}switch${NC}         Cambiar de rama con verificaciones"
    echo -e "  ${YELLOW}delete${NC}         Eliminar rama local y remota"
    echo ""
    echo -e "${GREEN}📊 Información:${NC}"
    echo -e "  ${YELLOW}log${NC}            Log de commits con formato mejorado"
    echo -e "  ${YELLOW}diff${NC}           Diferencias con highlight"
    echo -e "  ${YELLOW}branches${NC}       Listar todas las ramas"
    echo -e "  ${YELLOW}remotes${NC}        Información de remotos"
    echo ""
    echo -e "${GREEN}🔧 Utilidades:${NC}"
    echo -e "  ${YELLOW}setup${NC}          Configurar entorno de desarrollo"
    echo -e "  ${YELLOW}hooks${NC}          Gestionar git hooks"
    echo -e "  ${YELLOW}config${NC}         Configuración de Git"
    echo ""
    echo -e "${BLUE}📖 EJEMPLOS:${NC}"
    echo -e "  ${CYAN}$0 save \"feat: nueva funcionalidad\"${NC}"
    echo -e "  ${CYAN}$0 feature mi-nueva-feature${NC}"
    echo -e "  ${CYAN}$0 merge${NC}"
    echo -e "  ${CYAN}$0 status${NC}"
    echo ""
    echo -e "${YELLOW}💡 TIP: Usa '$0 status' para ver el estado actual antes de otros comandos${NC}"
}

# Función para verificar si estamos en un repositorio Git
check_git_repo() {
    if ! git rev-parse --git-dir &>/dev/null; then
        echo -e "${RED}❌ Error: No estás en un repositorio Git${NC}"
        exit 1
    fi
}

# Función para guardar cambios
git_save() {
    local message="${1:-Auto-save: $(date '+%Y-%m-%d %H:%M:%S')}"

    echo -e "${CYAN}💾 Guardando cambios...${NC}"

    # Verificar si hay cambios
    if git diff --quiet && git diff --cached --quiet; then
        echo -e "${YELLOW}⚠️  No hay cambios para guardar${NC}"
        return 0
    fi

    # Mostrar estado
    echo -e "${BLUE}📋 Estado actual:${NC}"
    git status --short

    # Agregar archivos
    echo -e "${YELLOW}📤 Agregando archivos...${NC}"
    git add .

    # Commit
    echo -e "${YELLOW}📝 Commiteando: $message${NC}"
    git commit -m "$message"

    echo -e "${GREEN}✅ Cambios guardados exitosamente${NC}"
}

# Función para sincronizar con remote
git_sync() {
    local branch=$(git branch --show-current)

    echo -e "${CYAN}🔄 Sincronizando rama '$branch' con remote...${NC}"

    # Pull primero
    echo -e "${YELLOW}📥 Pulling cambios...${NC}"
    if git pull origin "$branch"; then
        echo -e "${GREEN}✅ Pull exitoso${NC}"
    else
        echo -e "${RED}❌ Error en pull - resuelve conflictos manualmente${NC}"
        return 1
    fi

    # Push si hay commits locales
    if git log origin/"$branch"..HEAD --oneline | grep -q .; then
        echo -e "${YELLOW}📤 Pushing cambios locales...${NC}"
        git push origin "$branch"
        echo -e "${GREEN}✅ Push exitoso${NC}"
    else
        echo -e "${BLUE}ℹ️  No hay cambios locales para push${NC}"
    fi
}

# Función para mostrar estado detallado
git_status() {
    echo -e "${CYAN}📊 Estado del Repositorio${NC}"
    echo "=================================="

    # Rama actual
    local branch=$(git branch --show-current)
    echo -e "${YELLOW}🌿 Rama actual:${NC} $branch"

    # Estado de archivos
    echo -e "${YELLOW}📋 Estado de archivos:${NC}"
    git status --short

    # Commits ahead/behind
    local upstream="origin/$branch"
    if git rev-parse --verify "$upstream" &>/dev/null; then
        local ahead=$(git rev-list --count HEAD ^"$upstream" 2>/dev/null || echo "0")
        local behind=$(git rev-list --count "$upstream" ^HEAD 2>/dev/null || echo "0")

        echo -e "${YELLOW}📡 Sincronización:${NC}"
        echo -e "  Commits adelante: $ahead"
        echo -e "  Commits atrás: $behind"
    fi

    # Últimos commits
    echo -e "${YELLOW}📜 Últimos 3 commits:${NC}"
    git log --oneline -3 --color=always

    # Stash
    local stash_count=$(git stash list | wc -l)
    if [ "$stash_count" -gt 0 ]; then
        echo -e "${YELLOW}📦 Stash:${NC} $stash_count entradas"
    fi
}

# Función para limpiar archivos
git_clean() {
    echo -e "${CYAN}🧹 Limpiando archivos no tracked...${NC}"

    # Mostrar qué se va a eliminar
    echo -e "${YELLOW}📋 Archivos que se eliminarán:${NC}"
    git clean -fd --dry-run

    echo -e "${RED}⚠️  ¿Continuar con la limpieza? (y/N)${NC}"
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        git clean -fd
        echo -e "${GREEN}✅ Limpieza completada${NC}"
    else
        echo -e "${BLUE}❌ Limpieza cancelada${NC}"
    fi
}

# Función para gestionar stash
git_stash() {
    local action="${1:-list}"

    case "$action" in
        "save"|"push")
            local message="${2:-Auto-stash: $(date '+%Y-%m-%d %H:%M:%S')}"
            git stash push -m "$message"
            echo -e "${GREEN}✅ Stash guardado: $message${NC}"
            ;;
        "pop")
            git stash pop
            echo -e "${GREEN}✅ Stash aplicado y eliminado${NC}"
            ;;
        "apply")
            git stash apply
            echo -e "${GREEN}✅ Stash aplicado (mantenido)${NC}"
            ;;
        "list")
            echo -e "${CYAN}📦 Entradas de Stash:${NC}"
            git stash list --color=always
            ;;
        "drop")
            git stash drop
            echo -e "${GREEN}✅ Última entrada de stash eliminada${NC}"
            ;;
        "clear")
            echo -e "${RED}⚠️  ¿Eliminar TODAS las entradas de stash? (y/N)${NC}"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                git stash clear
                echo -e "${GREEN}✅ Stash limpiado completamente${NC}"
            fi
            ;;
        *)
            echo -e "${RED}❌ Acción de stash inválida: $action${NC}"
            echo -e "${BLUE}Acciones válidas: save, pop, apply, list, drop, clear${NC}"
            return 1
            ;;
    esac
}

# Función para crear feature branch
git_feature() {
    local feature_name="$1"

    if [ -z "$feature_name" ]; then
        echo -e "${RED}❌ Error: Especifica el nombre de la feature${NC}"
        echo -e "${BLUE}Uso: $0 feature <nombre-feature>${NC}"
        return 1
    fi

    # Validar nombre
    if [[ ! "$feature_name" =~ ^[a-z0-9-]+$ ]]; then
        echo -e "${RED}❌ Error: El nombre debe contener solo letras minúsculas, números y guiones${NC}"
        return 1
    fi

    local branch_name="feat/$feature_name"

    echo -e "${CYAN}🌿 Creando rama de feature: $branch_name${NC}"

    # Asegurar que estamos en develop
    git checkout develop
    git pull origin develop

    # Crear y cambiar a nueva rama
    git checkout -b "$branch_name"

    echo -e "${GREEN}✅ Rama '$branch_name' creada y activa${NC}"
    echo -e "${YELLOW}💡 Recuerda hacer commits con el formato: feat: descripción${NC}"
}

# Función para mergear a develop
git_merge() {
    local current_branch=$(git branch --show-current)

    if [ "$current_branch" = "develop" ]; then
        echo -e "${RED}❌ Error: Ya estás en la rama develop${NC}"
        return 1
    fi

    echo -e "${CYAN}🔄 Mergeando '$current_branch' a develop...${NC}"

    # Verificar que no hay cambios sin commitear
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo -e "${RED}❌ Error: Hay cambios sin commitear${NC}"
        echo -e "${BLUE}Ejecuta 'git add . && git commit' o '$0 save' primero${NC}"
        return 1
    fi

    # Cambiar a develop y actualizar
    git checkout develop
    git pull origin develop

    # Mergear la rama con mensaje automático (será permitido por el hook)
    echo -e "${YELLOW}🔄 Ejecutando merge...${NC}"
    git merge "$current_branch" --no-ff

    # Push
    echo -e "${YELLOW}📤 Pushing a origin...${NC}"
    git push origin develop

    echo -e "${GREEN}✅ Merge completado exitosamente${NC}"
    echo -e "${YELLOW}💡 ¿Eliminar la rama '$current_branch'? (y/N)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        git branch -d "$current_branch"
        git push origin --delete "$current_branch" 2>/dev/null || true
        echo -e "${GREEN}✅ Rama eliminada${NC}"
    fi
}

# Función para mostrar log mejorado
git_log() {
    local count="${1:-10}"
    echo -e "${CYAN}📜 Últimos $count commits:${NC}"
    git log --oneline --graph --color=always -"$count"
}

# Función para mostrar diferencias
git_diff() {
    local target="${1:-}"
    if [ -n "$target" ]; then
        git diff --color=always "$target"
    else
        git diff --color=always
    fi
}

# Función principal
main() {
    # Verificar que estamos en un repo Git
    check_git_repo

    case "${1:-help}" in
        "save")
            git_save "${2:-}"
            ;;
        "sync")
            git_sync
            ;;
        "status")
            git_status
            ;;
        "clean")
            git_clean
            ;;
        "stash")
            git_stash "${2:-list}" "${3:-}"
            ;;
        "feature")
            git_feature "$2"
            ;;
        "merge")
            git_merge
            ;;
        "log")
            git_log "${2:-10}"
            ;;
        "diff")
            git_diff "${2:-}"
            ;;
        "branches")
            echo -e "${CYAN}🌿 Ramas locales:${NC}"
            git branch --color=always
            echo -e "${CYAN}🌐 Ramas remotas:${NC}"
            git branch -r --color=always
            ;;
        "remotes")
            echo -e "${CYAN}📡 Remotos configurados:${NC}"
            git remote -v
            ;;
        "setup")
            # Ejecutar script de setup si existe
            if [ -f "$PROJECT_ROOT/scripts/setup-dev.sh" ]; then
                "$PROJECT_ROOT/scripts/setup-dev.sh"
            else
                echo -e "${YELLOW}⚠️  Script de setup no encontrado${NC}"
            fi
            ;;
        "config")
            echo -e "${CYAN}⚙️  Configuración de Git:${NC}"
            git config --list --local | grep -E '^(user|core|init)' || true
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            if [ "$1" = "man" ]; then
                show_help
            else
                echo -e "${RED}❌ Error: Comando desconocido '$1'${NC}"
                echo ""
                show_help
                exit 1
            fi
            ;;
    esac
}

# Ejecutar función principal con todos los argumentos
main "$@"
