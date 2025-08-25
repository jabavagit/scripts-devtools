# ✨ Sistema de Iconos (`lib/icons.sh`)

El sistema de iconos de DevTools proporciona una biblioteca completa de iconos Unicode y ASCII con fallback inteligente, optimizando la experiencia visual según las capacidades del terminal del usuario.

## 📋 Archivo: `lib/icons.sh`

### 🎯 Responsabilidades

1. **🎨 Iconografía Consistente**: Biblioteca unificada de iconos para toda la aplicación
2. **🔍 Detección Automática**: Identificar soporte Unicode del terminal
3. **🔄 Fallback Inteligente**: Degradación elegante a ASCII en terminales limitados
4. **🎭 Iconos Semánticos**: Mapeo de iconos a conceptos y estados específicos
5. **🌍 Internacionalización**: Soporte para diferentes conjuntos de caracteres
6. **⚡ Performance**: Carga eficiente y caché de iconos

## 🏗️ Arquitectura del Sistema

### 🔍 Detección de Capacidades

```bash
# Variables globales de estado
UNICODE_SUPPORT=true          # ¿Terminal soporta Unicode?
EMOJI_SUPPORT=true           # ¿Terminal soporta emojis?
NERD_FONTS_SUPPORT=false     # ¿Fuentes Nerd Font disponibles?
ICON_THEME="default"         # Tema de iconos activo
```

#### `detect_unicode_support()`
Detecta automáticamente las capacidades Unicode del terminal.

```bash
detect_unicode_support() {
    # Verificar variables de entorno
    if [[ "${LC_ALL:-}" =~ UTF-8 ]] || [[ "${LANG:-}" =~ UTF-8 ]] || [[ "${LC_CTYPE:-}" =~ UTF-8 ]]; then
        UNICODE_SUPPORT=true
    else
        UNICODE_SUPPORT=false
    fi
    
    # Verificar capacidades específicas del terminal
    case "${TERM:-}" in
        *-256color|xterm-kitty|alacritty) 
            UNICODE_SUPPORT=true
            EMOJI_SUPPORT=true
            ;;
        screen*|tmux*)
            UNICODE_SUPPORT=true
            EMOJI_SUPPORT=false  # Conservador para multiplexores
            ;;
        linux|dumb)
            UNICODE_SUPPORT=false
            EMOJI_SUPPORT=false
            ;;
    esac
    
    # Verificar Nerd Fonts (más adelante)
    detect_nerd_fonts_support
    
    # Override manual si está configurado
    [[ "${DEVTOOLS_NO_UNICODE:-}" == "true" ]] && UNICODE_SUPPORT=false
    [[ "${DEVTOOLS_NO_EMOJI:-}" == "true" ]] && EMOJI_SUPPORT=false
}
```

#### `detect_nerd_fonts_support()`
Detecta si las Nerd Fonts están disponibles.

```bash
detect_nerd_fonts_support() {
    # Lista de fuentes Nerd Font comunes
    local nerd_fonts=(
        "FiraCode Nerd Font"
        "JetBrainsMono Nerd Font"
        "Source Code Pro"
        "Hack Nerd Font"
    )
    
    # Verificar en el entorno
    if command -v fc-list >/dev/null 2>&1; then
        for font in "${nerd_fonts[@]}"; do
            if fc-list | grep -qi "$font"; then
                NERD_FONTS_SUPPORT=true
                return 0
            fi
        done
    fi
    
    # Override manual
    [[ "${DEVTOOLS_NERD_FONTS:-}" == "true" ]] && NERD_FONTS_SUPPORT=true
    
    NERD_FONTS_SUPPORT=false
}
```

## 🎨 Biblioteca de Iconos

### ✅ Estados y Resultados

#### `icon_success()`
Icono para operaciones exitosas.

```bash
icon_success() {
    if [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "✅"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "✓"
    else
        echo "[OK]"
    fi
}
```

#### `icon_error()`
Icono para errores y fallos.

```bash
icon_error() {
    if [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "❌"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "✗"
    else
        echo "[ERR]"
    fi
}
```

#### `icon_warning()`
Icono para advertencias.

```bash
icon_warning() {
    if [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "⚠️"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "⚠"
    else
        echo "[!]"
    fi
}
```

#### `icon_info()`
Icono para información general.

```bash
icon_info() {
    if [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "ℹ️"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "ⓘ"
    else
        echo "[i]"
    fi
}
```

#### `icon_question()`
Icono para preguntas e inputs del usuario.

```bash
icon_question() {
    if [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "❓"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "?"
    else
        echo "[?]"
    fi
}
```

