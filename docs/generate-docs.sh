#!/bin/bash
# 📚 Generador de documentación automática
# Crea un resumen del estado actual del proyecto

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuración
PROJECT_ROOT=$(pwd)
OUTPUT_FILE=".docs/docs/project/project-status.md"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

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

# Función para contar líneas de código
count_lines() {
    find src -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" | xargs wc -l | tail -1 | awk '{print $1}'
}

# Función para contar archivos por tipo
count_files() {
    local extension=$1
    find src -name "*.$extension" | wc -l
}

# Función para obtener información de dependencias
get_dependencies_info() {
    local total_deps=$(cat package.json | jq '.dependencies | length')
    local total_dev_deps=$(cat package.json | jq '.devDependencies | length')
    echo "$total_deps dependencias de producción, $total_dev_deps de desarrollo"
}

# Función para obtener información de Git
get_git_info() {
    if [ -d ".git" ]; then
        local current_branch=$(git branch --show-current)
        local last_commit=$(git log --oneline -1 | cut -d' ' -f2-)
        local commits_count=$(git rev-list --count HEAD)
        echo "Rama: $current_branch | Commits: $commits_count | Último: $last_commit"
    else
        echo "No es un repositorio Git"
    fi
}

# Función para obtener información de la base de datos
get_db_info() {
    if [ -f "prisma/schema.prisma" ]; then
        local models_count=$(grep -c "^model " prisma/schema.prisma || echo "0")
        local migrations_count=$(find prisma/migrations -name "*.sql" 2>/dev/null | wc -l || echo "0")
        echo "$models_count modelos, $migrations_count migraciones"
    else
        echo "Sin Prisma schema"
    fi
}

# Función para analizar estructura de componentes
analyze_components() {
    echo "### 🧩 Análisis de Componentes"
    echo ""

    if [ -d "src/components" ]; then
        local total_components=$(find src/components -name "*.tsx" | wc -l)
        echo "- **Total de componentes**: $total_components"

        # Componentes por carpeta
        echo "- **Distribución por carpeta**:"
        for dir in src/components/*/; do
            if [ -d "$dir" ]; then
                local dir_name=$(basename "$dir")
                local count=$(find "$dir" -name "*.tsx" | wc -l)
                echo "  - $dir_name: $count componentes"
            fi
        done

        # Componentes más grandes
        echo "- **Componentes más grandes** (por líneas):"
        find src/components -name "*.tsx" -exec wc -l {} + | sort -rn | head -5 | while read lines file; do
            local basename=$(basename "$file" .tsx)
            echo "  - $basename: $lines líneas"
        done
    else
        echo "- Sin carpeta de componentes"
    fi
    echo ""
}

# Función para analizar hooks
analyze_hooks() {
    echo "### 🪝 Análisis de Hooks"
    echo ""

    if [ -d "src/hooks" ]; then
        local total_hooks=$(find src/hooks -name "*.ts" | wc -l)
        echo "- **Total de hooks**: $total_hooks"

        # Hooks por carpeta
        echo "- **Distribución por carpeta**:"
        for dir in src/hooks/*/; do
            if [ -d "$dir" ]; then
                local dir_name=$(basename "$dir")
                local count=$(find "$dir" -name "*.ts" | wc -l)
                echo "  - $dir_name: $count hooks"
            fi
        done

        # Hooks en raíz
        local root_hooks=$(find src/hooks -maxdepth 1 -name "*.ts" | wc -l)
        if [ "$root_hooks" -gt 0 ]; then
            echo "  - raíz: $root_hooks hooks"
        fi
    else
        echo "- Sin carpeta de hooks"
    fi
    echo ""
}

