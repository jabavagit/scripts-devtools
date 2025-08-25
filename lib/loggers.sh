#!/bin/bash

# 📝 Sistema de Logging DevTools
# =============================
# Descripción: Sistema de logging unificado con niveles y formato
# Integración con sistema de colores e iconos

# Cargar dependencias si no están cargadas
if ! declare -f color_success > /dev/null 2>&1; then
    source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"
fi

if ! declare -f icon_success > /dev/null 2>&1; then
    source "$(dirname "${BASH_SOURCE[0]}")/icons.sh"
fi

# === CONFIGURACIÓN ===

# Niveles de log
declare -A LOG_LEVELS=(
    ["DEBUG"]=0
    ["INFO"]=1
    ["SUCCESS"]=2
    ["WARNING"]=3
    ["ERROR"]=4
    ["CRITICAL"]=5
)

# Configuración global
LOG_LEVEL="${DEVTOOLS_LOG_LEVEL:-INFO}"
LOG_TO_FILE="${DEVTOOLS_LOG_FILE:-}"
LOG_TIMESTAMP="${DEVTOOLS_LOG_TIMESTAMP:-true}"
LOG_PREFIX="${DEVTOOLS_LOG_PREFIX:-DevTools}"

# === FUNCIONES DE LOGGING ===

# Logging genérico
_log() {
    local level="$1"
    local message="$2"
    local icon="$3"
    local color_func="$4"
    
    # Verificar si el nivel está habilitado
    local current_level_num="${LOG_LEVELS[$LOG_LEVEL]}"
    local message_level_num="${LOG_LEVELS[$level]}"
    
    if [[ "$message_level_num" -lt "$current_level_num" ]]; then
        return 0
    fi
    
    # Construir el mensaje
    local timestamp=""
    if [[ "$LOG_TIMESTAMP" == "true" ]]; then
        timestamp="$(date '+%H:%M:%S') "
    fi
    
    local prefix=""
    if [[ -n "$LOG_PREFIX" ]]; then
        prefix="[$LOG_PREFIX] "
    fi
    
    local formatted_message="${timestamp}${prefix}${icon} ${message}"
    
    # Aplicar color y mostrar
    if declare -f "$color_func" > /dev/null 2>&1; then
        echo "$($color_func "$formatted_message")"
    else
        echo "$formatted_message"
    fi
    
    # Log a archivo si está configurado
    if [[ -n "$LOG_TO_FILE" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message" >> "$LOG_TO_FILE"
    fi
}

# Logging de debug
log_debug() {
    _log "DEBUG" "$1" "$(icon_debug)" "color_gray"
}

# Logging de información
log_info() {
    _log "INFO" "$1" "$(icon_info)" "color_info"
}

# Logging de éxito
log_success() {
    _log "SUCCESS" "$1" "$(icon_success)" "color_success"
}

# Logging de advertencia
log_warning() {
    _log "WARNING" "$1" "$(icon_warning)" "color_warning"
}

# Logging de error
log_error() {
    _log "ERROR" "$1" "$(icon_error)" "color_error"
}

# Logging crítico
log_critical() {
    _log "CRITICAL" "$1" "$(icon_critical)" "color_error"
}

# === LOGGING ESPECIALIZADO ===

# Log de proceso en curso
log_process() {
    local message="$1"
    _log "INFO" "$message" "$(icon_process)" "color_blue"
}

# Log de comando ejecutado
log_command() {
    local command="$1"
    log_debug "Ejecutando: $(color_cmd "$command")"
}

# Log de archivo procesado
log_file() {
    local action="$1"
    local file="$2"
    log_info "$action: $(color_path "$file")"
}

# Log de URL
log_url() {
    local description="$1"
    local url="$2"
    log_info "$description: $(color_url "$url")"
}

# === LOGGING DE PROGRESO ===

# Iniciar proceso con progreso
log_progress_start() {
    local task="$1"
    local total="${2:-100}"
    
    echo -n "$(icon_process) $task... "
    export LOG_PROGRESS_TASK="$task"
    export LOG_PROGRESS_TOTAL="$total"
    export LOG_PROGRESS_CURRENT=0
}

# Actualizar progreso
log_progress_update() {
    local current="$1"
    local message="${2:-}"
    
    export LOG_PROGRESS_CURRENT="$current"
    
    if [[ -n "$message" ]]; then
        echo -ne "\r$(icon_process) $LOG_PROGRESS_TASK... $current/$LOG_PROGRESS_TOTAL ($message)"
    else
        echo -ne "\r$(icon_process) $LOG_PROGRESS_TASK... $current/$LOG_PROGRESS_TOTAL"
    fi
}

# Finalizar progreso
log_progress_end() {
    local status="${1:-success}"
    local message="${2:-completado}"
    
    echo # Nueva línea
    
    case "$status" in
        "success")
            log_success "$LOG_PROGRESS_TASK $message"
            ;;
        "error")
            log_error "$LOG_PROGRESS_TASK falló: $message"
            ;;
        "warning")
            log_warning "$LOG_PROGRESS_TASK $message"
            ;;
    esac
    
    unset LOG_PROGRESS_TASK LOG_PROGRESS_TOTAL LOG_PROGRESS_CURRENT
}

