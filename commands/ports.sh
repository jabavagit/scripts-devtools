#!/bin/bash

# 🌐 DevTools Ports Command
# ========================
# Descripción: Gestión de puertos y procesos

cmd_ports() {
    log_section "PORTS" "🌐"
    log_info "Analizando puertos del sistema..."
    
    local check_port=""
    local kill_port=""
    local kill_node=false
    local watch=false
    local list_all=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --check)
                check_port="$2"
                shift 2
                ;;
            --kill)
                kill_port="$2"
                shift 2
                ;;
            --kill-node)
                kill_node=true
                shift
                ;;
            --watch|-w)
                watch=true
                shift
                ;;
            --list|-l)
                list_all=true
                shift
                ;;
            --help|-h)
                show_ports_help
                return 0
                ;;
            *)
                log_error "Opción desconocida: $1"
                return 1
                ;;
        esac
    done
    
    # Ejecutar acción solicitada
    if [[ -n "$check_port" ]]; then
        check_specific_port "$check_port"
    elif [[ -n "$kill_port" ]]; then
        kill_process_on_port "$kill_port"
    elif [[ "$kill_node" == "true" ]]; then
        kill_node_processes
    elif [[ "$watch" == "true" ]]; then
        watch_ports
    elif [[ "$list_all" == "true" ]]; then
        list_all_ports
    else
        list_common_ports
    fi
}

check_specific_port() {
    local port="$1"
    
    log_subsection "Verificando Puerto $port" "🔍"
    
    # Verificar si el puerto está ocupado
    local process_info=$(netstat -tulpn 2>/dev/null | grep ":$port ")
    
    if [[ -n "$process_info" ]]; then
        log_warning "Puerto $port está ocupado"
        
        # Extraer PID si es posible
        local pid=$(echo "$process_info" | grep -o '[0-9]*/[a-zA-Z]*' | cut -d'/' -f1)
        
        if [[ -n "$pid" ]] && [[ "$pid" != "-" ]]; then
            local process_name=$(ps -p "$pid" -o comm --no-headers 2>/dev/null)
            local full_cmd=$(ps -p "$pid" -o cmd --no-headers 2>/dev/null)
            
            log_info "$(icon_process) PID: $pid"
            log_info "$(icon_process) Proceso: $process_name"
            log_info "$(icon_cmd) Comando: $full_cmd"
            
            echo
            log_info "Para liberar el puerto: $(color_cmd "./devTools ports --kill $port")"
        fi
    else
        log_success "Puerto $port está libre"
    fi
}

kill_process_on_port() {
    local port="$1"
    
    log_subsection "Liberando Puerto $port" "💀"
    
    # Encontrar PID del proceso
    local pid=$(netstat -tulpn 2>/dev/null | grep ":$port " | grep -o '[0-9]*/[a-zA-Z]*' | cut -d'/' -f1 | head -1)
    
    if [[ -n "$pid" ]] && [[ "$pid" != "-" ]]; then
        local process_name=$(ps -p "$pid" -o comm --no-headers 2>/dev/null)
        
        log_process "Terminando proceso $process_name (PID: $pid)..."
        
        # Intentar terminación ordenada primero
        if kill "$pid" 2>/dev/null; then
            sleep 2
            
            # Verificar si el proceso aún existe
            if kill -0 "$pid" 2>/dev/null; then
                log_warning "Proceso no terminó, usando kill -9..."
                kill -9 "$pid" 2>/dev/null
            fi
            
            log_success "Proceso terminado, puerto $port liberado"
        else
            log_error "No se pudo terminar el proceso (permisos insuficientes?)"
            return 1
        fi
    else
        log_info "Puerto $port no está ocupado"
    fi
}