# Función para analizar API
analyze_api() {
    echo "### 🔌 Análisis de API"
    echo ""

    if [ -d "src/app/api" ]; then
        local total_endpoints=$(find src/app/api -name "route.ts" | wc -l)
        echo "- **Total de endpoints**: $total_endpoints"

        # Endpoints por carpeta
        echo "- **Endpoints disponibles**:"
        find src/app/api -name "route.ts" | while read file; do
            local dir_path=$(dirname "$file" | sed 's|src/app/api/||')
            echo "  - /$dir_path"
        done
    else
        echo "- Sin endpoints API"
    fi
    echo ""
}

# Función para obtener información de scripts npm
get_npm_scripts() {
    echo "### 📦 Scripts NPM Disponibles"
    echo ""

    # Scripts de desarrollo
    echo "#### 🚀 Desarrollo"
    echo "- \`npm run dev\` - Servidor de desarrollo"
    echo "- \`npm run build\` - Build de producción"
    echo "- \`npm run start\` - Servidor de producción"
    echo "- \`npm run setup\` - Setup inicial para nuevos desarrolladores"
    echo ""

    # Scripts de calidad
    echo "#### 🔍 Calidad de Código"
    echo "- \`npm run verify\` - Verificación completa (fix + type-check + build)"
    echo "- \`npm run fix\` - Arreglar formato y lint automáticamente"
    echo "- \`npm run type-check\` - Verificación de tipos TypeScript"
    echo "- \`npm run lint\` - Verificar código con ESLint"
    echo "- \`npm run format\` - Formatear código con Prettier"
    echo ""

    # Scripts de base de datos
    echo "#### 🗃️ Base de Datos"
    echo "- \`npm run db:migrate\` - Crear y aplicar migración"
    echo "- \`npm run db:studio\` - Abrir Prisma Studio"
    echo "- \`npm run db:seed\` - Poblar con datos de ejemplo"
    echo "- \`npm run db:reset\` - Reset completo de la BD"
    echo ""

    # Scripts de Git workflow
    echo "#### 🔄 Git Workflow"
    echo "- \`npm run new:feature\` - Crear nueva rama de feature"
    echo "- \`npm run merge:develop\` - Mergear rama actual a develop"
    echo "- \`npm run git:save\` - Commit rápido con mensaje"
    echo "- \`npm run git:sync\` - Sincronizar rama con origin"
    echo "- \`npm run git:status\` - Estado completo del repositorio"
    echo "- \`npm run git:clean\` - Limpiar ramas mergeadas"
    echo "- \`npm run git:workflow\` - Ayuda de comandos Git"
    echo ""
}

