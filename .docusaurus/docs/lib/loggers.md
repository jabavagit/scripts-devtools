# 📝 Sistema de Logging (`lib/loggers.sh`)

El sistema de logging de DevTools proporciona una infraestructura robusta y configurable para el registro estructurado de eventos, con soporte para múltiples niveles, formatos de salida y persistencia de logs.

## 📋 Archivo: `lib/loggers.sh`

### 🎯 Responsabilidades

1. **📊 Logging Estructurado**: Registro de eventos con niveles y metadata
2. **💾 Persistencia**: Almacenamiento de logs en archivos rotativos
3. **🎨 Formateo**: Presentación clara y consistente de mensajes
4. **🔍 Filtrado**: Control granular de qué información se registra
5. **📈 Métricas**: Seguimiento de estadísticas y rendimiento
6. **🚨 Alertas**: Notificaciones para eventos críticos

## 🏗️ Arquitectura del Sistema

### 📊 Niveles de Log

```bash
# Jerarquía de niveles (del más bajo al más alto)
LOG_LEVEL_TRACE=0     # Información muy detallada para debugging
LOG_LEVEL_DEBUG=1     # Información de depuración  
LOG_LEVEL_INFO=2      # Información general
LOG_LEVEL_WARN=3      # Advertencias
LOG_LEVEL_ERROR=4     # Errores recuperables
LOG_LEVEL_FATAL=5     # Errores críticos que impiden continuar
```

### 🎛️ Configuración Global

```bash
# Configuración por defecto
LOG_LEVEL=${DEVTOOLS_LOG_LEVEL:-$LOG_LEVEL_INFO}     # Nivel mínimo
LOG_FILE="${DEVTOOLS_LOG_FILE:-$HOME/.devtools.log}" # Archivo de log
LOG_MAX_SIZE=${DEVTOOLS_LOG_MAX_SIZE:-10485760}      # 10MB máximo
LOG_BACKUP_COUNT=${DEVTOOLS_LOG_BACKUP_COUNT:-5}    # 5 archivos de respaldo
LOG_TO_CONSOLE=${DEVTOOLS_LOG_CONSOLE:-true}        # Mostrar en consola
LOG_TO_FILE=${DEVTOOLS_LOG_FILE_ENABLED:-true}      # Escribir a archivo
LOG_TIMESTAMP_FORMAT="%Y-%m-%d %H:%M:%S"            # Formato de timestamp
```

## 🔧 Funciones Principales

### 📝 Funciones de Logging por Nivel

#### `log_trace()`
Información extremadamente detallada para debugging profundo.

```bash
log_trace() {
    _log "$LOG_LEVEL_TRACE" "TRACE" "$1" "${2:-}"
}
```

**Uso:**
```bash
log_trace "Entrando en función process_file()" "file=config.json"
log_trace "Variable value: \$user_input = '$user_input'"
```

#### `log_debug()`
Información de depuración para desarrollo.

```bash
log_debug() {
    _log "$LOG_LEVEL_DEBUG" "DEBUG" "$1" "${2:-}"
}
```

**Uso:**
```bash
log_debug "Verificando dependencias del sistema"
log_debug "Comando ejecutado: git status" "exit_code=0"
```

#### `log_info()`
Información general del flujo de la aplicación.

```bash
log_info() {
    _log "$LOG_LEVEL_INFO" "INFO" "$1" "${2:-}"
}
```

**Uso:**
```bash
log_info "Iniciando verificación del sistema"
log_info "Encontradas 15 dependencias faltantes"
```

#### `log_warn()`
Advertencias sobre situaciones potencialmente problemáticas.

```bash
log_warn() {
    _log "$LOG_LEVEL_WARN" "WARN" "$1" "${2:-}"
}
```

**Uso:**
```bash
log_warn "Archivo de configuración no encontrado, usando valores por defecto"
log_warn "Versión de Node.js obsoleta detectada" "version=12.x, required=16.x"
```

#### `log_error()`
Errores recuperables que no impiden continuar.

```bash
log_error() {
    _log "$LOG_LEVEL_ERROR" "ERROR" "$1" "${2:-}"
}
```

**Uso:**
```bash
log_error "Error al conectar con la base de datos" "host=localhost:5432"
log_error "Falló la instalación de dependencia" "package=typescript"
```

#### `log_fatal()`
Errores críticos que requieren terminar la ejecución.