kill_node_processes() {
    log_subsection "Terminando Procesos Node.js" "🟢"
    
    local node_pids=($(pgrep -f node))
    
    if [[ ${#node_pids[@]} -eq 0 ]]; then
        log_info "No hay procesos Node.js ejecutándose"
        return 0
    fi
    
    log_info "Encontrados ${#node_pids[@]} procesos Node.js"
    
    for pid in "${node_pids[@]}"; do
        local cmd=$(ps -p "$pid" -o cmd --no-headers 2>/dev/null | cut -c1-60)
        log_info "$(icon_process) PID $pid: $cmd"
    done
    
    echo
    echo -n "$(icon_question) ¿Terminar todos los procesos Node.js? (y/N): "
    read -r confirm
    
    if [[ "$confirm" =~ ^[Yy] ]]; then
        local killed=0
        for pid in "${node_pids[@]}"; do
            if kill "$pid" 2>/dev/null; then
                ((killed++))
            fi
        done
        
        log_success "$killed procesos Node.js terminados"
        
        # Verificar puertos liberados
        sleep 1
        log_info "Verificando puertos liberados..."
        for port in 3000 3001 8080 8000 5173; do
            if ! netstat -ln 2>/dev/null | grep -q ":$port "; then
                log_success "Puerto $port liberado"
            fi
        done
    else
        log_info "Operación cancelada"
    fi
}

list_common_ports() {
    log_subsection "Puertos Comunes de Desarrollo" "📋"
    
    local ports=(3000 3001 8000 8080 5173 5432 6379 27017)
    local occupied_count=0
    
    for port in "${ports[@]}"; do
        if netstat -ln 2>/dev/null | grep -q ":$port "; then
            local pid=$(netstat -tulpn 2>/dev/null | grep ":$port " | grep -o '[0-9]*/[a-zA-Z]*' | cut -d'/' -f1 | head -1)
            local process=""
            
            if [[ -n "$pid" ]] && [[ "$pid" != "-" ]]; then
                process=$(ps -p "$pid" -o comm --no-headers 2>/dev/null)
            fi
            
            log_warning "$(icon_port_open) Puerto $port: ocupado${process:+ por $process (PID: $pid)}"
            ((occupied_count++))
        else
            log_success "$(icon_port_closed) Puerto $port: libre"
        fi
    done
    
    echo
    if [[ "$occupied_count" -gt 0 ]]; then
        log_info "$(icon_info) Puertos ocupados: $occupied_count"
        log_info "$(icon_info) Para liberar: $(color_cmd "./devTools ports --kill <puerto>")"
        log_info "$(icon_info) Para limpiar Node.js: $(color_cmd "./devTools ports --kill-node")"
    else
        log_success "$(icon_celebrate) Todos los puertos comunes están libres"
    fi
}

list_all_ports() {
    log_subsection "Todos los Puertos Ocupados" "📋"
    
    log_process "Escaneando puertos..."
    
    # Mostrar puertos TCP ocupados
    echo "$(color_subtitle "PUERTOS TCP:")"
    netstat -tulpn 2>/dev/null | grep "tcp.*LISTEN" | while read -r line; do
        local port=$(echo "$line" | awk '{print $4}' | cut -d':' -f2)
        local pid=$(echo "$line" | grep -o '[0-9]*/[a-zA-Z]*' | cut -d'/' -f1)
        local process=$(echo "$line" | grep -o '/[a-zA-Z]*' | cut -d'/' -f2)
        
        log_info "$(icon_port_listening) Puerto $port: $process (PID: $pid)"
    done
}

watch_ports() {
    log_info "Monitoreando puertos (Ctrl+C para salir)"
    echo
    
    while true; do
        clear
        list_common_ports
        echo
        echo "$(color_gray "Actualizado: $(date)")"
        sleep 3
    done
}

show_ports_help() {
    echo "$(icon_ports) DevTools Ports - Gestión de Puertos"
    echo
    echo "DESCRIPCIÓN:"
    echo "  Gestiona puertos ocupados y procesos asociados"
    echo
    echo "USO:"
    echo "  ./devTools ports [OPCIONES]"
    echo
    echo "OPCIONES:"
    echo "  --check <puerto>   Verificar estado de puerto específico"
    echo "  --kill <puerto>    Terminar proceso que usa el puerto"
    echo "  --kill-node        Terminar todos los procesos Node.js"
    echo "  --watch, -w        Monitoreo continuo"
    echo "  --list, -l         Listar todos los puertos ocupados"
    echo "  --help, -h         Mostrar esta ayuda"
    echo
    echo "EJEMPLOS:"
    echo "  ./devTools ports                    # Ver puertos comunes"
    echo "  ./devTools ports --check 3000      # Verificar puerto 3000"
    echo "  ./devTools ports --kill 3000       # Liberar puerto 3000"
    echo "  ./devTools ports --kill-node       # Terminar procesos Node.js"
}
