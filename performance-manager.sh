#!/bin/bash

# ⚡ Performance Manager - Gestión centralizada de métricas y benchmarks
# Administra todos los análisis de rendimiento del proyecto

set -euo pipefail

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Directorio base del proyecto
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PERFORMANCE_SCRIPTS_DIR="$PROJECT_ROOT/scripts/performance"
REPORTS_DIR="$PROJECT_ROOT/performance-reports"

# Función para mostrar ayuda
show_help() {
    echo -e "${CYAN}⚡ Performance Manager - Gestión de Métricas y Benchmarks${NC}"
    echo -e "${BLUE}Uso: $0 [COMANDO] [OPCIONES]${NC}"
    echo ""
    echo -e "${MAGENTA}📋 COMANDOS DISPONIBLES:${NC}"
    echo ""
    echo -e "${GREEN}🚀 Benchmarks:${NC}"
    echo -e "  ${YELLOW}benchmark${NC}       Ejecutar benchmark completo del proyecto"
    echo -e "  ${YELLOW}quick${NC}           Benchmark rápido (métricas básicas)"
    echo -e "  ${YELLOW}detailed${NC}        Benchmark detallado con profiling"
    echo -e "  ${YELLOW}compare${NC}         Comparar entre dos commits o branches"
    echo ""
    echo -e "${GREEN}📊 Análisis:${NC}"
    echo -e "  ${YELLOW}analyze${NC}         Analizar métricas de la aplicación"
    echo -e "  ${YELLOW}bundle${NC}          Análisis de tamaño de bundle"
    echo -e "  ${YELLOW}lighthouse${NC}      Audit de Lighthouse"
    echo -e "  ${YELLOW}memory${NC}          Análisis de uso de memoria"
    echo ""
    echo -e "${GREEN}📈 Reportes:${NC}"
    echo -e "  ${YELLOW}report${NC}          Generar reporte de performance"
    echo -e "  ${YELLOW}history${NC}         Historial de métricas"
    echo -e "  ${YELLOW}trends${NC}          Tendencias de performance"
    echo -e "  ${YELLOW}dashboard${NC}       Dashboard interactivo"
    echo ""
    echo -e "${GREEN}🔧 Utilidades:${NC}"
    echo -e "  ${YELLOW}setup${NC}           Configurar herramientas de performance"
    echo -e "  ${YELLOW}clean${NC}           Limpiar reportes antiguos"
    echo -e "  ${YELLOW}watch${NC}           Monitor de performance en tiempo real"
    echo -e "  ${YELLOW}profile${NC}         Profiling detallado de componentes"
    echo ""
    echo -e "${BLUE}📖 EJEMPLOS:${NC}"
    echo -e "  ${CYAN}$0 benchmark${NC}                    # Benchmark completo"
    echo -e "  ${CYAN}$0 quick${NC}                        # Métricas rápidas"
    echo -e "  ${CYAN}$0 compare main develop${NC}         # Comparar branches"
    echo -e "  ${CYAN}$0 lighthouse${NC}                   # Audit de Lighthouse"
    echo -e "  ${CYAN}$0 report --format html${NC}         # Reporte HTML"
    echo ""
    echo -e "${YELLOW}💡 TIP: Usa '$0 quick' para métricas rápidas durante desarrollo${NC}"
}

# Función para verificar dependencias
check_dependencies() {
    local missing_deps=()

    # Verificar Node.js
    if ! command -v node &> /dev/null; then
        missing_deps+=("node")
    fi

    # Verificar npm
    if ! command -v npm &> /dev/null; then
        missing_deps+=("npm")
    fi

    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${RED}❌ Error: Dependencias faltantes: ${missing_deps[*]}${NC}"
        echo -e "${BLUE}💡 Ejecuta '$0 setup' para configurar el entorno${NC}"
        exit 1
    fi
}

# Función para crear directorio de reportes
ensure_reports_dir() {
    mkdir -p "$REPORTS_DIR"
}

