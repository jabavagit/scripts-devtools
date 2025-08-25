#!/bin/bash

# 🎨 Sistema de Iconos DevTools
# ============================
# Descripción: Gestión inteligente de iconos para terminal
# Detección automática UTF-8 vs ASCII fallback

# === CONFIGURACIÓN ===

# Variables globales
ICONS_ENABLED=true
ICONS_UTF8=true

# Detectar soporte UTF-8
detect_icon_support() {
    # Verificar si el terminal soporta UTF-8
    if [[ "${LC_ALL:-${LC_CTYPE:-${LANG:-}}}" =~ [Uu][Tt][Ff]-?8 ]]; then
        ICONS_UTF8=true
    elif command -v locale > /dev/null 2>&1 && locale charmap 2>/dev/null | grep -qi utf; then
        ICONS_UTF8=true
    else
        ICONS_UTF8=false
    fi
    
    # Desactivar iconos si se solicita explícitamente
    if [[ "${DEVTOOLS_NO_ICONS:-}" == "true" ]] || [[ "${NO_ICONS:-}" == "1" ]]; then
        ICONS_ENABLED=false
    fi
}

# Función para mostrar icono con fallback
show_icon() {
    local utf8_icon="$1"
    local ascii_fallback="$2"
    
    if [[ "$ICONS_ENABLED" == "false" ]]; then
        echo ""
    elif [[ "$ICONS_UTF8" == "true" ]]; then
        echo "$utf8_icon"
    else
        echo "$ascii_fallback"
    fi
}

# === ICONOS DE ESTADO ===

# Estados básicos
icon_success() { show_icon "✅" "[OK]"; }
icon_error() { show_icon "❌" "[ERROR]"; }
icon_warning() { show_icon "⚠️" "[WARN]"; }
icon_info() { show_icon "ℹ️" "[INFO]"; }
icon_question() { show_icon "❓" "[?]"; }

# Estados de proceso
icon_process() { show_icon "🔄" "[PROC]"; }
icon_loading() { show_icon "⏳" "[LOAD]"; }
icon_done() { show_icon "✔️" "[DONE]"; }
icon_failed() { show_icon "✗" "[FAIL]"; }
icon_skipped() { show_icon "➖" "[SKIP]"; }

# Estados críticos
icon_critical() { show_icon "🚨" "[CRIT]"; }
icon_security() { show_icon "🛡️" "[SEC]"; }
icon_blocked() { show_icon "🚫" "[BLOCK]"; }

# === ICONOS DE COMANDOS ===

# Comandos principales
icon_verify() { show_icon "🔍" "[VERIFY]"; }
icon_setup() { show_icon "⚙️" "[SETUP]"; }
icon_clean() { show_icon "🧹" "[CLEAN]"; }
icon_status() { show_icon "📊" "[STATUS]"; }
icon_update() { show_icon "🔄" "[UPDATE]"; }
icon_ports() { show_icon "🌐" "[PORTS]"; }

# Acciones
icon_install() { show_icon "📦" "[INSTALL]"; }
icon_delete() { show_icon "🗑️" "[DELETE]"; }
icon_config() { show_icon "🔧" "[CONFIG]"; }
icon_backup() { show_icon "💾" "[BACKUP]"; }
icon_restore() { show_icon "♻️" "[RESTORE]"; }

# === ICONOS DE ARCHIVOS Y DIRECTORIOS ===

# Tipos de archivo
icon_file() { show_icon "📄" "[FILE]"; }
icon_folder() { show_icon "📁" "[DIR]"; }
icon_config_file() { show_icon "⚙️" "[CONF]"; }
icon_script() { show_icon "📜" "[SCRIPT]"; }
icon_log() { show_icon "📝" "[LOG]"; }

# Archivos específicos
icon_package_json() { show_icon "📦" "[PKG]"; }
icon_dockerfile() { show_icon "🐳" "[DOCKER]"; }
icon_readme() { show_icon "📋" "[README]"; }
icon_gitignore() { show_icon "🙈" "[IGNORE]"; }