```bash
log_fatal() {
    _log "$LOG_LEVEL_FATAL" "FATAL" "$1" "${2:-}"
    exit 1  # Termina la ejecución
}
```

**Uso:**
```bash
log_fatal "No se puede escribir en el directorio de trabajo" "dir=/protected"
log_fatal "Archivo de configuración corrupto" "file=devtools.conf"
```

### 🎨 Funciones de Logger con Contexto

#### `log_operation()`
Registra el inicio y fin de operaciones importantes.

```bash
log_operation() {
    local operation="$1"
    local status="${2:-START}"
    local details="${3:-}"
    local timestamp=$(date +"$LOG_TIMESTAMP_FORMAT")
    
    case "$status" in
        "START")
            _log "$LOG_LEVEL_INFO" "OPERATION" "INICIANDO: $operation" "$details"
            echo "$timestamp|$operation|START" >> "${LOG_FILE}.ops"
            ;;
        "END")
            _log "$LOG_LEVEL_INFO" "OPERATION" "COMPLETADO: $operation" "$details"
            echo "$timestamp|$operation|END" >> "${LOG_FILE}.ops"
            ;;
        "FAIL")
            _log "$LOG_LEVEL_ERROR" "OPERATION" "FALLÓ: $operation" "$details"
            echo "$timestamp|$operation|FAIL" >> "${LOG_FILE}.ops"
            ;;
    esac
}
```

**Uso:**
```bash
log_operation "Instalación de dependencias" "START"
# ... código de instalación ...
log_operation "Instalación de dependencias" "END" "installed=25"
```

#### `log_command()`
Registra la ejecución de comandos del sistema.

```bash
log_command() {
    local command="$1"
    local exit_code="${2:-0}"
    local output="${3:-}"
    local execution_time="${4:-}"
    
    local level="$LOG_LEVEL_DEBUG"
    local status="SUCCESS"
    
    if [[ "$exit_code" -ne 0 ]]; then
        level="$LOG_LEVEL_ERROR"
        status="FAILED"
    fi
    
    local details="exit_code=$exit_code"
    [[ -n "$execution_time" ]] && details+=", time=${execution_time}ms"
    [[ -n "$output" ]] && details+=", output_lines=$(echo "$output" | wc -l)"
    
    _log "$level" "COMMAND" "$status: $command" "$details"
}
```

**Uso:**
```bash
start_time=$(date +%s%3N)
output=$(npm install 2>&1)
exit_code=$?
end_time=$(date +%s%3N)
execution_time=$((end_time - start_time))

log_command "npm install" "$exit_code" "$output" "$execution_time"
```

### 📊 Sistema de Métricas

#### `log_metric()`
Registra métricas cuantitativas para análisis posterior.

```bash
log_metric() {
    local metric_name="$1"
    local metric_value="$2"
    local metric_unit="${3:-count}"
    local tags="${4:-}"
    
    local timestamp=$(date +%s)
    local metric_line="$timestamp|$metric_name|$metric_value|$metric_unit"
    [[ -n "$tags" ]] && metric_line+="|$tags"
    
    echo "$metric_line" >> "${LOG_FILE}.metrics"
    _log "$LOG_LEVEL_DEBUG" "METRIC" "$metric_name: $metric_value $metric_unit" "$tags"
}
```

**Uso:**
```bash
log_metric "install_duration" "45.7" "seconds" "operation=setup"
log_metric "dependencies_installed" "25" "count" "manager=npm"
log_metric "memory_usage" "512.3" "MB" "process=devtools"
```

### 🔄 Sistema de Rotación de Logs

#### `rotate_logs()`
Rota archivos de log cuando exceden el tamaño máximo.

```bash
rotate_logs() {
    local log_file="$1"
    
    # Verificar si el archivo necesita rotación
    if [[ -f "$log_file" ]] && [[ $(stat -c%s "$log_file" 2>/dev/null || echo 0) -gt "$LOG_MAX_SIZE" ]]; then
        
        # Rotar archivos existentes
        for i in $(seq $((LOG_BACKUP_COUNT - 1)) -1 1); do
            local current="${log_file}.$i"
            local next="${log_file}.$((i + 1))"
            [[ -f "$current" ]] && mv "$current" "$next"
        done
        
        # Mover el archivo actual al .1
        mv "$log_file" "${log_file}.1"
        
        log_info "Log rotado" "archivo=$log_file, tamaño=$(format_bytes $(stat -c%s "${log_file}.1"))"
    fi
}
```

