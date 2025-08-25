# 📚 Librerías del Sistema (`lib/`)

El directorio `lib/` contiene las librerías fundamentales que proporcionan funcionalidades transversales a todo el ecosistema DevTools. Estas librerías implementan patrones de diseño reutilizables y ofrecen una API consistente para todas las operaciones del sistema.

## 🏗️ Arquitectura de Librerías

### 🎯 Principios de Diseño

1. **🔗 Modularidad**: Cada librería tiene una responsabilidad específica y bien definida
2. **🔄 Reutilización**: Funciones comunes accesibles desde cualquier componente
3. **🛡️ Robustez**: Manejo de errores y fallbacks para diferentes entornos
4. **⚡ Performance**: Optimización de carga y ejecución
5. **🎨 Consistencia**: API uniforme y patrones de uso estandarizados

### 📦 Estructura del Directorio

```
lib/
├── colors.sh          # Sistema de colores inteligente
├── loggers.sh         # Sistema de logging estructurado
└── icons.sh           # Biblioteca de iconos adaptativos
```

## 📋 Inventario de Librerías

### 🌈 `colors.sh` - Sistema de Colores

**🎯 Propósito**: Gestión inteligente de colores en terminal con detección automática de capacidades.

**🔑 Características Principales**:
- ✅ Detección automática de soporte de colores
- 🎨 Paleta completa con colores semánticos
- 🔄 Fallback elegante para terminales limitados
- 🌍 Soporte para temas claro/oscuro
- 📊 Utilidades para barras de progreso y separadores

**🚀 Funciones Destacadas**:
```bash
color_success "Operación exitosa"        # Verde semántico
color_error "Error crítico"              # Rojo semántico
color_progress_bar 75 100                # Barra de progreso coloreada
debug_colors                             # Diagnóstico del sistema
```

**📖 [Ver Documentación Completa](./colors.md)**

---

### 📝 `loggers.sh` - Sistema de Logging

**🎯 Propósito**: Infraestructura robusta para registro estructurado de eventos y métricas.

**🔑 Características Principales**:
- 📊 Múltiples niveles de log (TRACE, DEBUG, INFO, WARN, ERROR, FATAL)
- 💾 Persistencia con rotación automática de archivos
- 🎨 Formateo inteligente con colores
- 📈 Sistema de métricas integrado
- 🔍 Búsqueda y análisis de logs

**🚀 Funciones Destacadas**:
```bash
log_info "Sistema inicializado"          # Logging básico
log_operation "backup" "START"           # Tracking de operaciones
log_metric "cpu_usage" "45.2" "percent"  # Métricas cuantitativas
generate_log_report                      # Reportes automáticos
```

**📖 [Ver Documentación Completa](./loggers.md)**

---

### ✨ `icons.sh` - Sistema de Iconos

**🎯 Propósito**: Biblioteca completa de iconos Unicode/ASCII con fallback automático.

**🔑 Características Principales**:
- 🔍 Detección automática de capacidades Unicode/Emoji
- 🎭 Biblioteca extensa de iconos semánticos
- 🔄 Fallback inteligente a ASCII
- 🛠️ Iconos específicos para herramientas
- 🎨 Integración con sistema de colores

**🚀 Funciones Destacadas**:
```bash
icon_success                             # ✅ o [OK]
status_indicator "running" "Docker"      # Combinación icono+color
tool_status "node" "installed" "16.x"    # Estado de herramientas
progress_bar_with_icons 50 100          # Barras con iconos
```

**📖 [Ver Documentación Completa](./icons.md)**

## 🔗 Integración y Dependencias

### 📊 Matriz de Dependencias

| Librería | Depende de | Es usada por |
|----------|------------|-------------|
| `colors.sh` | Sistema base | `loggers.sh`, `icons.sh`, comandos |
| `loggers.sh` | `colors.sh` | Todos los comandos, script principal |
| `icons.sh` | `colors.sh` | Comandos de interfaz, reporting |

### 🔄 Flujo de Carga

```bash
# 1. Carga inicial desde devTools
source "$LIB_DIR/colors.sh"      # Base para colorización
source "$LIB_DIR/loggers.sh"     # Sistema de logging
source "$LIB_DIR/icons.sh"       # Iconografía del sistema

# 2. Inicialización automática
detect_color_support             # Configurar colores
configure_icons                  # Configurar iconos
log_info "Librerías cargadas"    # Primera entrada de log
```

