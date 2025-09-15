#!/bin/bash
# 🏃‍♂️ Script de benchmark de performance del calendario
# Automatiza las pruebas de performance antes y después de optimizaciones

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%H:%M:%S')

    case $level in
        "INFO") echo -e "${CYAN}[INFO ${timestamp}]${NC} $message" ;;
        "SUCCESS") echo -e "${GREEN}[SUCCESS ${timestamp}]${NC} $message" ;;
        "WARNING") echo -e "${YELLOW}[WARNING ${timestamp}]${NC} $message" ;;
        "ERROR") echo -e "${RED}[ERROR ${timestamp}]${NC} $message" ;;
        "STEP") echo -e "${PURPLE}[STEP ${timestamp}]${NC} $message" ;;
    esac
}

show_help() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║            🏃‍♂️ PERFORMANCE BENCHMARK        ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo "Uso: $0 <comando>"
    echo ""
    echo "Comandos disponibles:"
    echo ""
    echo -e "${GREEN}📊 Benchmark:${NC}"
    echo "  start             - Iniciar servidor con benchmark habilitado"
    echo "  test              - Ejecutar test automatizado de performance"
    echo "  lighthouse        - Ejecutar Lighthouse audit"
    echo ""
    echo -e "${GREEN}🔧 Configuración:${NC}"
    echo "  enable            - Habilitar benchmark persistente"
    echo "  disable           - Deshabilitar benchmark"
    echo "  status            - Ver estado actual"
    echo ""
    echo -e "${GREEN}📈 Análisis:${NC}"
    echo "  report            - Generar reporte de performance"
    echo "  compare           - Comparar métricas antes/después"
    echo ""
    echo "Ejemplos:"
    echo "  $0 start          # Servidor con benchmark"
    echo "  $0 test           # Test automatizado"
    echo "  $0 report         # Reporte completo"
}

start_benchmark_server() {
    log "STEP" "Iniciando servidor con benchmark habilitado..."

    # Habilitar benchmark
    export NEXT_PUBLIC_BENCHMARK=true

    # Mensaje informativo
    echo ""
    log "INFO" "Servidor iniciado con benchmark de performance"
    log "INFO" "URL: http://localhost:3000?benchmark=true"
    echo ""
    echo -e "${YELLOW}📊 Para medir performance:${NC}"
    echo "1. Abrir http://localhost:3000?benchmark=true"
    echo "2. Abrir DevTools → Console"
    echo "3. Navegar por el calendario"
    echo "4. Ver métricas en consola cada 10 renders"
    echo ""
    echo -e "${YELLOW}🎯 Métricas a observar:${NC}"
    echo "• Tiempo promedio de render (< 16ms ideal)"
    echo "• Número total de renders"
    echo "• Re-renders innecesarios"
    echo ""

    # Iniciar servidor
    npm run dev
}

run_automated_test() {
    log "STEP" "Ejecutando test automatizado de performance..."

    # Verificar que el servidor esté corriendo
    if ! curl -s http://localhost:3000 > /dev/null; then
        log "ERROR" "Servidor no está corriendo. Ejecuta: npm run dev"
        exit 1
    fi

    log "INFO" "Creando script de test con Playwright..."

    # Crear test temporal
    cat > performance_test.js << 'EOF'
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  // Habilitar métricas de performance
  await page.goto('http://localhost:3000?benchmark=true');

  console.log('🚀 Iniciando test de performance...');

  // Capturar métricas de timing
  const navigationPromise = page.waitForLoadState('networkidle');
  await navigationPromise;

  // Simular navegación por el calendario
  console.log('📅 Navegando por el calendario...');

  // Cambiar mes varias veces
  for (let i = 0; i < 5; i++) {
    await page.click('button[aria-label*="siguiente"]');
    await page.waitForTimeout(500);
  }

  // Cambiar año
  await page.click('select'); // Si existe selector de año
  await page.waitForTimeout(500);

  // Hacer click en varios días
  const days = await page.$$('.calendar-day'); // Ajustar selector
  for (let i = 0; i < Math.min(days.length, 10); i++) {
    await days[i].click();
    await page.waitForTimeout(200);
  }

  // Capturar métricas finales
  const metrics = await page.evaluate(() => {
    return performance.getEntriesByType('navigation')[0];
  });

  console.log('📊 Métricas de navegación:');
  console.log(`• Load Complete: ${metrics.loadEventEnd - metrics.navigationStart}ms`);
  console.log(`• DOM Content Loaded: ${metrics.domContentLoadedEventEnd - metrics.navigationStart}ms`);
  console.log(`• First Paint: ${metrics.responseEnd - metrics.navigationStart}ms`);

  await browser.close();
  console.log('✅ Test completado');
})();
EOF

    # Ejecutar test si playwright está disponible
    if command -v npx > /dev/null && npx playwright --version > /dev/null 2>&1; then
        log "INFO" "Ejecutando con Playwright..."
        npx playwright install chromium > /dev/null 2>&1 || true
        node performance_test.js
    else
        log "WARNING" "Playwright no disponible. Para instalar:"
        echo "npm install -D playwright"
        echo "npx playwright install"
    fi

    # Limpiar
    rm -f performance_test.js
}