### 🔧 Herramientas y Tecnologías

#### `icon_tool()`
Icono genérico para herramientas.

```bash
icon_tool() {
    if [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "🔧"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "⚙"
    else
        echo "[TOOL]"
    fi
}
```

#### `icon_docker()`
Icono específico para Docker.

```bash
icon_docker() {
    if [[ "$NERD_FONTS_SUPPORT" == "true" ]]; then
        echo ""  # Nerd Font Docker icon
    elif [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "🐳"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "🐋"
    else
        echo "[DOCKER]"
    fi
}
```

#### `icon_node()`
Icono para Node.js.

```bash
icon_node() {
    if [[ "$NERD_FONTS_SUPPORT" == "true" ]]; then
        echo ""  # Nerd Font Node.js icon
    elif [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "🟢"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "◉"
    else
        echo "[NODE]"
    fi
}
```

#### `icon_git()`
Icono para Git.

```bash
icon_git() {
    if [[ "$NERD_FONTS_SUPPORT" == "true" ]]; then
        echo ""  # Nerd Font Git icon
    elif [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "📚"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "⚡"
    else
        echo "[GIT]"
    fi
}
```

#### `icon_npm()`
Icono para NPM.

```bash
icon_npm() {
    if [[ "$NERD_FONTS_SUPPORT" == "true" ]]; then
        echo ""  # Nerd Font NPM icon
    elif [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "📦"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "📦"
    else
        echo "[NPM]"
    fi
}
```

### 📁 Archivos y Directorios

#### `icon_file()`
Icono genérico para archivos.

```bash
icon_file() {
    local extension="${1:-}"
    
    if [[ "$NERD_FONTS_SUPPORT" == "true" ]]; then
        case "$extension" in
            "js"|"jsx")     echo "" ;;  # JavaScript
            "ts"|"tsx")     echo "" ;;  # TypeScript
            "json")         echo "" ;;  # JSON
            "md"|"markdown") echo "" ;;  # Markdown
            "yml"|"yaml")   echo "" ;;  # YAML
            "sh"|"bash")    echo "" ;;  # Shell
            "conf"|"config") echo "" ;;  # Config
            *)              echo "" ;;  # Generic file
        esac
    elif [[ "$EMOJI_SUPPORT" == "true" ]]; then
        case "$extension" in
            "js"|"jsx"|"ts"|"tsx") echo "📜" ;;
            "json"|"yml"|"yaml")   echo "⚙️" ;;
            "md"|"markdown")       echo "📄" ;;
            "sh"|"bash")           echo "📋" ;;
            *)                     echo "📄" ;;
        esac
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "▪"
    else
        echo "*"
    fi
}
```

#### `icon_folder()`
Icono para directorios.

```bash
icon_folder() {
    local folder_name="${1:-}"
    
    if [[ "$NERD_FONTS_SUPPORT" == "true" ]]; then
        case "$folder_name" in
            "node_modules") echo "" ;;  # Node modules
            ".git")         echo "" ;;  # Git folder
            "src"|"source") echo "" ;;  # Source code
            "docs")         echo "" ;;  # Documentation
            "test"|"tests") echo "" ;;  # Tests
            *)              echo "" ;;  # Generic folder
        esac
    elif [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "📁"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "▶"
    else
        echo "/"
    fi
}
```

### 🚀 Procesos y Acciones

#### `icon_loading()`
Icono para procesos en ejecución.

```bash
icon_loading() {
    if [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "⏳"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "◐"
    else
        echo "[...]"
    fi
}
```

#### `icon_spinner()`
Spinner animado para procesos largos.

```bash
icon_spinner() {
    local frame="${1:-0}"
    
    if [[ "$UNICODE_SUPPORT" == "true" ]]; then
        local spinner_chars=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
        echo "${spinner_chars[$((frame % ${#spinner_chars[@]}))]}"
    else
        local spinner_chars=("|" "/" "-" "\\")
        echo "${spinner_chars[$((frame % ${#spinner_chars[@]}))]}"
    fi
}
```

#### `icon_download()`
Icono para descargas.

```bash
icon_download() {
    if [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "⬇️"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "↓"
    else
        echo "[DL]"
    fi
}
```

#### `icon_upload()`
Icono para subidas.

```bash
icon_upload() {
    if [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "⬆️"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "↑"
    else
        echo "[UP]"
    fi
}
```

### 🎯 Estados de Sistema

#### `icon_running()`
Icono para servicios en ejecución.

```bash
icon_running() {
    if [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "🟢"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "●"
    else
        echo "[RUN]"
    fi
}
```

