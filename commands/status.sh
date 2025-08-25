#!/bin/bash

# 📊 DevTools Status Command
# =========================
# Descripción: Estado del sistema y procesos

cmd_status() {
    log_section "STATUS" "📊"
    log_info "Analizando estado del sistema..."
    
    local watch=false
    local brief=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --watch|-w) watch=true; shift ;;
            --brief|-b) brief=true; shift ;;
            --help|-h) show_status_help; return 0 ;;
            *) log_error "Opción desconocida: $1"; return 1 ;;
        esac
    done
    
    if [[ "$watch" == "true" ]]; then
        watch_status
    else
        show_status "$brief"
    fi
}

show_status() {
    local brief="$1"
    
    # Sistema
    log_subsection "Sistema" "🖥️"
    show_system_info "$brief"
    
    # Proyecto
    if [[ -f "package.json" ]]; then
        log_subsection "Proyecto" "📦"
        show_project_info "$brief"
    fi
    
    # Procesos
    log_subsection "Procesos" "🔄"
    show_process_info "$brief"
}

show_system_info() {
    local brief="$1"
    
    # CPU
    if command -v nproc > /dev/null; then
        local cpus=$(nproc)
        log_info "$(icon_cpu) CPU: $cpus núcleos"
    fi
    
    # Memoria
    if [[ -f "/proc/meminfo" ]]; then
        local total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        local avail_mem=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        local mem_gb=$((total_mem / 1024 / 1024))
        local avail_gb=$((avail_mem / 1024 / 1024))
        log_info "$(icon_memory) Memoria: ${avail_gb}GB / ${mem_gb}GB disponible"
    fi
    
    # Disco
    local disk_info=$(df -h . | tail -1)
    local disk_usage=$(echo "$disk_info" | awk '{print $5}')
    local disk_avail=$(echo "$disk_info" | awk '{print $4}')
    log_info "$(icon_disk) Disco: $disk_avail disponible (${disk_usage} usado)"
}

show_project_info() {
    local brief="$1"
    local project_name=$(basename "$(pwd)")
    
    log_info "$(icon_folder) Proyecto: $project_name"
    
    if [[ -f "package.json" ]]; then
        local version=$(grep '"version"' package.json | cut -d'"' -f4)
        log_info "$(icon_version) Versión: $version"
        
        if [[ -d "node_modules" ]]; then
            local pkg_count=$(find node_modules -maxdepth 1 -type d | wc -l)
            log_info "$(icon_package_json) Paquetes: $((pkg_count - 1))"
        fi
    fi
    
    # Git info
    if git status > /dev/null 2>&1; then
        local branch=$(git branch --show-current)
        local status=$(git status --porcelain | wc -l)
        log_info "$(icon_git) Branch: $branch ($status cambios)"
    fi
}

show_process_info() {
    local brief="$1"
    
    # Procesos Node.js
    local node_processes=$(pgrep -f node | wc -l)
    if [[ "$node_processes" -gt 0 ]]; then
        log_info "$(icon_node) Procesos Node.js: $node_processes"
        
        if [[ "$brief" == "false" ]]; then
            pgrep -f node | while read -r pid; do
                local cmd=$(ps -p "$pid" -o cmd --no-headers 2>/dev/null | cut -c1-50)
                log_info "  PID $pid: $cmd"
            done
        fi
    fi
    
    # Puertos ocupados comunes
    for port in 3000 3001 8080 5432; do
        if netstat -ln 2>/dev/null | grep -q ":$port "; then
            log_info "$(icon_port_open) Puerto $port: ocupado"
        fi
    done
}

watch_status() {
    log_info "Modo watch activado (Ctrl+C para salir)"
    echo
    
    while true; do
        clear
        show_status false
        echo
        echo "$(color_gray "Actualizado: $(date)")"
        sleep 5
    done
}

show_status_help() {
    echo "$(icon_status) DevTools Status - Estado del Sistema"
    echo
    echo "DESCRIPCIÓN:"
    echo "  Muestra información del sistema, proyecto y procesos"
    echo
    echo "USO:"
    echo "  ./devTools status [OPCIONES]"
    echo
    echo "OPCIONES:"
    echo "  --watch, -w    Actualización continua"
    echo "  --brief, -b    Vista resumida"
    echo "  --help, -h     Mostrar esta ayuda"
}