run_lighthouse_audit() {
    log "STEP" "Ejecutando audit con Lighthouse..."

    # Verificar servidor
    if ! curl -s http://localhost:3000 > /dev/null; then
        log "ERROR" "Servidor no está corriendo. Ejecuta: npm run dev"
        exit 1
    fi

    if command -v lighthouse > /dev/null; then
        log "INFO" "Ejecutando Lighthouse audit..."
        lighthouse http://localhost:3000 \
            --output=html \
            --output-path=./lighthouse-report.html \
            --chrome-flags="--headless" \
            --only-categories=performance

        log "SUCCESS" "Reporte generado: lighthouse-report.html"
    else
        log "WARNING" "Lighthouse no disponible. Para instalar:"
        echo "npm install -g lighthouse"
    fi
}

enable_benchmark() {
    log "STEP" "Habilitando benchmark persistente..."
    echo "true" > .benchmark_enabled
    log "SUCCESS" "Benchmark habilitado persistentemente"
    log "INFO" "URL: http://localhost:3000?benchmark=true"
}

disable_benchmark() {
    log "STEP" "Deshabilitando benchmark..."
    rm -f .benchmark_enabled
    log "SUCCESS" "Benchmark deshabilitado"
}

show_status() {
    echo -e "${BLUE}📊 Estado del Benchmark de Performance${NC}"
    echo ""

    if [ -f ".benchmark_enabled" ]; then
        echo -e "${GREEN}✅ Benchmark: HABILITADO${NC}"
    else
        echo -e "${YELLOW}⏸️  Benchmark: DESHABILITADO${NC}"
    fi

    echo ""
    echo -e "${CYAN}🔧 Configuración:${NC}"
    echo "• URL con benchmark: http://localhost:3000?benchmark=true"
    echo "• Métricas en consola cada 10 renders"
    echo ""

    echo -e "${CYAN}🎯 Optimizaciones implementadas:${NC}"
    echo "• ✅ React.memo en CalendarDay"
    echo "• ✅ React.memo en CalendarGrid"
    echo "• ✅ React.memo en EventIndicator"
    echo "• ✅ useMemo para props computadas"
    echo "• ✅ useCallback para event handlers"
    echo "• ✅ Keys optimizadas en listas"
    echo "• ✅ Memoización de funciones de verificación"
    echo ""
}

