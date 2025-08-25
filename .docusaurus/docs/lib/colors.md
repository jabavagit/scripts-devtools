# 🌈 Sistema de Colores (`lib/colors.sh`)

El sistema de colores de DevTools proporciona una interfaz inteligente para el manejo de colores en terminal, con detección automática de capacidades y fallback elegante para terminales limitados.

## 📋 Archivo: `lib/colors.sh`

### 🎯 Responsabilidades

1. **🔍 Detección Automática**: Identificar capacidades de color del terminal
2. **🎨 Gestión de Colores**: Aplicar colores de forma inteligente
3. **🔄 Fallback Graceful**: Degradación elegante en terminales sin color
4. **🎭 Colores Semánticos**: Mapeo de colores a significados específicos
5. **⚙️ Configuración**: Soporte para temas y personalización

## 🔧 Funciones Principales

### 🔍 Detección de Capacidades

#### `detect_color_support()`
Detecta automáticamente si el terminal soporta colores.

```bash
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
```

**Factores de Detección:**
- **Terminal Interactivo**: `[[ -t 1 ]]` verifica stdout
- **Comando tput**: Disponibilidad de herramientas de terminal
- **Número de Colores**: `tput colors` determina capacidades
- **Variables de Entorno**: `NO_COLOR`, `DEVTOOLS_NO_COLOR`

#### Variables Globales

```bash
COLORS_ENABLED=true    # ¿Están los colores habilitados?
TERM_COLORS=0         # Número de colores soportados
```

### 🎨 Aplicación de Colores

#### `apply_color()`
Función central que aplica colores solo si están habilitados.

```bash
apply_color() {
    local color_code="$1"
    local text="$2"
    
    if [[ "$COLORS_ENABLED" == "true" ]]; then
        echo -e "\033[${color_code}m${text}\033[0m"
    else
        echo "$text"
    fi
}
```

**Parámetros:**
- `$1`: Código ANSI de color (ej: "31" para rojo)
- `$2`: Texto a colorear

**Comportamiento:**
- Si colores están habilitados: aplica secuencias ANSI
- Si colores están deshabilitados: retorna texto sin modificar

## 🎨 Paleta de Colores

### 🌈 Colores Básicos

```bash
# Colores de texto básicos
color_red()     { apply_color "31" "$1"; }     # Rojo
color_green()   { apply_color "32" "$1"; }     # Verde  
color_yellow()  { apply_color "33" "$1"; }     # Amarillo
color_blue()    { apply_color "34" "$1"; }     # Azul
color_magenta() { apply_color "35" "$1"; }     # Magenta
color_cyan()    { apply_color "36" "$1"; }     # Cian
color_white()   { apply_color "37" "$1"; }     # Blanco
color_gray()    { apply_color "90" "$1"; }     # Gris
```

### 🎯 Colores Semánticos

```bash
# Estados y significados
color_success() { color_green "$1"; }    # Operaciones exitosas
color_error()   { color_red "$1"; }      # Errores y fallos
color_warning() { color_yellow "$1"; }   # Advertencias
color_info()    { color_blue "$1"; }     # Información general
```

### 🎭 Colores de Interfaz

```bash
# Elementos de UI específicos
color_title()    { apply_color "1;35" "$1"; }  # Títulos (Magenta Bold)
color_subtitle() { apply_color "1;36" "$1"; }  # Subtítulos (Cian Bold)
color_cmd()      { apply_color "1;32" "$1"; }  # Comandos (Verde Bold)
color_opt()      { apply_color "36" "$1"; }    # Opciones (Cian)
color_path()     { apply_color "33" "$1"; }    # Rutas de archivos (Amarillo)
color_url()      { apply_color "34;4" "$1"; }  # URLs (Azul Subrayado)
```

### 🌈 Colores Avanzados (256 colores)

#### `color_256()`
Soporte para la paleta extendida de 256 colores.

```bash
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
```

#### Paleta DevTools Específica

```bash
color_devtools_primary()   { color_256 "39" "$1"; }   # Azul DevTools
color_devtools_secondary() { color_256 "214" "$1"; }  # Naranja
color_devtools_accent()    { color_256 "198" "$1"; }  # Rosa
```

## ✨ Efectos de Texto

### 🎨 Estilos Tipográficos

```bash
text_bold()      { apply_color "1" "$1"; }    # Texto en negrita
text_dim()       { apply_color "2" "$1"; }    # Texto tenue
text_italic()    { apply_color "3" "$1"; }    # Texto en cursiva
text_underline() { apply_color "4" "$1"; }    # Texto subrayado
text_blink()     { apply_color "5" "$1"; }    # Texto parpadeante
text_reverse()   { apply_color "7" "$1"; }    # Colores invertidos
```

### 🌈 Colores de Fondo

```bash
bg_red()     { apply_color "41" "$1"; }    # Fondo rojo
bg_green()   { apply_color "42" "$1"; }    # Fondo verde
bg_yellow()  { apply_color "43" "$1"; }    # Fondo amarillo
bg_blue()    { apply_color "44" "$1"; }    # Fondo azul
```

## 🛠️ Utilidades Avanzadas

### 📏 Separadores Visuales

#### `color_separator()`
Crea líneas de separación con colores personalizables.

```bash
color_separator() {
    local length="${1:-50}"      # Longitud de la línea
    local char="${2:-=}"         # Carácter a usar
    local color="${3:-gray}"     # Color de la línea
    
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
```

**Ejemplos de Uso:**
```bash
color_separator 30 "-" "blue"      # Línea azul de 30 guiones
color_separator 50                 # Línea gris de 50 signos igual
color_separator 20 "=" "red"       # Línea roja de 20 signos igual
```

