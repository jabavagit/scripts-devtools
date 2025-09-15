#!/bin/bash

# 🔧 Script de Gestión de Procesos Node.js y Puertos
# Utilidad para manejar procesos que ocupan puertos específicos

set -euo pipefail

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo -e "${CYAN}🔧 Script de Gestión de Procesos Node.js y Puertos${NC}"
    echo -e "${BLUE}Uso: $0 [COMANDO] [OPCIONES]${NC}"
    echo ""
    echo "COMANDOS:"
    echo -e "  ${GREEN}list${NC}                    Lista todos los procesos Node.js"
    echo -e "  ${GREEN}port <puerto>${NC}          Muestra qué proceso usa un puerto específico"
    echo -e "  ${GREEN}kill-port <puerto>${NC}     Mata el proceso que usa un puerto específico"
    echo -e "  ${GREEN}kill-node${NC}              Mata todos los procesos Node.js"
    echo -e "  ${GREEN}kill-dev${NC}               Mata procesos de desarrollo (next, docusaurus, vite)"
    echo -e "  ${GREEN}status${NC}                 Muestra estado de puertos comunes de desarrollo"
    echo -e "  ${GREEN}cleanup${NC}                Limpieza completa de procesos Node.js zombie"
    echo ""
    echo "EJEMPLOS:"
    echo -e "  ${YELLOW}$0 port 3000${NC}              # Ver qué usa el puerto 3000"
    echo -e "  ${YELLOW}$0 kill-port 3000${NC}        # Matar proceso en puerto 3000"
    echo -e "  ${YELLOW}$0 kill-dev${NC}              # Matar todos los procesos de desarrollo"
    echo -e "  ${YELLOW}$0 status${NC}                # Ver estado de puertos comunes"
    echo ""
}

# Función para listar procesos Node.js
list_node_processes() {
    echo -e "${CYAN}📋 Procesos Node.js activos:${NC}"

    if ! pgrep -f node > /dev/null; then
        echo -e "${YELLOW}No hay procesos Node.js ejecutándose.${NC}"
        return 0
    fi

    echo -e "${BLUE}PID    COMANDO${NC}"
    echo "==========================================="

    # Obtener procesos Node.js reales (no VS Code)
    ps aux | grep node | grep -v grep | grep -v '/usr/share/code/code' | while read -r line; do
        pid=$(echo "$line" | awk '{print $2}')
        command=$(echo "$line" | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}' | cut -c1-60)
        echo -e "${GREEN}$pid${NC}    $command"
    done
}

# Función para verificar qué proceso usa un puerto
check_port() {
    local port=$1

    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}❌ Error: '$port' no es un número de puerto válido${NC}"
        return 1
    fi

    echo -e "${CYAN}🔍 Verificando puerto $port...${NC}"

    local pid=$(lsof -ti:$port 2>/dev/null || true)

    if [ -z "$pid" ]; then
        echo -e "${GREEN}✅ Puerto $port está libre${NC}"
        return 0
    fi

    echo -e "${YELLOW}⚠️  Puerto $port está ocupado por:${NC}"
    echo -e "${BLUE}PID: $pid${NC}"

    local process_info=$(ps -p $pid -o pid,ppid,cmd --no-headers 2>/dev/null || echo "Proceso no encontrado")
    echo -e "${BLUE}Proceso: $process_info${NC}"

    # Mostrar puertos adicionales que pueda estar usando el mismo proceso
    echo -e "${CYAN}Otros puertos usados por este proceso:${NC}"
    lsof -Pan -p $pid -i 2>/dev/null | grep LISTEN || echo "No hay otros puertos"
}

# Función para matar proceso en puerto específico
kill_port() {
    local port=$1

    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}❌ Error: '$port' no es un número de puerto válido${NC}"
        return 1
    fi

    local pid=$(lsof -ti:$port 2>/dev/null || true)

    if [ -z "$pid" ]; then
        echo -e "${GREEN}✅ Puerto $port ya está libre${NC}"
        return 0
    fi

    echo -e "${YELLOW}🔫 Matando proceso $pid que usa puerto $port...${NC}"

    # Intentar terminación suave primero
    if kill -TERM $pid 2>/dev/null; then
        echo -e "${GREEN}📤 Señal TERM enviada, esperando 3 segundos...${NC}"
        sleep 3

        # Verificar si el proceso sigue corriendo
        if kill -0 $pid 2>/dev/null; then
            echo -e "${YELLOW}⚡ Proceso aún activo, usando KILL...${NC}"
            kill -KILL $pid 2>/dev/null || true
        fi

        echo -e "${GREEN}✅ Proceso eliminado exitosamente${NC}"
    else
        echo -e "${RED}❌ Error al matar el proceso${NC}"
        return 1
    fi
}

# Función para matar todos los procesos Node.js
kill_all_node() {
    echo -e "${YELLOW}⚠️  ¿Estás seguro de matar TODOS los procesos Node.js? (y/N)${NC}"
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}🔫 Matando todos los procesos Node.js...${NC}"

        # Obtener PIDs de procesos Node.js reales (no VS Code)
        local pids=$(pgrep -f node | xargs -I {} sh -c 'ps -p {} -o pid,cmd --no-headers | grep -v "/usr/share/code/code" | awk "{print \$1}"' 2>/dev/null || true)

        if [ -z "$pids" ]; then
            echo -e "${GREEN}✅ No hay procesos Node.js para matar${NC}"
            return 0
        fi

        echo "$pids" | while read -r pid; do
            if [ -n "$pid" ] && kill -0 $pid 2>/dev/null; then
                echo -e "${YELLOW}Matando PID: $pid${NC}"
                kill -TERM $pid 2>/dev/null || kill -KILL $pid 2>/dev/null || true
            fi
        done

        sleep 2
        echo -e "${GREEN}✅ Todos los procesos Node.js han sido eliminados${NC}"
    else
        echo -e "${BLUE}❌ Operación cancelada${NC}"
    fi
}