### 🎯 Funciones Especializadas

#### `log_progress()`
Registra progreso de operaciones largas.

```bash
log_progress() {
    local current="$1"
    local total="$2"
    local operation="${3:-operación}"
    local show_percentage="${4:-true}"
    
    local percentage=$((current * 100 / total))
    
    if [[ "$show_percentage" == "true" ]]; then
        _log "$LOG_LEVEL_INFO" "PROGRESS" "$operation: $current/$total ($percentage%)"
    else
        _log "$LOG_LEVEL_INFO" "PROGRESS" "$operation: $current/$total"
    fi
    
    # Actualizar archivo de progreso
    echo "$operation|$current|$total|$percentage" > "${LOG_FILE}.progress"
}
```

#### `log_stack_trace()`
Captura y registra stack traces para debugging.

```bash
log_stack_trace() {
    local message="${1:-Stack trace}"
    local skip_frames="${2:-1}"  # Omitir esta función del trace
    
    _log "$LOG_LEVEL_DEBUG" "STACK" "$message"
    
    local frame=0
    while caller $((frame + skip_frames)) 2>/dev/null; do
        ((frame++))
    done | while read line func file; do
        _log "$LOG_LEVEL_DEBUG" "STACK" "  at $func() [$file:$line]"
    done
}
```

## 🎨 Formateo y Presentación

### 📋 Función Principal de Logging

#### `_log()`
Función interna que maneja todo el formateo y enrutamiento de logs.

```bash
_log() {
    local level="$1"
    local level_name="$2"
    local message="$3"
    local details="${4:-}"
    
    # Filtrar por nivel mínimo
    [[ "$level" -lt "$LOG_LEVEL" ]] && return 0
    
    local timestamp=$(date +"$LOG_TIMESTAMP_FORMAT")
    local pid=$$
    local script_name=$(basename "$0")
    
    # Formatear mensaje principal
    local formatted_message="[$timestamp] [$level_name] [$script_name:$pid] $message"
    
    # Añadir detalles si están presentes
    [[ -n "$details" ]] && formatted_message+=" | $details"
    
    # Aplicar colores para consola
    if [[ "$LOG_TO_CONSOLE" == "true" ]]; then
        local colored_message
        case "$level_name" in
            "TRACE") colored_message=$(color_gray "$formatted_message") ;;
            "DEBUG") colored_message=$(color_cyan "$formatted_message") ;;
            "INFO")  colored_message=$(color_white "$formatted_message") ;;
            "WARN")  colored_message=$(color_yellow "$formatted_message") ;;
            "ERROR") colored_message=$(color_red "$formatted_message") ;;
            "FATAL") colored_message=$(text_bold $(color_red "$formatted_message")) ;;
            *) colored_message="$formatted_message" ;;
        esac
        echo "$colored_message" >&2
    fi
    
    # Escribir a archivo (sin colores)
    if [[ "$LOG_TO_FILE" == "true" ]]; then
        # Verificar rotación antes de escribir
        rotate_logs "$LOG_FILE"
        echo "$formatted_message" >> "$LOG_FILE"
    fi
}
```

### 🎨 Formateo Especializado

#### `log_section()`
Crea secciones visualmente distintivas en los logs.

```bash
log_section() {
    local section_name="$1"
    local separator_char="${2:-=}"
    local separator_length="${3:-60}"
    
    local separator=$(printf "%*s" "$separator_length" "" | tr ' ' "$separator_char")
    
    _log "$LOG_LEVEL_INFO" "SECTION" "$separator"
    _log "$LOG_LEVEL_INFO" "SECTION" "  $section_name"
    _log "$LOG_LEVEL_INFO" "SECTION" "$separator"
}
```

#### `log_table_row()`
Formatea datos tabulares en logs.

```bash
log_table_row() {
    local -a columns=("$@")
    local formatted_row=""
    
    for i in "${!columns[@]}"; do
        printf -v formatted_col "%-20s" "${columns[$i]}"
        formatted_row+="$formatted_col"
    done
    
    _log "$LOG_LEVEL_INFO" "TABLE" "$formatted_row"
}
```

**Uso:**
```bash
log_section "Resumen de Instalación"
log_table_row "Paquete" "Versión" "Estado"
log_table_row "node" "16.14.0" "✅ OK"
log_table_row "npm" "8.3.1" "✅ OK"
log_table_row "git" "2.34.1" "✅ OK"
```