# === LOGGING DE SECCIONES ===

# Título de sección
log_section() {
    local title="$1"
    local icon="${2:-🔧}"
    
    echo
    echo "$(color_title "${icon} ${title}")"
    echo "$(color_separator)"
}

# Subsección
log_subsection() {
    local title="$1"
    local icon="${2:-▶}"
    
    echo
    echo "$(color_subtitle "${icon} ${title}")"
}

# === LOGGING DE TABLAS ===

# Encabezado de tabla
log_table_header() {
    local -a headers=("$@")
    local row=""
    
    for header in "${headers[@]}"; do
        row+="$(color_cyan "$(printf "%-15s" "$header")")"
    done
    
    echo "$row"
    echo "$(color_separator $((${#headers[@]} * 15)) "-" "cyan")"
}

# Fila de tabla
log_table_row() {
    local -a cells=("$@")
    local row=""
    
    for cell in "${cells[@]}"; do
        row+="$(printf "%-15s" "$cell")"
    done
    
    echo "$row"
}

# === LOGGING DE TIEMPO ===

# Iniciar medición de tiempo
log_timer_start() {
    local task="$1"
    export LOG_TIMER_START=$(date +%s)
    export LOG_TIMER_TASK="$task"
    log_process "Iniciando: $task"
}

# Finalizar medición de tiempo
log_timer_end() {
    local status="${1:-success}"
    
    if [[ -n "$LOG_TIMER_START" ]] && [[ -n "$LOG_TIMER_TASK" ]]; then
        local end_time=$(date +%s)
        local duration=$((end_time - LOG_TIMER_START))
        local formatted_time=$(format_duration "$duration")
        
        case "$status" in
            "success")
                log_success "$LOG_TIMER_TASK completado en $formatted_time"
                ;;
            "error")
                log_error "$LOG_TIMER_TASK falló después de $formatted_time"
                ;;
        esac
        
        unset LOG_TIMER_START LOG_TIMER_TASK
    fi
}

# === UTILIDADES ===

# Formatear duración en formato legible
format_duration() {
    local seconds="$1"
    
    if [[ "$seconds" -lt 60 ]]; then
        echo "${seconds}s"
    elif [[ "$seconds" -lt 3600 ]]; then
        local minutes=$((seconds / 60))
        local remaining=$((seconds % 60))
        echo "${minutes}m ${remaining}s"
    else
        local hours=$((seconds / 3600))
        local remaining=$((seconds % 3600))
        local minutes=$((remaining / 60))
        echo "${hours}h ${minutes}m"
    fi
}

# Configurar nivel de log
set_log_level() {
    local level="$1"
    
    if [[ -n "${LOG_LEVELS[$level]}" ]]; then
        LOG_LEVEL="$level"
        log_debug "Nivel de log establecido a: $level"
    else
        log_error "Nivel de log inválido: $level"
        return 1
    fi
}

# Mostrar configuración actual
log_show_config() {
    echo "$(color_title 'CONFIGURACIÓN DE LOGGING')"
    echo "Nivel actual: $(color_info "$LOG_LEVEL")"
    echo "Timestamp: $(color_info "$LOG_TIMESTAMP")"
    echo "Prefijo: $(color_info "$LOG_PREFIX")"
    echo "Archivo: $(color_info "${LOG_TO_FILE:-"No configurado"}")"
}

# === LOGGING DE DEBUGGING ===

# Dump de variables de entorno
log_dump_env() {
    local pattern="${1:-DEVTOOLS_}"
    
    log_section "VARIABLES DE ENTORNO" "🔍"
    env | grep "^$pattern" | while read -r line; do
        log_debug "$line"
    done
}

# Log de llamada de función
log_function_call() {
    local func_name="$1"
    shift
    local args="$*"
    
    log_debug "Llamando función: $(color_cmd "$func_name") con argumentos: $(color_opt "$args")"
}