# Función para obtener timestamp
get_timestamp() {
    date '+%Y%m%d-%H%M%S'
}

# Función para benchmark completo
performance_benchmark() {
    local type="${1:-full}"
    local timestamp=$(get_timestamp)
    local report_file="$REPORTS_DIR/benchmark-$timestamp.md"

    echo -e "${CYAN}⚡ Ejecutando benchmark de performance...${NC}"
    ensure_reports_dir

    # Verificar que el proyecto esté buildado
    if [ ! -d "$PROJECT_ROOT/.next" ]; then
        echo -e "${YELLOW}🏗️  Proyecto no buildado, ejecutando build...${NC}"
        cd "$PROJECT_ROOT"
        npm run build
    fi

    echo -e "${YELLOW}📊 Generando reporte de benchmark...${NC}"

    # Crear reporte
    cat > "$report_file" << EOF
# Performance Benchmark Report

**Fecha:** $(date '+%Y-%m-%d %H:%M:%S')
**Tipo:** $type
**Commit:** $(git rev-parse --short HEAD 2>/dev/null || echo "N/A")
**Branch:** $(git branch --show-current 2>/dev/null || echo "N/A")

## Métricas del Sistema

EOF

    # Métricas del sistema
    echo "### Información del Sistema" >> "$report_file"
    echo "" >> "$report_file"
    echo "- **OS:** $(uname -s)" >> "$report_file"
    echo "- **Architecture:** $(uname -m)" >> "$report_file"
    echo "- **Node.js:** $(node --version)" >> "$report_file"
    echo "- **npm:** $(npm --version)" >> "$report_file"
    echo "" >> "$report_file"

    # Métricas de memoria
    echo "### Uso de Memoria" >> "$report_file"
    echo "" >> "$report_file"
    if command -v free &> /dev/null; then
        echo '```' >> "$report_file"
        free -h >> "$report_file" 2>/dev/null || echo "No disponible" >> "$report_file"
        echo '```' >> "$report_file"
    else
        echo "Información de memoria no disponible" >> "$report_file"
    fi
    echo "" >> "$report_file"

    # Análisis de bundle
    echo "### Análisis de Bundle" >> "$report_file"
    echo "" >> "$report_file"

    if [ -d "$PROJECT_ROOT/.next" ]; then
        local bundle_size=$(du -sh "$PROJECT_ROOT/.next" 2>/dev/null | cut -f1 || echo "N/A")
        echo "- **Tamaño total del build:** $bundle_size" >> "$report_file"

        # Contar archivos JavaScript
        local js_count=$(find "$PROJECT_ROOT/.next" -name "*.js" 2>/dev/null | wc -l)
        echo "- **Archivos JavaScript:** $js_count" >> "$report_file"

        # Archivos más grandes
        echo "" >> "$report_file"
        echo "**Archivos más grandes:**" >> "$report_file"
        echo "" >> "$report_file"
        find "$PROJECT_ROOT/.next" -name "*.js" -exec ls -lh {} + 2>/dev/null | sort -k5 -hr | head -5 | while read line; do
            local size=$(echo "$line" | awk '{print $5}')
            local file=$(echo "$line" | awk '{print $9}' | sed "s|$PROJECT_ROOT/||")
            echo "- $size - $file" >> "$report_file"
        done
    else
        echo "Build no encontrado - ejecutar 'npm run build' primero" >> "$report_file"
    fi

    echo "" >> "$report_file"

    # Dependencias
    echo "### Análisis de Dependencias" >> "$report_file"
    echo "" >> "$report_file"

    if [ -f "$PROJECT_ROOT/package.json" ]; then
        local deps_count=$(jq '.dependencies | length' "$PROJECT_ROOT/package.json" 2>/dev/null || echo "N/A")
        local dev_deps_count=$(jq '.devDependencies | length' "$PROJECT_ROOT/package.json" 2>/dev/null || echo "N/A")

        echo "- **Dependencias de producción:** $deps_count" >> "$report_file"
        echo "- **Dependencias de desarrollo:** $dev_deps_count" >> "$report_file"

        # node_modules size
        if [ -d "$PROJECT_ROOT/node_modules" ]; then
            local node_modules_size=$(du -sh "$PROJECT_ROOT/node_modules" 2>/dev/null | cut -f1 || echo "N/A")
            echo "- **Tamaño de node_modules:** $node_modules_size" >> "$report_file"
        fi
    fi

    echo "" >> "$report_file"

    # Métricas de código
    echo "### Métricas de Código" >> "$report_file"
    echo "" >> "$report_file"

    # Contar archivos TypeScript
    local ts_files=$(find "$PROJECT_ROOT/src" -name "*.ts" -o -name "*.tsx" 2>/dev/null | wc -l)
    local total_lines=$(find "$PROJECT_ROOT/src" -name "*.ts" -o -name "*.tsx" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")

    echo "- **Archivos TypeScript:** $ts_files" >> "$report_file"
    echo "- **Líneas de código:** $total_lines" >> "$report_file"

    # Archivos más grandes en src
    echo "" >> "$report_file"
    echo "**Archivos de código más grandes:**" >> "$report_file"
    echo "" >> "$report_file"
    find "$PROJECT_ROOT/src" -name "*.ts" -o -name "*.tsx" -exec wc -l {} + 2>/dev/null | sort -nr | head -5 | while read lines file; do
        local filename=$(echo "$file" | sed "s|$PROJECT_ROOT/||")
        echo "- $lines líneas - $filename" >> "$report_file"
    done

    echo "" >> "$report_file"

    # Recomendaciones
    echo "## Recomendaciones" >> "$report_file"
    echo "" >> "$report_file"

    # Analizar archivos grandes
    local large_files=$(find "$PROJECT_ROOT/src" -name "*.ts" -o -name "*.tsx" -exec wc -l {} + 2>/dev/null | awk '$1 > 150 {print $0}' | wc -l)
    if [ "$large_files" -gt 0 ]; then
        echo "- ⚠️  **$large_files archivos con más de 150 líneas** - Considerar refactorización" >> "$report_file"
    fi

    # Verificar node_modules size
    if [ -d "$PROJECT_ROOT/node_modules" ]; then
        local nm_size_mb=$(du -sm "$PROJECT_ROOT/node_modules" 2>/dev/null | cut -f1 || echo "0")
        if [ "$nm_size_mb" -gt 500 ]; then
            echo "- ⚠️  **node_modules grande (${nm_size_mb}MB)** - Revisar dependencias innecesarias" >> "$report_file"
        fi
    fi

    # Verificar build size
    if [ -d "$PROJECT_ROOT/.next" ]; then
        local build_size_mb=$(du -sm "$PROJECT_ROOT/.next" 2>/dev/null | cut -f1 || echo "0")
        if [ "$build_size_mb" -gt 50 ]; then
            echo "- ⚠️  **Build grande (${build_size_mb}MB)** - Optimizar bundle splitting" >> "$report_file"
        fi
    fi

    echo "- ✅ **Ejecutar análisis Lighthouse** - \`$0 lighthouse\`" >> "$report_file"
    echo "- ✅ **Monitorear métricas en tiempo real** - \`$0 watch\`" >> "$report_file"

    echo "" >> "$report_file"
    echo "---" >> "$report_file"
    echo "*Reporte generado automáticamente por Performance Manager*" >> "$report_file"

    echo -e "${GREEN}✅ Benchmark completado${NC}"
    echo -e "${BLUE}📄 Reporte guardado en: $report_file${NC}"

    # Mostrar resumen
    echo -e "${CYAN}📊 Resumen del Benchmark:${NC}"
    echo -e "  🏗️  Build size: $(du -sh "$PROJECT_ROOT/.next" 2>/dev/null | cut -f1 || echo "N/A")"
    echo -e "  📦 node_modules: $(du -sh "$PROJECT_ROOT/node_modules" 2>/dev/null | cut -f1 || echo "N/A")"
    echo -e "  📝 Archivos TS: $ts_files"
    echo -e "  📏 Líneas código: $total_lines"
}

# Función para benchmark rápido
performance_quick() {
    echo -e "${CYAN}⚡ Benchmark rápido...${NC}"

    # Métricas básicas
    echo -e "${YELLOW}📊 Métricas básicas:${NC}"

    # Tamaño de directorio src
    if [ -d "$PROJECT_ROOT/src" ]; then
        local src_size=$(du -sh "$PROJECT_ROOT/src" 2>/dev/null | cut -f1)
        echo -e "  📁 Código fuente: $src_size"
    fi

    # Archivos TypeScript
    local ts_files=$(find "$PROJECT_ROOT/src" -name "*.ts" -o -name "*.tsx" 2>/dev/null | wc -l)
    echo -e "  📝 Archivos TS: $ts_files"

    # Estado del build
    if [ -d "$PROJECT_ROOT/.next" ]; then
        local build_size=$(du -sh "$PROJECT_ROOT/.next" 2>/dev/null | cut -f1)
        echo -e "  🏗️  Build: $build_size"
    else
        echo -e "  🏗️  Build: No existe"
    fi

    # node_modules
    if [ -d "$PROJECT_ROOT/node_modules" ]; then
        local nm_size=$(du -sh "$PROJECT_ROOT/node_modules" 2>/dev/null | cut -f1)
        echo -e "  📦 Dependencies: $nm_size"
    else
        echo -e "  📦 Dependencies: No instaladas"
    fi

    echo -e "${GREEN}✅ Benchmark rápido completado${NC}"
}

# Función para análisis de bundle
performance_bundle() {
    echo -e "${CYAN}📦 Analizando bundle...${NC}"

    if [ ! -d "$PROJECT_ROOT/.next" ]; then
        echo -e "${YELLOW}🏗️  Build no encontrado, ejecutando build...${NC}"
        cd "$PROJECT_ROOT"
        npm run build
    fi

    echo -e "${YELLOW}📊 Análisis de bundle:${NC}"

    # Información general
    local build_size=$(du -sh "$PROJECT_ROOT/.next" 2>/dev/null | cut -f1)
    echo -e "  🏗️  Tamaño total: $build_size"

    # Contar archivos por tipo
    local js_files=$(find "$PROJECT_ROOT/.next" -name "*.js" 2>/dev/null | wc -l)
    local css_files=$(find "$PROJECT_ROOT/.next" -name "*.css" 2>/dev/null | wc -l)

    echo -e "  📄 Archivos JS: $js_files"
    echo -e "  🎨 Archivos CSS: $css_files"

    # Archivos más grandes
    echo -e "${YELLOW}📈 Archivos más grandes:${NC}"
    find "$PROJECT_ROOT/.next" -type f \( -name "*.js" -o -name "*.css" \) -exec ls -lh {} + 2>/dev/null | \
        sort -k5 -hr | head -5 | while read line; do
        local size=$(echo "$line" | awk '{print $5}')
        local file=$(basename "$(echo "$line" | awk '{print $9}')")
        echo -e "    $size - $file"
    done
}

# Función para generar reporte
performance_report() {
    local format="${2:-markdown}"
    local timestamp=$(get_timestamp)

    case "$format" in
        "html")
            local report_file="$REPORTS_DIR/performance-report-$timestamp.html"
            echo -e "${CYAN}📄 Generando reporte HTML...${NC}"
            # Aquí se podría implementar generación HTML
            echo -e "${YELLOW}⚠️  Formato HTML no implementado aún${NC}"
            ;;
        "json")
            local report_file="$REPORTS_DIR/performance-report-$timestamp.json"
            echo -e "${CYAN}📄 Generando reporte JSON...${NC}"
            # Aquí se podría implementar generación JSON
            echo -e "${YELLOW}⚠️  Formato JSON no implementado aún${NC}"
            ;;
        *)
            performance_benchmark "report"
            ;;
    esac
}