## 🔧 Configuración Avanzada

### 🌍 Variables de Entorno

```bash
# Control de nivel de log
export DEVTOOLS_LOG_LEVEL=2              # INFO y superior

# Archivo de log
export DEVTOOLS_LOG_FILE="$HOME/.devtools.log"

# Rotación
export DEVTOOLS_LOG_MAX_SIZE=10485760     # 10MB
export DEVTOOLS_LOG_BACKUP_COUNT=5       # 5 archivos

# Salidas
export DEVTOOLS_LOG_CONSOLE=true         # Mostrar en consola
export DEVTOOLS_LOG_FILE_ENABLED=true    # Escribir a archivo

# Formato
export DEVTOOLS_LOG_FORMAT="detailed"    # simple|detailed|json
export DEVTOOLS_LOG_COLORS=true          # Habilitar colores
```

### ⚙️ Perfiles de Configuración

#### Perfil de Desarrollo

```bash
configure_development_logging() {
    export DEVTOOLS_LOG_LEVEL="$LOG_LEVEL_DEBUG"
    export DEVTOOLS_LOG_CONSOLE=true
    export DEVTOOLS_LOG_FILE_ENABLED=true
    export DEVTOOLS_LOG_COLORS=true
    
    log_info "Logging configurado para desarrollo"
}
```

#### Perfil de Producción

```bash
configure_production_logging() {
    export DEVTOOLS_LOG_LEVEL="$LOG_LEVEL_WARN"
    export DEVTOOLS_LOG_CONSOLE=false
    export DEVTOOLS_LOG_FILE_ENABLED=true
    export DEVTOOLS_LOG_COLORS=false
    
    log_info "Logging configurado para producción"
}
```

## 📊 Análisis y Reportes

### 📈 Generación de Reportes

#### `generate_log_report()`
Genera reportes automáticos de actividad.

```bash
generate_log_report() {
    local log_file="${1:-$LOG_FILE}"
    local report_file="${log_file}.report"
    local start_date="${2:-$(date -d '1 day ago' +'%Y-%m-%d')}"
    
    echo "REPORTE DE ACTIVIDAD - $(date)" > "$report_file"
    echo "Archivo: $log_file" >> "$report_file"
    echo "Período: desde $start_date" >> "$report_file"
    echo "" >> "$report_file"
    
    # Contar eventos por nivel
    echo "EVENTOS POR NIVEL:" >> "$report_file"
    grep -E "\[$start_date" "$log_file" | \
        grep -oE '\[(TRACE|DEBUG|INFO|WARN|ERROR|FATAL)\]' | \
        sort | uniq -c | sort -rn >> "$report_file"
    echo "" >> "$report_file"
    
    # Operaciones más frecuentes
    echo "OPERACIONES MÁS FRECUENTES:" >> "$report_file"
    grep -E "\[$start_date.*\[OPERATION\]" "$log_file" | \
        grep -oE 'INICIANDO: [^|]+|COMPLETADO: [^|]+' | \
        sort | uniq -c | sort -rn | head -10 >> "$report_file"
    echo "" >> "$report_file"
    
    # Errores recientes
    echo "ERRORES RECIENTES:" >> "$report_file"
    grep -E "\[$start_date.*\[(ERROR|FATAL)\]" "$log_file" | \
        tail -20 >> "$report_file"
    
    log_info "Reporte generado" "archivo=$report_file"
}
```

### 🔍 Funciones de Búsqueda

#### `search_logs()`
Búsqueda avanzada en logs con filtros.

```bash
search_logs() {
    local pattern="$1"
    local level_filter="${2:-.*}"       # Todos los niveles por defecto
    local date_filter="${3:-.*}"        # Todas las fechas por defecto
    local log_file="${4:-$LOG_FILE}"
    
    grep -E "\[$date_filter.*\[$level_filter\].*$pattern" "$log_file" | \
        tail -50  # Últimas 50 coincidencias
}
```

**Uso:**
```bash
search_logs "npm install" "ERROR" "2024-01-15"    # Errores de npm del 15 de enero
search_logs "COMPLETADO" "OPERATION"              # Operaciones completadas
search_logs "database" "" "2024-01"               # Cualquier mención de database en enero
```