# === ICONOS DE TECNOLOGÍAS ===

# Lenguajes y frameworks
icon_javascript() { show_icon "🟨" "[JS]"; }
icon_typescript() { show_icon "🔷" "[TS]"; }
icon_react() { show_icon "⚛️" "[REACT]"; }
icon_vue() { show_icon "💚" "[VUE]"; }
icon_angular() { show_icon "🔺" "[NG]"; }
icon_node() { show_icon "🟢" "[NODE]"; }
icon_python() { show_icon "🐍" "[PY]"; }

# Herramientas
icon_git() { show_icon "🌿" "[GIT]"; }
icon_docker() { show_icon "🐳" "[DOCKER]"; }
icon_npm() { show_icon "📦" "[NPM]"; }
icon_yarn() { show_icon "🧶" "[YARN]"; }
icon_pnpm() { show_icon "📦" "[PNPM]"; }

# === ICONOS DE SISTEMA ===

# Hardware y sistema
icon_cpu() { show_icon "🖥️" "[CPU]"; }
icon_memory() { show_icon "💾" "[MEM]"; }
icon_disk() { show_icon "💿" "[DISK]"; }
icon_network() { show_icon "🌐" "[NET]"; }
icon_battery() { show_icon "🔋" "[BAT]"; }

# Procesos
icon_running() { show_icon "🏃" "[RUN]"; }
icon_stopped() { show_icon "⏸️" "[STOP]"; }
icon_zombie() { show_icon "🧟" "[ZOMBIE]"; }
icon_kill() { show_icon "💀" "[KILL]"; }

# === ICONOS DE DESARROLLO ===

# Testing
icon_test() { show_icon "🧪" "[TEST]"; }
icon_test_pass() { show_icon "✅" "[PASS]"; }
icon_test_fail() { show_icon "❌" "[FAIL]"; }
icon_coverage() { show_icon "📊" "[COV]"; }

# Build y deploy
icon_build() { show_icon "🔨" "[BUILD]"; }
icon_deploy() { show_icon "🚀" "[DEPLOY]"; }
icon_bundle() { show_icon "📦" "[BUNDLE]"; }
icon_optimize() { show_icon "⚡" "[OPT]"; }

# === ICONOS DE CONECTIVIDAD ===

# Red y servicios
icon_online() { show_icon "🟢" "[ONLINE]"; }
icon_offline() { show_icon "🔴" "[OFFLINE]"; }
icon_api() { show_icon "🔌" "[API]"; }
icon_database() { show_icon "🗃️" "[DB]"; }
icon_cache() { show_icon "💨" "[CACHE]"; }

# Puertos y procesos
icon_port_open() { show_icon "🟢" "[OPEN]"; }
icon_port_closed() { show_icon "🔴" "[CLOSED]"; }
icon_port_listening() { show_icon "👂" "[LISTEN]"; }
icon_connection() { show_icon "🔗" "[CONN]"; }

# === ICONOS DE TIEMPO ===

# Tiempo y fechas
icon_clock() { show_icon "🕒" "[TIME]"; }
icon_calendar() { show_icon "📅" "[DATE]"; }
icon_timer() { show_icon "⏱️" "[TIMER]"; }
icon_schedule() { show_icon "📋" "[SCHED]"; }

# === ICONOS DE INTERFAZ ===

# Navegación
icon_arrow_right() { show_icon "➡️" "[->]"; }
icon_arrow_left() { show_icon "⬅️" "[<-]"; }
icon_arrow_up() { show_icon "⬆️" "[^]"; }
icon_arrow_down() { show_icon "⬇️" "[v]"; }

# Elementos de UI
icon_menu() { show_icon "☰" "[MENU]"; }
icon_home() { show_icon "🏠" "[HOME]"; }
icon_search() { show_icon "🔍" "[SEARCH]"; }
icon_filter() { show_icon "🔽" "[FILTER]"; }