### 📊 Barras de Progreso

#### `color_progress_bar()`
Genera barras de progreso visuales con colores adaptativos.

```bash
color_progress_bar() {
    local current="$1"    # Valor actual
    local total="$2"      # Valor total
    local width="${3:-30}" # Ancho de la barra
    
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
```

**Ejemplo de Salida:**
```bash
color_progress_bar 25 100 20
# [█████░░░░░░░░░░░░░░░] 25%  (amarillo)

color_progress_bar 85 100 20  
# [█████████████████░░░] 85%  (verde)
```

### 📋 Tablas con Colores

#### `color_table_row()`
Alterna colores en filas de tabla para mejor legibilidad.

```bash
color_table_row() {
    local row_number="$1"
    local text="$2"
    
    if [[ $((row_number % 2)) -eq 0 ]]; then
        color_gray "$text"     # Filas pares en gris
    else
        echo "$text"           # Filas impares normales
    fi
}
```

## 🎨 Sistema de Temas

### 🌙 Tema Oscuro

```bash
theme_dark() {
    export DEVTOOLS_THEME="dark"
    # Optimización para fondos oscuros
    # Los colores claros destacan más
}
```

### ☀️ Tema Claro

```bash
theme_light() {
    export DEVTOOLS_THEME="light"
    # Optimización para fondos claros
    # Los colores oscuros son más legibles
}
```

## 🔧 Configuración y Personalización

### 🌍 Variables de Entorno

```bash
# Control de colores
export DEVTOOLS_NO_COLOR=true          # Desactivar todos los colores
export NO_COLOR=1                      # Estándar universal para desactivar colores
export DEVTOOLS_THEME=dark             # Tema preferido

# Control de terminal
export TERM=xterm-256color             # Forzar soporte de 256 colores
export COLORTERM=truecolor             # Indicar soporte de color verdadero
```

### ⚙️ Funciones de Configuración

```bash
# Verificar soporte de 256 colores
has_256_colors() {
    [[ "$TERM_COLORS" -ge 256 ]] && [[ "$COLORS_ENABLED" == "true" ]]
}

# Verificar soporte de color verdadero (24-bit)
has_truecolor() {
    [[ "$COLORTERM" == "truecolor" ]] || [[ "$COLORTERM" == "24bit" ]]
}
```

## 🐛 Debugging y Diagnóstico

### 🔍 Función de Debug

#### `debug_colors()`
Muestra información completa sobre el estado del sistema de colores.

```bash
debug_colors() {
    echo "$(color_title 'INFORMACIÓN DE COLORES')"
    echo "Terminal: $TERM"
    echo "Colores soportados: $TERM_COLORS"
    echo "Colores habilitados: $COLORS_ENABLED"
    echo "COLORTERM: ${COLORTERM:-no definido}"
    echo
    echo "$(color_title 'PRUEBA DE COLORES BÁSICOS:')"
    echo "$(color_red 'Rojo') $(color_green 'Verde') $(color_yellow 'Amarillo') $(color_blue 'Azul')"
    echo "$(color_magenta 'Magenta') $(color_cyan 'Cian') $(color_white 'Blanco') $(color_gray 'Gris')"
    echo
    echo "$(color_title 'PRUEBA DE EFECTOS:')"
    echo "$(text_bold 'Negrita') $(text_dim 'Tenue') $(text_italic 'Cursiva') $(text_underline 'Subrayado')"
    echo
    echo "$(color_title 'PRUEBA DE COLORES SEMÁNTICOS:')"
    echo "$(color_success 'Éxito') $(color_error 'Error') $(color_warning 'Advertencia') $(color_info 'Información')"
}
```

### 🧪 Testing

```bash
# Test básico de funcionalidad
test_color_functionality() {
    # Test detección
    detect_color_support
    
    # Test aplicación básica
    local result=$(color_red "test")
    if [[ "$COLORS_ENABLED" == "true" ]]; then
        [[ "$result" =~ $'\033' ]] || return 1
    else
        [[ "$result" == "test" ]] || return 1
    fi
    
    echo "PASS: Color system working correctly"
}
```

## 📊 Casos de Uso Comunes

### ✅ Mensajes de Estado

```bash
# Éxito
echo "$(color_success "✅ Operación completada exitosamente")"

# Error
echo "$(color_error "❌ Error: archivo no encontrado")"

# Advertencia  
echo "$(color_warning "⚠️ Advertencia: configuración obsoleta")"

# Información
echo "$(color_info "ℹ️ Procesando archivos...")"
```

### 📋 Interfaces de Usuario

```bash
# Título de sección
echo "$(color_title "🔧 CONFIGURACIÓN DEL SISTEMA")"
echo "$(color_separator 50 "=" "cyan")"

# Comando con opciones
echo "Usar: $(color_cmd "devTools verify") $(color_opt "--verbose")"

# Rutas y URLs
echo "Archivo: $(color_path "/home/user/proyecto/config.json")"
echo "URL: $(color_url "https://github.com/proyecto/repo")"
```

### 📊 Progreso y Métricas

```bash
# Barra de progreso
echo "Instalando dependencias: $(color_progress_bar 65 100)"

# Lista con puntos
echo "$(color_list_item "Verificando archivos...")"
echo "$(color_list_item "Instalando dependencias...")"
echo "$(color_list_item "Configurando herramientas...")"
```

---

> 💡 **Nota**: El sistema de colores se inicializa automáticamente al cargar la librería y adapta su comportamiento según las capacidades detectadas del terminal, garantizando una experiencia visual óptima en cualquier entorno.