# Función para generar el reporte completo
generate_report() {
    log "STEP" "Generando reporte de estado del proyecto..."

    # Crear directorio si no existe
    mkdir -p "$(dirname "$OUTPUT_FILE")"

    # Generar contenido
    cat > "$OUTPUT_FILE" << EOF
# 📊 Estado del Proyecto - NextJS Calendar App

> **Generado automáticamente**: $TIMESTAMP
> **Versión**: $(cat package.json | jq -r '.version')

## 📈 Resumen Ejecutivo

### 🎯 Información General
- **Proyecto**: $(cat package.json | jq -r '.name')
- **Versión**: $(cat package.json | jq -r '.version')
- **Líneas de código**: $(count_lines) líneas
- **Dependencias**: $(get_dependencies_info)
- **Git**: $(get_git_info)
- **Base de datos**: $(get_db_info)

### 📁 Distribución de Archivos
- **TypeScript**: $(count_files "ts") archivos
- **React Components**: $(count_files "tsx") componentes
- **Estilos CSS**: $(count_files "css") archivos
- **Configuración**: $(find . -maxdepth 1 -name "*.config.*" -o -name "*.json" -o -name "*.js" -o -name "*.mjs" | wc -l) archivos

$(analyze_components)

$(analyze_hooks)

$(analyze_api)

### 🛠️ Stack Tecnológico Actual

#### Frontend
- **Framework**: Next.js 15.4.5 (App Router)
- **React**: 19.1.0
- **TypeScript**: Configurado con verificación estricta
- **Estilos**: TailwindCSS 4.1.11
- **UI Components**: Radix UI
- **Iconos**: Lucide React

#### Backend & Base de Datos
- **ORM**: Prisma 6.13.0
- **Base de datos**: SQLite (desarrollo)
- **Validación**: Zod 3.25.76

#### Herramientas de Desarrollo
- **Linting**: ESLint + TypeScript ESLint
- **Formato**: Prettier
- **Git Hooks**: Husky + lint-staged
- **Build**: Next.js built-in

### 🔄 Arquitectura Actual

#### Patrones Implementados
- ✅ **Error Boundaries**: Sistema completo con SimpleErrorBoundary
- ✅ **Custom Hooks**: Separación de lógica de negocio
- ✅ **Validación Zod**: Validación tipo-segura en toda la app
- ✅ **API Type-Safe**: Cliente API con validación automática
- ✅ **Component Composition**: Componentes modulares con Radix UI

#### Estructura de Datos
- ✅ **Events**: Gestión completa de eventos con tipos personalizados
- ✅ **Event Types**: Sistema de categorización
- ✅ **Calendar**: Vista mensual con navegación
- ✅ **Forms**: Validación y manejo de formularios

$(get_npm_scripts)

### 🎯 Estado de Funcionalidades

#### ✅ Completadas
- [x] Calendario mensual con navegación
- [x] Gestión completa de eventos (CRUD)
- [x] Tipos de eventos personalizables
- [x] Validación tipo-segura con Zod
- [x] Error Boundaries sistema completo
- [x] API endpoints RESTful
- [x] Interfaz responsive con TailwindCSS
- [x] Base de datos con Prisma + SQLite
- [x] Git workflow automation

#### 🔄 En Progreso
- [ ] Tests unitarios y de integración
- [ ] Deployment automation
- [ ] Performance optimizations

#### 📋 Pendientes
- [ ] Autenticación y autorización
- [ ] Notificaciones push
- [ ] Exportación de eventos
- [ ] Vista semanal y diaria
- [ ] Eventos recurrentes

### 🚀 Comandos de Desarrollo Rápido

\`\`\`bash
# Setup inicial (nuevos desarrolladores)
npm run setup

# Desarrollo diario
npm run dev
npm run db:studio

# Workflow Git
npm run new:feature
npm run git:save "mensaje del commit"
npm run merge:develop

# Verificación de calidad
npm run verify
\`\`\`

### 📚 Documentación Disponible

#### Estructura de Documentación
\`\`\`
.docs/
├── docs/
│   ├── api/               # Documentación de API
│   ├── components/        # Documentación de componentes
│   ├── hooks/             # Documentación de hooks
│   ├── project/           # Documentación del proyecto
│   └── architecture.md   # Arquitectura técnica
├── blog/                  # Posts y actualizaciones
└── src/                   # Componentes personalizados
\`\`\`

#### Documentos Principales
- [README.md](../README.md) - Documentación principal del proyecto
- [Arquitectura](.docs/docs/architecture.md) - Arquitectura técnica detallada
- [API Reference](.docs/docs/api/) - Documentación de endpoints
- [Componentes](.docs/docs/components/) - Guías de componentes
- [Hooks](.docs/docs/hooks/) - Documentación de hooks personalizados

---

**Última actualización**: $TIMESTAMP
**Generado por**: scripts/generate-docs.sh
EOF

    log "SUCCESS" "Reporte generado en $OUTPUT_FILE"
}

# Función principal
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════════════╗"
    echo "║                    📚 GENERADOR DE DOCUMENTACIÓN                    ║"
    echo "╚══════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""

    generate_report

    echo ""
    echo -e "${GREEN}✅ Documentación generada exitosamente${NC}"
    echo -e "${CYAN}📄 Archivo: $OUTPUT_FILE${NC}"
    echo ""
    echo -e "${YELLOW}💡 Para ver el reporte:${NC}"
    echo "   cat $OUTPUT_FILE"
    echo "   code $OUTPUT_FILE"
    echo ""
}

main "$@"