# === ICONOS ESPECIALES ===

# DevTools específicos
icon_logo() { show_icon "🛠️" "[DEVTOOLS]"; }
icon_version() { show_icon "🏷️" "[VER]"; }
icon_help() { show_icon "❓" "[HELP]"; }
icon_debug() { show_icon "🐛" "[DEBUG]"; }

# Emociones y feedback
icon_happy() { show_icon "😊" "[HAPPY]"; }
icon_sad() { show_icon "😢" "[SAD]"; }
icon_thinking() { show_icon "🤔" "[THINK]"; }
icon_celebrate() { show_icon "🎉" "[PARTY]"; }

# === ICONOS ANIMADOS (simulados) ===

# Spinner simple (para uso en bucles)
icon_spinner() {
    local frame="${1:-0}"
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local ascii_frames=("/" "-" "\\" "|")
    
    if [[ "$ICONS_UTF8" == "true" ]]; then
        local total=${#frames[@]}
        local index=$((frame % total))
        echo "${frames[$index]}"
    else
        local total=${#ascii_frames[@]}
        local index=$((frame % total))
        echo "${ascii_frames[$index]}"
    fi
}

# === FUNCIONES DE UTILIDAD ===

# Mostrar todos los iconos disponibles
debug_icons() {
    echo "$(icon_logo) INFORMACIÓN DE ICONOS"
    echo "UTF-8 habilitado: $ICONS_UTF8"
    echo "Iconos habilitados: $ICONS_ENABLED"
    echo
    echo "PRUEBA DE ICONOS:"
    echo "Estados: $(icon_success) $(icon_error) $(icon_warning) $(icon_info)"
    echo "Procesos: $(icon_process) $(icon_loading) $(icon_done) $(icon_failed)"
    echo "Comandos: $(icon_verify) $(icon_setup) $(icon_clean) $(icon_status)"
    echo "Archivos: $(icon_file) $(icon_folder) $(icon_config_file) $(icon_script)"
    echo "Tech: $(icon_javascript) $(icon_react) $(icon_docker) $(icon_git)"
}

# Crear icono personalizado con fallback
custom_icon() {
    local utf8="$1"
    local ascii="$2"
    local name="${3:-custom}"
    
    eval "icon_$name() { show_icon \"$utf8\" \"$ascii\"; }"
}

# Verificar si un icono existe
icon_exists() {
    local icon_name="$1"
    declare -f "icon_$icon_name" > /dev/null 2>&1
}

# Obtener icono por nombre
get_icon() {
    local icon_name="$1"
    
    if icon_exists "$icon_name"; then
        "icon_$icon_name"
    else
        show_icon "❓" "[?]"
    fi
}

# === TEMAS DE ICONOS ===

# Tema minimalista (solo ASCII)
theme_minimal() {
    ICONS_UTF8=false
}

# Tema completo (UTF-8)
theme_full() {
    ICONS_UTF8=true
}

# Tema sin iconos
theme_none() {
    ICONS_ENABLED=false
}

# === UTILIDADES DE PRESENTACIÓN ===

# Crear lista con iconos
icon_list() {
    local items=("$@")
    
    for item in "${items[@]}"; do
        echo "$(icon_arrow_right) $item"
    done
}

# Crear progreso con iconos
icon_progress() {
    local current="$1"
    local total="$2"
    local completed_icon="${3:-$(icon_success)}"
    local pending_icon="${4:-$(show_icon "⚪" "[O]")}"
    
    local progress=""
    for ((i=1; i<=total; i++)); do
        if [[ "$i" -le "$current" ]]; then
            progress+="$completed_icon"
        else
            progress+="$pending_icon"
        fi
    done
    
    echo "$progress"
}

# Inicializar detección de iconos al cargar
detect_icon_support