#### `icon_stopped()`
Icono para servicios detenidos.

```bash
icon_stopped() {
    if [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "🔴"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "●"
    else
        echo "[STOP]"
    fi
}
```

#### `icon_pending()`
Icono para estados pendientes.

```bash
icon_pending() {
    if [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "🟡"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "◐"
    else
        echo "[PEND]"
    fi
}
```

### 🔢 Números y Listas

#### `icon_list_item()`
Icono para elementos de lista.

```bash
icon_list_item() {
    if [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "▸"
    else
        echo ">"
    fi
}
```

#### `icon_bullet()`
Viñeta para listas.

```bash
icon_bullet() {
    if [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "•"
    else
        echo "*"
    fi
}
```

#### `icon_arrow_right()`
Flecha hacia la derecha.

```bash
icon_arrow_right() {
    if [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "→"
    else
        echo "->"
    fi
}
```

#### `icon_arrow_left()`
Flecha hacia la izquierda.

```bash
icon_arrow_left() {
    if [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "←"
    else
        echo "<-"
    fi
}
```

## 🎨 Funciones de Alto Nivel

### 📊 Indicadores de Estado

#### `status_indicator()`
Combina icono y color para mostrar estados.

```bash
status_indicator() {
    local status="$1"
    local message="${2:-}"
    
    case "$status" in
        "success"|"ok"|"pass")
            echo "$(color_success "$(icon_success) ${message}")"
            ;;
        "error"|"fail"|"failed")
            echo "$(color_error "$(icon_error) ${message}")"
            ;;
        "warning"|"warn")
            echo "$(color_warning "$(icon_warning) ${message}")"
            ;;
        "info"|"information")
            echo "$(color_info "$(icon_info) ${message}")"
            ;;
        "running"|"active")
            echo "$(color_success "$(icon_running) ${message}")"
            ;;
        "stopped"|"inactive")
            echo "$(color_error "$(icon_stopped) ${message}")"
            ;;
        "pending"|"loading")
            echo "$(color_warning "$(icon_pending) ${message}")"
            ;;
        *)
            echo "$(icon_info) ${message}"
            ;;
    esac
}
```

**Uso:**
```bash
status_indicator "success" "Docker instalado correctamente"
status_indicator "error" "No se pudo conectar al servidor"
status_indicator "running" "Servicio activo"
```

### 🛠️ Herramientas Específicas

#### `tool_status()`
Muestra el estado de herramientas específicas.

```bash
tool_status() {
    local tool="$1"
    local status="$2"
    local version="${3:-}"
    local icon=""
    
    # Seleccionar icono según la herramienta
    case "$tool" in
        "docker")     icon=$(icon_docker) ;;
        "node"|"nodejs") icon=$(icon_node) ;;
        "git")        icon=$(icon_git) ;;
        "npm")        icon=$(icon_npm) ;;
        *)            icon=$(icon_tool) ;;
    esac
    
    local status_icon=""
    case "$status" in
        "installed"|"available") status_icon=$(icon_success) ;;
        "missing"|"not_found")   status_icon=$(icon_error) ;;
        "outdated"|"old")        status_icon=$(icon_warning) ;;
    esac
    
    local output="$icon $tool"
    [[ -n "$version" ]] && output+=" $version"
    output+=" $status_icon"
    
    echo "$output"
}
```

**Uso:**
```bash
tool_status "docker" "installed" "20.10.7"
tool_status "node" "missing"
tool_status "git" "outdated" "2.25.1"
```

### 📁 Navegación de Archivos

#### `file_tree_item()`
Genera elementos para árboles de archivos.

```bash
file_tree_item() {
    local path="$1"
    local level="${2:-0}"
    local is_last="${3:-false}"
    
    local indent=""
    local connector=""
    
    # Crear indentación
    for ((i=0; i<level; i++)); do
        indent+="    "
    done
    
    # Conectores del árbol
    if [[ "$is_last" == "true" ]]; then
        if [[ "$UNICODE_SUPPORT" == "true" ]]; then
            connector="└── "
        else
            connector="\`-- "
        fi
    else
        if [[ "$UNICODE_SUPPORT" == "true" ]]; then
            connector="├── "
        else
            connector="|-- "
        fi
    fi
    
    local filename=$(basename "$path")
    local icon=""
    
    if [[ -d "$path" ]]; then
        icon=$(icon_folder "$filename")
    else
        local extension="${filename##*.}"
        icon=$(icon_file "$extension")
    fi
    
    echo "${indent}${connector}${icon} ${filename}"
}
```

### 🎯 Barras de Progreso con Iconos