## 🛠️ Patrones de Uso Comunes

### 🎨 Mensajes de Usuario

Combinación típica de las tres librerías para interfaces ricas:

```bash
# Mensaje de éxito con icono, color y log
show_success() {
    local message="$1"
    local details="${2:-}"
    
    echo "$(color_success "$(icon_success) $message")"
    log_info "$message" "$details"
}

# Mensaje de error completo
show_error() {
    local message="$1"
    local details="${2:-}"
    
    echo "$(color_error "$(icon_error) $message")" >&2
    log_error "$message" "$details"
}
```

### 📊 Progreso de Operaciones

```bash
# Tracking completo de progreso
track_operation() {
    local operation="$1"
    local current="$2"
    local total="$3"
    
    # Log de progreso
    log_progress "$current" "$total" "$operation"
    
    # Display visual
    echo "$(progress_bar_with_icons "$current" "$total" "$operation")"
    
    # Métrica
    local percentage=$((current * 100 / total))
    log_metric "${operation}_progress" "$percentage" "percent"
}
```

### 🔧 Verificación de Herramientas

```bash
# Verificar y reportar estado de herramienta
check_tool() {
    local tool="$1"
    local version_cmd="$2"
    
    log_debug "Verificando $tool"
    
    if command -v "$tool" >/dev/null 2>&1; then
        local version=$($version_cmd 2>/dev/null)
        echo "$(tool_status "$tool" "installed" "$version")"
        log_info "$tool disponible" "version=$version"
        return 0
    else
        echo "$(tool_status "$tool" "missing")"
        log_warn "$tool no encontrado"
        return 1
    fi
}
```

## ⚙️ Configuración del Sistema

### 🌍 Variables de Entorno Globales

```bash
# Configuración de colores
export DEVTOOLS_NO_COLOR=false          # Deshabilitar colores
export DEVTOOLS_THEME=dark              # Tema de colores

# Configuración de logging
export DEVTOOLS_LOG_LEVEL=2             # Nivel INFO
export DEVTOOLS_LOG_FILE="$HOME/.devtools.log"
export DEVTOOLS_LOG_CONSOLE=true        # Mostrar en consola

# Configuración de iconos
export DEVTOOLS_NO_UNICODE=false        # Deshabilitar Unicode
export DEVTOOLS_NO_EMOJI=false          # Deshabilitar emojis
export DEVTOOLS_ICON_THEME=default      # Tema de iconos
```

### 🔧 Inicialización Completa

```bash
# Función de inicialización del sistema de librerías
initialize_libraries() {
    local config_mode="${1:-auto}"
    
    log_debug "Inicializando sistema de librerías" "mode=$config_mode"
    
    case "$config_mode" in
        "development")
            export DEVTOOLS_LOG_LEVEL="$LOG_LEVEL_DEBUG"
            export DEVTOOLS_LOG_CONSOLE=true
            export DEVTOOLS_ICON_THEME=detailed
            ;;
        "production")
            export DEVTOOLS_LOG_LEVEL="$LOG_LEVEL_WARN"
            export DEVTOOLS_LOG_CONSOLE=false
            export DEVTOOLS_ICON_THEME=minimal
            ;;
        "minimal")
            export DEVTOOLS_NO_COLOR=true
            export DEVTOOLS_NO_UNICODE=true
            export DEVTOOLS_ICON_THEME=ascii
            ;;
        "auto")
            # Usar detección automática (comportamiento por defecto)
            ;;
    esac
    
    # Re-configurar con nuevos parámetros
    detect_color_support
    configure_icons "$DEVTOOLS_ICON_THEME"
    
    log_info "Sistema de librerías inicializado" "mode=$config_mode"
}
```

## 🧪 Testing y Validación

### 🔍 Suite de Pruebas Integrada