# Función para limpiar reportes antiguos
performance_clean() {
    echo -e "${CYAN}🧹 Limpiando reportes de performance...${NC}"

    if [ -d "$REPORTS_DIR" ]; then
        local report_count=$(find "$REPORTS_DIR" -name "*.md" -o -name "*.html" -o -name "*.json" 2>/dev/null | wc -l)

        if [ "$report_count" -gt 0 ]; then
            echo -e "${YELLOW}📊 Reportes encontrados: $report_count${NC}"
            echo -e "${RED}⚠️  ¿Eliminar todos los reportes? (y/N)${NC}"
            read -r response

            if [[ "$response" =~ ^[Yy]$ ]]; then
                rm -rf "$REPORTS_DIR"/*
                echo -e "${GREEN}✅ Reportes eliminados${NC}"
            else
                echo -e "${BLUE}❌ Limpieza cancelada${NC}"
            fi
        else
            echo -e "${BLUE}ℹ️  No hay reportes para limpiar${NC}"
        fi
    else
        echo -e "${BLUE}ℹ️  Directorio de reportes no existe${NC}"
    fi
}

# Función para watch
performance_watch() {
    echo -e "${CYAN}👁️  Monitor de performance en tiempo real...${NC}"
    echo -e "${YELLOW}💡 Presiona Ctrl+C para detener${NC}"

    while true; do
        clear
        echo -e "${CYAN}⚡ Performance Monitor - $(date '+%H:%M:%S')${NC}"
        echo "================================"

        # Métricas básicas
        performance_quick

        echo ""
        echo -e "${BLUE}🔄 Actualizando en 5 segundos...${NC}"
        sleep 5
    done
}

# Función principal
main() {
    check_dependencies

    case "${1:-help}" in
        "benchmark")
            performance_benchmark "${2:-full}"
            ;;
        "quick")
            performance_quick
            ;;
        "detailed")
            performance_benchmark "detailed"
            ;;
        "bundle")
            performance_bundle
            ;;
        "analyze")
            echo -e "${CYAN}📊 Analizando métricas...${NC}"
            performance_quick
            performance_bundle
            ;;
        "report")
            performance_report "$@"
            ;;
        "history")
            echo -e "${CYAN}📈 Historial de reportes:${NC}"
            if [ -d "$REPORTS_DIR" ]; then
                ls -la "$REPORTS_DIR" | grep -E '\.(md|html|json)$' || echo "No hay reportes"
            else
                echo "No hay reportes generados"
            fi
            ;;
        "clean")
            performance_clean
            ;;
        "watch")
            performance_watch
            ;;
        "setup")
            echo -e "${CYAN}⚙️  Configurando herramientas de performance...${NC}"
            ensure_reports_dir
            echo -e "${GREEN}✅ Directorio de reportes creado${NC}"
            echo -e "${BLUE}💡 Ejecuta '$0 benchmark' para generar tu primer reporte${NC}"
            ;;
        "lighthouse")
            echo -e "${CYAN}🏮 Lighthouse audit...${NC}"
            echo -e "${YELLOW}⚠️  Lighthouse audit no implementado aún${NC}"
            echo -e "${BLUE}💡 Usa Google Chrome DevTools o lighthouse-cli${NC}"
            ;;
        "memory")
            echo -e "${CYAN}🧠 Análisis de memoria...${NC}"
            if command -v free &> /dev/null; then
                free -h
            else
                echo -e "${YELLOW}⚠️  Comando 'free' no disponible en este sistema${NC}"
            fi
            ;;
        "profile")
            echo -e "${CYAN}🔍 Profiling de componentes...${NC}"
            echo -e "${YELLOW}⚠️  Profiling avanzado no implementado aún${NC}"
            echo -e "${BLUE}💡 Usa React DevTools Profiler en el navegador${NC}"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            if [ "$1" = "man" ]; then
                show_help
            else
                echo -e "${RED}❌ Error: Comando desconocido '$1'${NC}"
                echo ""
                show_help
                exit 1
            fi
            ;;
    esac
}

# Ejecutar función principal con todos los argumentos
main "$@"
