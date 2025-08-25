#!/bin/bash

# 🌈 Sistema de Colores DevTools
# =============================
# Descripción: Gestión inteligente de colores para terminal
# Detección automática de capacidades de color

# Variables globales
COLORS_ENABLED=true
TERM_COLORS=0

# Detectar capacidades de color del terminal
detect_color_support() {
    # Verificar si el terminal soporta colores
    if [[ -t 1 ]] && command -v tput > /dev/null 2>&1; then
        TERM_COLORS=$(tput colors 2>/dev/null || echo 0)
    fi
    
    # Desactivar colores si no hay soporte o se solicita explícitamente
    if [[ "$TERM_COLORS" -lt 8 ]] || [[ "${NO_COLOR:-}" == "1" ]] || [[ "${DEVTOOLS_NO_COLOR:-}" == "true" ]]; then
        COLORS_ENABLED=false
    fi
}

# Aplicar color si está habilitado
apply_color() {
    local color_code="$1"
    local text="$2"
    
    if [[ "$COLORS_ENABLED" == "true" ]]; then
        echo -e "\033[${color_code}m${text}\033[0m"
    else
        echo "$text"
    fi
}

# === COLORES BÁSICOS ===

# Colores de texto
color_red() { apply_color "31" "$1"; }
color_green() { apply_color "32" "$1"; }
color_yellow() { apply_color "33" "$1"; }
color_blue() { apply_color "34" "$1"; }
color_magenta() { apply_color "35" "$1"; }
color_cyan() { apply_color "36" "$1"; }
color_white() { apply_color "37" "$1"; }
color_gray() { apply_color "90" "$1"; }

# Colores de fondo
bg_red() { apply_color "41" "$1"; }
bg_green() { apply_color "42" "$1"; }
bg_yellow() { apply_color "43" "$1"; }
bg_blue() { apply_color "44" "$1"; }

# === COLORES SEMÁNTICOS ===

# Estados
color_success() { color_green "$1"; }
color_error() { color_red "$1"; }
color_warning() { color_yellow "$1"; }
color_info() { color_blue "$1"; }

# Elementos de interfaz
color_title() { apply_color "1;35" "$1"; }  # Magenta bold
color_subtitle() { apply_color "1;36" "$1"; }  # Cyan bold
color_cmd() { apply_color "1;32" "$1"; }  # Green bold
color_opt() { apply_color "36" "$1"; }  # Cyan
color_path() { apply_color "33" "$1"; }  # Yellow
color_url() { apply_color "34;4" "$1"; }  # Blue underline

# === COLORES AVANZADOS (256 colores) ===

# Verificar soporte para 256 colores
has_256_colors() {
    [[ "$TERM_COLORS" -ge 256 ]] && [[ "$COLORS_ENABLED" == "true" ]]
}

# Colores 256
color_256() {
    local color_number="$1"
    local text="$2"
    
    if has_256_colors; then
        echo -e "\033[38;5;${color_number}m${text}\033[0m"
    else
        # Fallback a colores básicos
        case "$color_number" in
            196) color_red "$text" ;;
            46) color_green "$text" ;;
            226) color_yellow "$text" ;;
            21) color_blue "$text" ;;
            201) color_magenta "$text" ;;
            51) color_cyan "$text" ;;
            *) echo "$text" ;;
        esac
    fi
}

# Paleta específica de DevTools
color_devtools_primary() { color_256 "39" "$1"; }  # Azul DevTools
color_devtools_secondary() { color_256 "214" "$1"; }  # Naranja
color_devtools_accent() { color_256 "198" "$1"; }  # Rosa

# === EFECTOS DE TEXTO ===

# Estilos
text_bold() { apply_color "1" "$1"; }
text_dim() { apply_color "2" "$1"; }
text_italic() { apply_color "3" "$1"; }
text_underline() { apply_color "4" "$1"; }
text_blink() { apply_color "5" "$1"; }
text_reverse() { apply_color "7" "$1"; }

# === FUNCIONES DE UTILIDAD ===

# Crear línea de separación
color_separator() {
    local length="${1:-50}"
    local char="${2:-=}"
    local color="${3:-gray}"
    
    local line=$(printf "%*s" "$length" "" | tr ' ' "$char")
    case "$color" in
        "red") color_red "$line" ;;
        "green") color_green "$line" ;;
        "yellow") color_yellow "$line" ;;
        "blue") color_blue "$line" ;;
        "magenta") color_magenta "$line" ;;
        "cyan") color_cyan "$line" ;;
        *) color_gray "$line" ;;
    esac
}

# Crear barra de progreso coloreada
color_progress_bar() {
    local current="$1"
    local total="$2"
    local width="${3:-30}"
    
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    local bar_filled=$(printf "%*s" "$filled" "" | tr ' ' '█')
    local bar_empty=$(printf "%*s" "$empty" "" | tr ' ' '░')
    
    if [[ "$percentage" -lt 30 ]]; then
        echo "[$(color_red "$bar_filled")$(color_gray "$bar_empty")] ${percentage}%"
    elif [[ "$percentage" -lt 70 ]]; then
        echo "[$(color_yellow "$bar_filled")$(color_gray "$bar_empty")] ${percentage}%"
    else
        echo "[$(color_green "$bar_filled")$(color_gray "$bar_empty")] ${percentage}%"
    fi
}

# Crear tabla con colores alternados
color_table_row() {
    local row_number="$1"
    local text="$2"
    
    if [[ $((row_number % 2)) -eq 0 ]]; then
        color_gray "$text"
    else
        echo "$text"
    fi
}

# === THEMES ===

# Theme oscuro
theme_dark() {
    export DEVTOOLS_THEME="dark"
    # Colores optimizados para fondos oscuros
}

# Theme claro
theme_light() {
    export DEVTOOLS_THEME="light"
    # Colores optimizados para fondos claros
}

# === DEBUGGING ===

# Mostrar información de colores
debug_colors() {
    echo "$(color_title 'INFORMACIÓN DE COLORES')"
    echo "Terminal: $TERM"
    echo "Colores soportados: $TERM_COLORS"
    echo "Colores habilitados: $COLORS_ENABLED"
    echo
    echo "$(color_title 'PRUEBA DE COLORES:')"
    echo "$(color_red 'Rojo') $(color_green 'Verde') $(color_yellow 'Amarillo') $(color_blue 'Azul')"
    echo "$(color_magenta 'Magenta') $(color_cyan 'Cian') $(color_white 'Blanco') $(color_gray 'Gris')"
    echo
    echo "$(color_title 'EFECTOS:')"
    echo "$(text_bold 'Negrita') $(text_dim 'Tenue') $(text_italic 'Cursiva') $(text_underline 'Subrayado')"
}

# Inicializar detección de colores al cargar
detect_color_support