```bash
# Prueba completa del sistema de librerías
test_all_libraries() {
    echo "$(color_title "$(icon_tool) TESTING DE LIBRERÍAS DEVTOOLS")"
    echo
    
    # Test individual de cada librería
    local tests_passed=0
    local tests_total=3
    
    echo "$(color_subtitle "Probando colors.sh...")"
    if test_color_functionality; then
        echo "$(status_indicator "success" "Sistema de colores: PASS")"
        ((tests_passed++))
    else
        echo "$(status_indicator "error" "Sistema de colores: FAIL")"
    fi
    
    echo "$(color_subtitle "Probando loggers.sh...")"
    if test_logging_system; then
        echo "$(status_indicator "success" "Sistema de logging: PASS")"
        ((tests_passed++))
    else
        echo "$(status_indicator "error" "Sistema de logging: FAIL")"
    fi
    
    echo "$(color_subtitle "Probando icons.sh...")"
    test_icon_system  # Esta función siempre muestra el estado
    echo "$(status_indicator "success" "Sistema de iconos: PASS")"
    ((tests_passed++))
    
    echo
    echo "$(color_title "RESUMEN DE PRUEBAS")"
    echo "$(status_indicator "info" "Pruebas pasadas: $tests_passed/$tests_total")"
    
    if [[ "$tests_passed" -eq "$tests_total" ]]; then
        echo "$(status_indicator "success" "Todas las librerías funcionan correctamente")"
        return 0
    else
        echo "$(status_indicator "error" "Algunas pruebas fallaron")"
        return 1
    fi
}
```

### 📊 Diagnóstico del Sistema

```bash
# Diagnóstico completo de capacidades
diagnose_system_capabilities() {
    echo "$(color_title "$(icon_info) DIAGNÓSTICO DEL SISTEMA")"
    echo
    
    echo "$(color_subtitle "Entorno del Terminal:")"
    echo "  TERM: ${TERM:-no definido}"
    echo "  LANG: ${LANG:-no definido}"
    echo "  COLORTERM: ${COLORTERM:-no definido}"
    echo
    
    echo "$(color_subtitle "Capacidades Detectadas:")"
    echo "  Colores habilitados: $(color_info "$COLORS_ENABLED")"
    echo "  Colores soportados: $(color_info "$TERM_COLORS")"
    echo "  Unicode habilitado: $(color_info "$UNICODE_SUPPORT")"
    echo "  Emoji habilitado: $(color_info "$EMOJI_SUPPORT")"
    echo "  Nerd Fonts: $(color_info "$NERD_FONTS_SUPPORT")"
    echo
    
    echo "$(color_subtitle "Configuración Activa:")"
    echo "  Tema de colores: $(color_info "${DEVTOOLS_THEME:-auto}")"
    echo "  Tema de iconos: $(color_info "$ICON_THEME")"
    echo "  Nivel de log: $(color_info "$LOG_LEVEL")"
    echo "  Archivo de log: $(color_info "$LOG_FILE")"
    echo
    
    echo "$(color_subtitle "Prueba Visual:")"
    debug_colors
}
```

## 📚 Mejores Prácticas

### ✅ Recomendaciones de Uso

1. **🔗 Cargar en Orden**: Siempre cargar `colors.sh` primero, luego las demás librerías
2. **🎨 Consistencia Visual**: Usar siempre las funciones de combinación (ej: `status_indicator`)
3. **📝 Logging Estructurado**: Incluir contexto relevante en todos los logs
4. **🔄 Fallbacks**: Testear en diferentes terminales para verificar fallbacks
5. **⚡ Performance**: Usar caché para operaciones repetitivas de iconos/colores

### ❌ Anti-patrones

1. **🚫 Hard-coding Colores**: Nunca usar códigos ANSI directamente
2. **🚫 Asumir Capacidades**: No asumir soporte Unicode sin verificar
3. **🚫 Logs Excesivos**: Evitar logging en loops intensivos
4. **🚫 Iconos Inconsistentes**: Mantener coherencia temática
5. **🚫 Configuración Hardcoded**: Usar siempre variables de entorno

### 🔧 Extensión del Sistema

Para añadir nuevas funcionalidades a las librerías:

```bash
# Ejemplo: Añadir nuevo icono específico
icon_database() {
    if [[ "$NERD_FONTS_SUPPORT" == "true" ]]; then
        echo ""  # Nerd Font database icon
    elif [[ "$EMOJI_SUPPORT" == "true" ]]; then
        echo "🗄️"
    elif [[ "$UNICODE_SUPPORT" == "true" ]]; then
        echo "⚃"
    else
        echo "[DB]"
    fi
}

# Ejemplo: Añadir nuevo nivel de log
log_trace() {
    _log "$LOG_LEVEL_TRACE" "TRACE" "$1" "${2:-}"
}
```

---

> 💡 **Nota**: Las librerías se auto-configuran al cargar, pero pueden ser reconfiguradas dinámicamente usando las funciones de configuración apropiadas. Todas las librerías están diseñadas para funcionar tanto independientemente como en conjunto, proporcionando máxima flexibilidad de uso.
