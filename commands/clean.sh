#!/bin/bash

# 🧹 DevTools Clean Command
# ========================
# Descripción: Limpieza de archivos temporales y cachés

cmd_clean() {
    log_section "CLEAN" "🧹"
    log_info "Iniciando limpieza del sistema..."
    
    local all=false
    local dry_run=false
    local force=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --all|-a) all=true; shift ;;
            --dry-run) dry_run=true; shift ;;
            --force) force=true; shift ;;
            --help|-h) show_clean_help; return 0 ;;
            *) log_error "Opción desconocida: $1"; return 1 ;;
        esac
    done
    
    # Mostrar lo que se va a limpiar
    local files_to_clean=()
    
    # Archivos básicos de limpieza
    [[ -d "dist" ]] && files_to_clean+=("dist/")
    [[ -d "build" ]] && files_to_clean+=("build/")
    [[ -d "coverage" ]] && files_to_clean+=("coverage/")
    [[ -f ".eslintcache" ]] && files_to_clean+=(".eslintcache")
    
    # Limpieza completa
    if [[ "$all" == "true" ]]; then
        [[ -d "node_modules" ]] && files_to_clean+=("node_modules/")
        [[ -d ".pnpm-cache" ]] && files_to_clean+=(".pnpm-cache/")
    fi
    
    if [[ ${#files_to_clean[@]} -eq 0 ]]; then
        log_info "No hay archivos para limpiar"
        return 0
    fi
    
    log_subsection "Archivos a eliminar:" "🗑️"
    for file in "${files_to_clean[@]}"; do
        local size=$(du -sh "$file" 2>/dev/null | cut -f1 || echo "?")
        log_info "$(icon_delete) $file ($size)"
    done
    
    if [[ "$dry_run" == "true" ]]; then
        log_info "Modo dry-run: no se eliminaron archivos"
        return 0
    fi
    
    # Confirmación
    if [[ "$force" == "false" ]]; then
        echo -n "$(icon_question) ¿Continuar con la eliminación? (y/N): "
        read -r confirm
        if [[ ! "$confirm" =~ ^[Yy] ]]; then
            log_info "Operación cancelada"
            return 0
        fi
    fi
    
    # Ejecutar limpieza
    local cleaned=0
    for file in "${files_to_clean[@]}"; do
        log_process "Eliminando $file..."
        if rm -rf "$file" 2>/dev/null; then
            log_success "$file eliminado"
            ((cleaned++))
        else
            log_error "Error eliminando $file"
        fi
    done
    
    log_success "Limpieza completada: $cleaned elementos eliminados"
    return 0
}

show_clean_help() {
    echo "$(icon_clean) DevTools Clean - Limpieza del Sistema"
    echo
    echo "DESCRIPCIÓN:"
    echo "  Elimina archivos temporales y cachés del proyecto"
    echo
    echo "USO:"
    echo "  ./devTools clean [OPCIONES]"
    echo
    echo "OPCIONES:"
    echo "  --all, -a      Limpieza completa (incluye node_modules)"
    echo "  --dry-run      Mostrar qué se eliminaría sin hacerlo"
    echo "  --force        Eliminar sin confirmación"
    echo "  --help, -h     Mostrar esta ayuda"
}