generate_report() {
    log "STEP" "Generando reporte de performance..."

    local report_file="performance-report-$(date '+%Y%m%d-%H%M%S').md"

    cat > "$report_file" << EOF
# 📊 Reporte de Performance - Calendario

> **Fecha**: $(date '+%Y-%m-%d %H:%M:%S')
> **Optimizaciones**: React.memo + useMemo + useCallback

## 🎯 Optimizaciones Implementadas

### ✅ React.memo
- **CalendarDay**: Memoización con comparación personalizada de props
- **CalendarGrid**: Memoización con lógica de comparación optimizada
- **EventIndicator**: Memoización para evitar re-renders de indicadores

### ✅ useMemo
- **eventsByType**: Agrupamiento de eventos memoizado
- **backgroundClasses**: Clases CSS computadas memoizadas
- **textClasses**: Clases de texto memoizadas
- **processedDays**: Lista de días procesada memoizada

### ✅ useCallback
- **handleClick**: Handler de click memoizado
- **isToday**: Función de verificación memoizada
- **isWeekend**: Función de verificación memoizada

### ✅ Keys Optimizadas
- **Unique keys**: \`\${year}-\${month}-\${day || \`empty-\${index}\`}\`
- **Stable keys**: Incluyen año/mes para evitar problemas de reconciliación

## 🔧 Herramientas de Benchmark

### 📈 Performance Hooks
- **usePerformanceBenchmark**: Medición automática de renders
- **usePerformanceToggle**: Control de benchmark desde UI/localStorage

### 🎛️ UI Tools
- **PerformanceMetricsDisplay**: Widget visual para métricas
- **Habilitación**: \`?benchmark=true\` o localStorage

## 📊 Métricas a Monitorear

### 🎯 Targets de Performance
- **Render time**: < 16ms por componente
- **Re-renders**: Minimizar re-renders innecesarios
- **Memory**: Evitar memory leaks en hooks

### 📈 Cómo Medir
1. Abrir: http://localhost:3000?benchmark=true
2. DevTools → Console
3. Navegar por calendario
4. Observar logs cada 10 renders

## 🚀 Comandos de Benchmark

\`\`\`bash
# Servidor con benchmark
./scripts/performance-benchmark.sh start

# Test automatizado
./scripts/performance-benchmark.sh test

# Lighthouse audit
./scripts/performance-benchmark.sh lighthouse

# Este reporte
./scripts/performance-benchmark.sh report
\`\`\`

## 📋 Checklist de Optimización

- [x] Implementar React.memo en componentes clave
- [x] Memoizar props computadas con useMemo
- [x] Memoizar event handlers con useCallback
- [x] Optimizar keys en listas dinámicas
- [x] Crear herramientas de benchmark
- [x] Integrar métricas en desarrollo
- [ ] Tests automatizados de performance
- [ ] Métricas en CI/CD
- [ ] Bundle size optimization

---

**Generado por**: scripts/performance-benchmark.sh
EOF

    log "SUCCESS" "Reporte generado: $report_file"
    echo ""
    echo -e "${CYAN}📄 Para ver el reporte:${NC}"
    echo "code $report_file"
    echo "cat $report_file"
}

compare_metrics() {
    log "STEP" "Función de comparación de métricas..."
    echo ""
    echo -e "${YELLOW}📊 Para comparar métricas antes/después:${NC}"
    echo ""
    echo "1. **Antes de optimizaciones**:"
    echo "   - Deshabilitar React.memo temporalmente"
    echo "   - Ejecutar: $0 start"
    echo "   - Navegar y anotar métricas"
    echo ""
    echo "2. **Después de optimizaciones**:"
    echo "   - Habilitar todas las optimizaciones"
    echo "   - Ejecutar: $0 start"
    echo "   - Navegar con los mismos patrones"
    echo "   - Comparar métricas en consola"
    echo ""
    echo -e "${CYAN}🎯 Métricas clave a comparar:${NC}"
    echo "• Tiempo promedio de render"
    echo "• Número total de renders"
    echo "• Renders por navegación"
    echo "• Tiempo de respuesta de UI"
}

# Función principal
main() {
    if [ $# -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_help
        exit 0
    fi

    local command="$1"

    case $command in
        "start")
            start_benchmark_server
            ;;
        "test")
            run_automated_test
            ;;
        "lighthouse")
            run_lighthouse_audit
            ;;
        "enable")
            enable_benchmark
            ;;
        "disable")
            disable_benchmark
            ;;
        "status")
            show_status
            ;;
        "report")
            generate_report
            ;;
        "compare")
            compare_metrics
            ;;
        *)
            log "ERROR" "Comando desconocido: $command"
            echo "Usa '$0 --help' para ver comandos disponibles"
            exit 1
            ;;
    esac
}

main "$@"