#### `progress_bar_with_icons()`
Barra de progreso mejorada con iconos.

```bash
progress_bar_with_icons() {
    local current="$1"
    local total="$2"
    local operation="${3:-Procesando}"
    local width="${4:-30}"
    
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    # Caracteres para la barra según capacidades Unicode
    local fill_char="█"
    local empty_char="░"
    
    if [[ "$UNICODE_SUPPORT" != "true" ]]; then
        fill_char="#"
        empty_char="."
    fi
    
    local bar_filled=$(printf "%*s" "$filled" "" | tr ' ' "$fill_char")
    local bar_empty=$(printf "%*s" "$empty" "" | tr ' ' "$empty_char")
    
    # Icono de estado según progreso
    local status_icon
    if [[ "$percentage" -eq 100 ]]; then
        status_icon=$(icon_success)
    elif [[ "$percentage" -gt 0 ]]; then
        status_icon=$(icon_loading)
    else
        status_icon=$(icon_pending)
    fi
    
    echo "$status_icon $operation [$bar_filled$bar_empty] ${percentage}%"
}
```

## 🎨 Temas de Iconos

### 🌙 Tema Minimal

```bash
theme_minimal() {
    export ICON_THEME="minimal"
    
    # Override específicos para tema minimal
    icon_success() { echo "✓"; }
    icon_error() { echo "✗"; }
    icon_warning() { echo "!"; }
    icon_info() { echo "i"; }
    icon_loading() { echo "◦"; }
}
```

### 🎯 Tema Detallado

```bash
theme_detailed() {
    export ICON_THEME="detailed"
    
    # Usar todos los iconos disponibles según capacidades
    # (Esta es la configuración por defecto)
}
```

### 🔤 Tema ASCII Puro

```bash
theme_ascii() {
    export ICON_THEME="ascii"
    UNICODE_SUPPORT=false
    EMOJI_SUPPORT=false
    NERD_FONTS_SUPPORT=false
    
    # Forzar todos los iconos a ASCII
    icon_success() { echo "[OK]"; }
    icon_error() { echo "[ERR]"; }
    icon_warning() { echo "[!]"; }
    icon_info() { echo "[i]"; }
    icon_loading() { echo "[...]"; }
}
```

## 🔧 Configuración y Personalización

### 🌍 Variables de Entorno

```bash
# Control de iconos
export DEVTOOLS_NO_UNICODE=false        # Deshabilitar Unicode
export DEVTOOLS_NO_EMOJI=false          # Deshabilitar emojis
export DEVTOOLS_NERD_FONTS=false        # Forzar Nerd Fonts
export DEVTOOLS_ICON_THEME=default      # Tema de iconos

# Configuración específica
export DEVTOOLS_ICON_SUCCESS="✅"       # Icono de éxito personalizado
export DEVTOOLS_ICON_ERROR="❌"         # Icono de error personalizado
```

### ⚙️ Función de Configuración

#### `configure_icons()`
Configuración inicial del sistema de iconos.

```bash
configure_icons() {
    local theme="${1:-default}"
    
    # Detectar capacidades
    detect_unicode_support
    
    # Aplicar tema
    case "$theme" in
        "minimal") theme_minimal ;;
        "ascii") theme_ascii ;;
        "detailed") theme_detailed ;;
        *) theme_detailed ;;
    esac
    
    log_debug "Iconos configurados" "theme=$theme, unicode=$UNICODE_SUPPORT, emoji=$EMOJI_SUPPORT, nerd_fonts=$NERD_FONTS_SUPPORT"
}
```

## 🛠️ Utilidades de Desarrollo

### 🧪 Testing del Sistema

#### `test_icon_system()`
Suite de pruebas para verificar el sistema de iconos.

```bash
test_icon_system() {
    echo "Probando sistema de iconos..."
    echo
    
    echo "Capacidades detectadas:"
    echo "  Unicode: $UNICODE_SUPPORT"
    echo "  Emoji: $EMOJI_SUPPORT"
    echo "  Nerd Fonts: $NERD_FONTS_SUPPORT"
    echo "  Tema: $ICON_THEME"
    echo
    
    echo "Iconos básicos:"
    echo "  Éxito: $(icon_success)"
    echo "  Error: $(icon_error)"
    echo "  Advertencia: $(icon_warning)"
    echo "  Información: $(icon_info)"
    echo "  Cargando: $(icon_loading)"
    echo
    
    echo "Iconos de herramientas:"
    echo "  Docker: $(icon_docker)"
    echo "  Node.js: $(icon_node)"
    echo "  Git: $(icon_git)"
    echo "  NPM: $(icon_npm)"
    echo
    
    echo "Indicadores de estado:"
    echo "  $(status_indicator "success" "Operación exitosa")"
    echo "  $(status_indicator "error" "Error encontrado")"
    echo "  $(status_indicator "warning" "Advertencia activa")"
    echo "  $(status_indicator "running" "Servicio en ejecución")"
    echo
    
    echo "Barra de progreso:"
    echo "  $(progress_bar_with_icons 25 100 "Instalando")"
    echo "  $(progress_bar_with_icons 75 100 "Configurando")"
    echo "  $(progress_bar_with_icons 100 100 "Completado")"
}
```