## 🔧 Utilidades y Herramientas

### 📏 Funciones de Formato

#### `format_bytes()`
Convierte bytes a formato legible.

```bash
format_bytes() {
    local bytes="$1"
    local units=("B" "KB" "MB" "GB" "TB")
    local unit=0
    
    while [[ "$bytes" -ge 1024 && "$unit" -lt $((${#units[@]} - 1)) ]]; do
        bytes=$((bytes / 1024))
        ((unit++))
    done
    
    echo "${bytes}${units[$unit]}"
}
```

#### `format_duration()`
Formatea duración en milisegundos a formato legible.

```bash
format_duration() {
    local ms="$1"
    local seconds=$((ms / 1000))
    local minutes=$((seconds / 60))
    local hours=$((minutes / 60))
    
    if [[ "$hours" -gt 0 ]]; then
        echo "${hours}h ${minutes}m ${seconds}s"
    elif [[ "$minutes" -gt 0 ]]; then
        echo "${minutes}m ${seconds}s"
    elif [[ "$seconds" -gt 0 ]]; then
        echo "${seconds}s"
    else
        echo "${ms}ms"
    fi
}
```

### 🧪 Testing y Validación

#### `test_logging_system()`
Suite de pruebas para el sistema de logging.

```bash
test_logging_system() {
    local test_log="${LOG_FILE}.test"
    local original_log_file="$LOG_FILE"
    
    # Configurar archivo de prueba
    LOG_FILE="$test_log"
    LOG_TO_CONSOLE=false
    
    echo "Probando sistema de logging..."
    
    # Test de niveles
    log_trace "Mensaje de trace"
    log_debug "Mensaje de debug"
    log_info "Mensaje de info"
    log_warn "Mensaje de warning"
    log_error "Mensaje de error"
    
    # Verificar archivo
    if [[ -f "$test_log" ]] && [[ $(wc -l < "$test_log") -eq 4 ]]; then
        echo "✅ PASS: Filtrado de niveles funciona correctamente"
    else
        echo "❌ FAIL: Problema con filtrado de niveles"
    fi
    
    # Test de métricas
    log_metric "test_metric" "123" "units"
    if [[ -f "${test_log}.metrics" ]]; then
        echo "✅ PASS: Sistema de métricas funciona"
    else
        echo "❌ FAIL: Sistema de métricas no funciona"
    fi
    
    # Limpiar
    rm -f "$test_log" "${test_log}.metrics" "${test_log}.ops"
    LOG_FILE="$original_log_file"
    LOG_TO_CONSOLE=true
    
    echo "Pruebas de logging completadas"
}
```

## 📊 Casos de Uso Comunes

### 🚀 Proceso de Instalación

```bash
# Inicio de proceso
log_section "Instalación de DevTools"
log_operation "setup" "START"

# Progreso
log_info "Verificando requisitos del sistema"
log_progress 1 5 "Verificación del sistema"

log_info "Descargando dependencias"
log_progress 2 5 "Verificación del sistema"

# Comandos críticos
log_command "curl -fsSL https://get.docker.com | sh" "$?" "$output" "$duration"

# Métricas
log_metric "download_time" "45.2" "seconds"
log_metric "package_size" "125.3" "MB"

# Finalización
log_operation "setup" "END" "success=true"
```

### 🐛 Debugging de Problemas

```bash
# Error context
log_error "Fallo al conectar con servicio" "host=api.example.com, port=443"
log_stack_trace "Error en función connect_api"

# Estado del sistema
log_debug "Variables de entorno:" "PATH=$PATH, NODE_ENV=$NODE_ENV"
log_debug "Archivos presentes:" "$(ls -la /config/ | wc -l) archivos en /config/"

# Recuperación
log_info "Intentando recuperación automática"
log_warn "Usando configuración de respaldo"
```

### 📊 Monitoreo de Performance

```bash
# Métricas de rendimiento
start_time=$(date +%s%3N)
# ... operación ...
end_time=$(date +%s%3N)
duration=$((end_time - start_time))

log_metric "operation_duration" "$duration" "ms" "operation=backup"
log_metric "memory_usage" "$(get_memory_usage)" "MB"
log_metric "disk_usage" "$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')" "percent"
```

---

> 💡 **Nota**: El sistema de logging se inicializa automáticamente y está integrado con el sistema de colores para proporcionar una experiencia visual consistente y informativa en todas las salidas.