# Función para matar procesos de desarrollo específicos
kill_dev_processes() {
    echo -e "${CYAN}🛠️  Matando procesos de desarrollo...${NC}"

    local dev_patterns=("next" "docusaurus" "vite" "webpack" "rollup" "parcel")
    local killed=false

    for pattern in "${dev_patterns[@]}"; do
        local pids=$(pgrep -f "$pattern" 2>/dev/null || true)

        if [ -n "$pids" ]; then
            echo -e "${YELLOW}Matando procesos de $pattern...${NC}"
            echo "$pids" | while read -r pid; do
                if [ -n "$pid" ]; then
                    local cmd=$(ps -p $pid -o cmd --no-headers 2>/dev/null || echo "desconocido")
                    echo -e "${BLUE}  PID $pid: $cmd${NC}"
                    kill -TERM $pid 2>/dev/null || kill -KILL $pid 2>/dev/null || true
                fi
            done
            killed=true
        fi
    done

    if [ "$killed" = true ]; then
        sleep 2
        echo -e "${GREEN}✅ Procesos de desarrollo eliminados${NC}"
    else
        echo -e "${GREEN}✅ No hay procesos de desarrollo ejecutándose${NC}"
    fi
}

# Función para mostrar estado de puertos comunes
show_status() {
    echo -e "${CYAN}📊 Estado de puertos de desarrollo comunes:${NC}"
    echo "=========================================="

    local common_ports=(3000 3001 3002 3003 4000 5000 5173 8000 8080 8081 9000)

    for port in "${common_ports[@]}"; do
        local pid=$(lsof -ti:$port 2>/dev/null || true)

        if [ -n "$pid" ]; then
            local cmd=$(ps -p $pid -o cmd --no-headers 2>/dev/null | cut -c1-40 || echo "desconocido")
            echo -e "${RED}Puerto $port${NC}: ${YELLOW}OCUPADO${NC} (PID: $pid) - $cmd"
        else
            echo -e "${GREEN}Puerto $port${NC}: ${GREEN}LIBRE${NC}"
        fi
    done
}

# Función para limpieza completa
cleanup() {
    echo -e "${CYAN}🧹 Limpieza completa de procesos Node.js...${NC}"

    # Matar procesos zombie
    echo -e "${YELLOW}🧟 Buscando procesos zombie...${NC}"
    local zombies=$(ps aux | awk '$8 ~ /^Z/ {print $2}' 2>/dev/null || true)

    if [ -n "$zombies" ]; then
        echo "Procesos zombie encontrados: $zombies"
        echo "$zombies" | xargs kill -9 2>/dev/null || true
    else
        echo -e "${GREEN}✅ No hay procesos zombie${NC}"
    fi

    # Limpiar puertos huérfanos
    echo -e "${YELLOW}🔌 Liberando puertos huérfanos...${NC}"

    for port in 3000 3001 3002 3003; do
        local pid=$(lsof -ti:$port 2>/dev/null || true)
        if [ -n "$pid" ]; then
            if ! ps -p $pid > /dev/null 2>&1; then
                echo "Liberando puerto huérfano $port"
                lsof -ti:$port | xargs kill -9 2>/dev/null || true
            fi
        fi
    done

    echo -e "${GREEN}✅ Limpieza completada${NC}"
}

# Función principal
main() {
    case "${1:-}" in
        "list")
            list_node_processes
            ;;
        "port")
            if [ -z "${2:-}" ]; then
                echo -e "${RED}❌ Error: Especifica un puerto${NC}"
                echo -e "${BLUE}Uso: $0 port <número_puerto>${NC}"
                exit 1
            fi
            check_port "$2"
            ;;
        "kill-port")
            if [ -z "${2:-}" ]; then
                echo -e "${RED}❌ Error: Especifica un puerto${NC}"
                echo -e "${BLUE}Uso: $0 kill-port <número_puerto>${NC}"
                exit 1
            fi
            kill_port "$2"
            ;;
        "kill-node")
            kill_all_node
            ;;
        "kill-dev")
            kill_dev_processes
            ;;
        "status")
            show_status
            ;;
        "cleanup")
            cleanup
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        "")
            echo -e "${RED}❌ Error: No se especificó comando${NC}"
            echo ""
            show_help
            exit 1
            ;;
        *)
            echo -e "${RED}❌ Error: Comando desconocido '$1'${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Verificar dependencias
check_dependencies() {
    local deps=("lsof" "pgrep" "ps")

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${RED}❌ Error: '$dep' no está instalado${NC}"
            echo -e "${BLUE}Instala con: sudo apt install $dep${NC}"
            exit 1
        fi
    done
}

# Verificar dependencias antes de ejecutar
check_dependencies

# Ejecutar función principal con todos los argumentos
main "$@"