### 📊 Generador de Catálogo

#### `generate_icon_catalog()`
Genera un catálogo completo de iconos disponibles.

```bash
generate_icon_catalog() {
    local output_file="${1:-icon_catalog.md}"
    
    cat > "$output_file" << 'EOF'
# Catálogo de Iconos DevTools

## Capacidades del Sistema
EOF
    
    echo "- Unicode: $UNICODE_SUPPORT" >> "$output_file"
    echo "- Emoji: $EMOJI_SUPPORT" >> "$output_file"
    echo "- Nerd Fonts: $NERD_FONTS_SUPPORT" >> "$output_file"
    echo "- Tema: $ICON_THEME" >> "$output_file"
    echo "" >> "$output_file"
    
    echo "## Iconos por Categoría" >> "$output_file"
    echo "" >> "$output_file"
    
    echo "### Estados" >> "$output_file"
    echo "| Función | Icono | Descripción |" >> "$output_file"
    echo "|---------|-------|-------------|" >> "$output_file"
    echo "| icon_success | $(icon_success) | Operación exitosa |" >> "$output_file"
    echo "| icon_error | $(icon_error) | Error o fallo |" >> "$output_file"
    echo "| icon_warning | $(icon_warning) | Advertencia |" >> "$output_file"
    echo "| icon_info | $(icon_info) | Información |" >> "$output_file"
    echo "" >> "$output_file"
    
    # Continuar con más categorías...
    
    log_info "Catálogo de iconos generado" "archivo=$output_file"
}
```

## 📊 Casos de Uso Comunes

### 🚀 Interface de Comandos

```bash
# Menú principal con iconos
echo "$(color_title "$(icon_tool) DevTools - Menú Principal")"
echo
echo "$(icon_list_item) $(color_cmd "verify")   $(icon_arrow_right) Verificar sistema"
echo "$(icon_list_item) $(color_cmd "setup")    $(icon_arrow_right) Configurar herramientas"
echo "$(icon_list_item) $(color_cmd "clean")    $(icon_arrow_right) Limpiar archivos temporales"
echo "$(icon_list_item) $(color_cmd "status")   $(icon_arrow_right) Estado del sistema"
```

### 📊 Reportes de Estado

```bash
# Reporte de servicios
echo "$(color_title "$(icon_info) Estado de Servicios")"
echo
echo "$(status_indicator "running" "Docker Engine")"
echo "$(status_indicator "stopped" "PostgreSQL")"
echo "$(status_indicator "pending" "Redis Server")"
echo
echo "$(tool_status "node" "installed" "16.14.0")"
echo "$(tool_status "npm" "installed" "8.3.1")"
echo "$(tool_status "git" "outdated" "2.25.1")"
```

### 📁 Exploración de Archivos

```bash
# Árbol de directorios
echo "$(color_title "$(icon_folder) Estructura del Proyecto")"
echo
echo "$(file_tree_item "/project" 0 false)"
echo "$(file_tree_item "/project/src" 1 false)"
echo "$(file_tree_item "/project/src/index.js" 2 false)"
echo "$(file_tree_item "/project/src/config.json" 2 true)"
echo "$(file_tree_item "/project/docs" 1 true)"
echo "$(file_tree_item "/project/docs/README.md" 2 true)"
```

### ⏳ Procesos de Instalación

```bash
# Progreso de instalación con iconos contextuales
echo "$(icon_download) Descargando dependencias..."
echo "$(progress_bar_with_icons 25 100 "Descarga")"
echo
echo "$(icon_tool) Configurando herramientas..."
echo "$(progress_bar_with_icons 75 100 "Configuración")"
echo
echo "$(icon_success) Instalación completada"
echo "$(progress_bar_with_icons 100 100 "Completado")"
```

---

> 💡 **Nota**: El sistema de iconos se inicializa automáticamente al cargar la librería, detectando las capacidades del terminal y adaptando los iconos para proporcionar la mejor experiencia visual posible en cualquier entorno.
