#!/bin/bash

# 📚 Docs Manager - Gestión centralizada de documentación
# Administra todos los flujos de trabajo de Docusaurus y documentación

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
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_DIR="$PROJECT_ROOT/.docs"
BUILD_DIR="$DOCS_DIR/build"
DOCUSAURUS_BUILD_DIR="$PROJECT_ROOT/public/docusaurus"
DOCS_SCRIPTS_DIR="$PROJECT_ROOT/scripts/docs"

# Función para mostrar ayuda
show_help() {
    echo -e "${CYAN}📚 Docs Manager - Gestión de Documentación${NC}"
    echo -e "${BLUE}Uso: $0 [COMANDO] [OPCIONES]${NC}"
    echo ""
    echo -e "${MAGENTA}📋 COMANDOS DISPONIBLES:${NC}"
    echo ""
    echo -e "${GREEN}🔄 Desarrollo:${NC}"
    echo -e "  ${YELLOW}dev${NC}            Servidor de desarrollo con live reload"
    echo -e "  ${YELLOW}start${NC}          Servir build estático en localhost:8080"
    echo -e "  ${YELLOW}create${NC}         Crear nuevo documento o blog post"
    echo -e "  ${YELLOW}validate${NC}       Validar estructura y enlaces"
    echo ""
    echo -e "${GREEN}🏗️  Build:${NC}"
    echo -e "  ${YELLOW}build${NC}          Build para producción → public/docusaurus"
    echo -e "  ${YELLOW}build:github${NC}   Build optimizado para GitHub Pages"
    echo -e "  ${YELLOW}build:clean${NC}    Limpiar builds anteriores y rebuildir"
    echo -e "  ${YELLOW}deploy${NC}         Deploy a GitHub Pages"
    echo ""
    echo -e "${GREEN}📊 Análisis:${NC}"
    echo -e "  ${YELLOW}status${NC}         Estado de la documentación"
    echo -e "  ${YELLOW}stats${NC}          Estadísticas de documentos"
    echo -e "  ${YELLOW}broken${NC}         Buscar enlaces rotos"
    echo -e "  ${YELLOW}outdated${NC}       Encontrar documentos desactualizados"
    echo ""
    echo -e "${GREEN}🔧 Utilidades:${NC}"
    echo -e "  ${YELLOW}setup${NC}          Configurar entorno de Docusaurus"
    echo -e "  ${YELLOW}clean${NC}          Limpiar caches y builds"
    echo -e "  ${YELLOW}update${NC}         Actualizar dependencias de Docusaurus"
    echo -e "  ${YELLOW}backup${NC}         Respaldar documentación"
    echo ""
    echo -e "${BLUE}📖 EJEMPLOS:${NC}"
    echo -e "  ${CYAN}$0 dev${NC}                    # Desarrollo con live reload"
    echo -e "  ${CYAN}$0 build${NC}                  # Build local con copia"
    echo -e "  ${CYAN}$0 create doc api/eventos${NC} # Crear documento API"
    echo -e "  ${CYAN}$0 create blog new-feature${NC} # Crear blog post"
    echo -e "  ${CYAN}$0 stats${NC}                  # Ver estadísticas"
    echo ""
    echo -e "${YELLOW}💡 TIP: Usa '$0 status' para ver el estado antes de hacer builds${NC}"
}

# Función para verificar dependencias
check_dependencies() {
    if [ ! -d "$DOCS_DIR" ]; then
        echo -e "${RED}❌ Error: Directorio de documentación no encontrado: $DOCS_DIR${NC}"
        echo -e "${BLUE}💡 Ejecuta '$0 setup' para configurar Docusaurus${NC}"
        exit 1
    fi

    if [ ! -f "$DOCS_DIR/package.json" ]; then
        echo -e "${RED}❌ Error: package.json de Docusaurus no encontrado${NC}"
        echo -e "${BLUE}💡 Ejecuta '$0 setup' para configurar Docusaurus${NC}"
        exit 1
    fi
}

# Función para servidor de desarrollo
docs_dev() {
    echo -e "${CYAN}🚀 Iniciando servidor de desarrollo Docusaurus...${NC}"
    check_dependencies

    cd "$DOCS_DIR"

    # Verificar que las dependencias estén instaladas
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}📦 Instalando dependencias...${NC}"
        npm install
    fi

    echo -e "${GREEN}🌐 Servidor disponible en: http://localhost:3001${NC}"
    echo -e "${YELLOW}💡 Presiona Ctrl+C para detener${NC}"

    npm run start -- --port 3001 --host 0.0.0.0
}

# Función para servir build
docs_start() {
    echo -e "${CYAN}🌐 Sirviendo build estático...${NC}"

    if [ ! -d "$DOCUSAURUS_BUILD_DIR" ]; then
        echo -e "${YELLOW}⚠️  Build no encontrado, creando...${NC}"
        docs_build
    fi

    cd "$DOCUSAURUS_BUILD_DIR"

    # Usar Python para servir archivos estáticos
    if command -v python3 &> /dev/null; then
        echo -e "${GREEN}🌐 Servidor disponible en: http://localhost:8080${NC}"
        echo -e "${YELLOW}💡 Presiona Ctrl+C para detener${NC}"
        python3 -m http.server 8080
    elif command -v python &> /dev/null; then
        echo -e "${GREEN}🌐 Servidor disponible en: http://localhost:8080${NC}"
        echo -e "${YELLOW}💡 Presiona Ctrl+C para detener${NC}"
        python -m SimpleHTTPServer 8080
    else
        echo -e "${RED}❌ Error: Python no encontrado para servir archivos${NC}"
        echo -e "${BLUE}💡 Instala Python o usa un servidor web diferente${NC}"
        exit 1
    fi
}

# Función para build
docs_build() {
    local build_type="${1:-local}"

    echo -e "${CYAN}🏗️  Construyendo documentación...${NC}"
    check_dependencies

    # Eliminar builds anteriores ANTES de construir
    echo -e "${YELLOW}🧹 Limpiando builds anteriores...${NC}"

    # Limpiar build de Docusaurus
    if [ -d "$BUILD_DIR" ]; then
        echo -e "  �️  Eliminando build anterior: $BUILD_DIR"
        rm -rf "$BUILD_DIR"
    fi

    # Limpiar directorio de destino
    if [ -d "$DOCUSAURUS_BUILD_DIR" ]; then
        echo -e "  🗑️  Eliminando build anterior: $DOCUSAURUS_BUILD_DIR"
        rm -rf "$DOCUSAURUS_BUILD_DIR"
    fi

    cd "$DOCS_DIR"

    # Verificar dependencias
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}📦 Instalando dependencias...${NC}"
        npm install
    fi

    # Build según tipo
    case "$build_type" in
        "github")
            echo -e "${YELLOW}🏗️  Build para GitHub Pages...${NC}"
            npm run build
            ;;
        "clean")
            echo -e "${YELLOW}🧹 Limpiando caches y rebuilding...${NC}"
            if command -v npm run clear &> /dev/null; then
                npm run clear
            fi
            npm run build
            ;;
        *)
            echo -e "${YELLOW}🏗️  Build local...${NC}"
            npm run build
            ;;
    esac

    # Verificar que el build se creó correctamente
    if [ -d "build" ]; then
        echo -e "${GREEN}✅ Build de Docusaurus completado${NC}"
        echo -e "${BLUE}📍 Build temporal en: $BUILD_DIR${NC}"

        # Mover build a public/docusaurus (no copiar)
        echo -e "${YELLOW}📁 Moviendo build a directorio público...${NC}"

        # Crear directorio padre si no existe
        mkdir -p "$(dirname "$DOCUSAURUS_BUILD_DIR")"

        # Mover build completo
        mv build "$DOCUSAURUS_BUILD_DIR"

        echo -e "${GREEN}✅ Build movido exitosamente a: $DOCUSAURUS_BUILD_DIR${NC}"
        echo -e "${BLUE}🌐 Para servir: $0 start${NC}"
    else
        echo -e "${RED}❌ Error: Build falló - directorio build no encontrado${NC}"
        exit 1
    fi
}

# Función para crear documentos
docs_create() {
    local type="$1"
    local name="$2"

    if [ -z "$type" ] || [ -z "$name" ]; then
        echo -e "${RED}❌ Error: Especifica tipo y nombre${NC}"
        echo -e "${BLUE}Uso: $0 create [doc|blog] <nombre>${NC}"
        echo -e "${BLUE}Ejemplos:${NC}"
        echo -e "  $0 create doc api/eventos"
        echo -e "  $0 create blog nueva-funcionalidad"
        return 1
    fi

    check_dependencies

    case "$type" in
        "doc"|"docs")
            local doc_path="$DOCS_DIR/docs/$name.md"
            local doc_dir=$(dirname "$doc_path")

            # Crear directorio si no existe
            mkdir -p "$doc_dir"

            # Crear documento base
            cat > "$doc_path" << EOF
---
sidebar_position: 1
title: $(basename "$name" | tr '-' ' ' | sed 's/\b\w/\u&/g')
---

# $(basename "$name" | tr '-' ' ' | sed 's/\b\w/\u&/g')

## Descripción

[Descripción del documento]

## Contenido

### Sección 1

[Contenido de la sección]

### Sección 2

[Contenido de la sección]

## Recursos Adicionales

- [Enlace relacionado](#)
- [Documentación oficial](#)
EOF

            echo -e "${GREEN}✅ Documento creado: $doc_path${NC}"
            ;;

        "blog")
            local date=$(date '+%Y-%m-%d')
            local blog_path="$DOCS_DIR/blog/$date-$name.md"

            # Crear directorio blog si no existe
            mkdir -p "$DOCS_DIR/blog"

            # Crear blog post
            cat > "$blog_path" << EOF
---
slug: $name
title: $(echo "$name" | tr '-' ' ' | sed 's/\b\w/\u&/g')
authors: [dev-team]
tags: [desarrollo, feature]
---

# $(echo "$name" | tr '-' ' ' | sed 's/\b\w/\u&/g')

## Resumen

[Resumen del post]

<!--truncate-->

## Detalles

[Contenido detallado del post]

### Cambios Importantes

- [Cambio 1]
- [Cambio 2]

### Próximos Pasos

- [Paso 1]
- [Paso 2]
EOF

            echo -e "${GREEN}✅ Blog post creado: $blog_path${NC}"
            ;;

        *)
            echo -e "${RED}❌ Error: Tipo inválido '$type'${NC}"
            echo -e "${BLUE}Tipos válidos: doc, blog${NC}"
            return 1
            ;;
    esac
}

# Función para mostrar estado
docs_status() {
    echo -e "${CYAN}📊 Estado de la Documentación${NC}"
    echo "=================================="

    # Verificar estructura
    if [ -d "$DOCS_DIR" ]; then
        echo -e "${GREEN}✅ Directorio de documentación existe${NC}"

        # Contar documentos
        local doc_count=$(find "$DOCS_DIR/docs" -name "*.md" 2>/dev/null | wc -l)
        local blog_count=$(find "$DOCS_DIR/blog" -name "*.md" 2>/dev/null | wc -l)

        echo -e "${YELLOW}📄 Documentos:${NC} $doc_count"
        echo -e "${YELLOW}📝 Blog posts:${NC} $blog_count"

        # Estado del build
        if [ -d "$DOCUSAURUS_BUILD_DIR" ]; then
            local build_date=$(stat -c %y "$DOCUSAURUS_BUILD_DIR" 2>/dev/null | cut -d' ' -f1)
            local build_size=$(du -sh "$DOCUSAURUS_BUILD_DIR" 2>/dev/null | cut -f1)
            echo -e "${GREEN}✅ Build público existe${NC} (${build_size}, modificado: $build_date)"
        else
            echo -e "${YELLOW}⚠️  Build público no existe${NC}"
        fi

        # Estado del build temporal (no debería existir después del build)
        if [ -d "$BUILD_DIR" ]; then
            echo -e "${YELLOW}⚠️  Build temporal existe (debería haberse movido)${NC}"
        else
            echo -e "${GREEN}✅ Sin builds temporales${NC}"
        fi

        # Estado de dependencias
        if [ -f "$DOCS_DIR/package.json" ]; then
            echo -e "${GREEN}✅ package.json existe${NC}"
            if [ -d "$DOCS_DIR/node_modules" ]; then
                echo -e "${GREEN}✅ Dependencias instaladas${NC}"
            else
                echo -e "${YELLOW}⚠️  Dependencias no instaladas${NC}"
            fi
        else
            echo -e "${RED}❌ package.json no encontrado${NC}"
        fi
    else
        echo -e "${RED}❌ Directorio de documentación no existe${NC}"
    fi
}

# Función para estadísticas
docs_stats() {
    echo -e "${CYAN}📈 Estadísticas de Documentación${NC}"
    echo "====================================="

    if [ ! -d "$DOCS_DIR" ]; then
        echo -e "${RED}❌ Directorio de documentación no encontrado${NC}"
        return 1
    fi

    # Contar archivos por tipo
    local total_md=$(find "$DOCS_DIR" -name "*.md" 2>/dev/null | wc -l)
    local docs_md=$(find "$DOCS_DIR/docs" -name "*.md" 2>/dev/null | wc -l)
    local blog_md=$(find "$DOCS_DIR/blog" -name "*.md" 2>/dev/null | wc -l)

    echo -e "${YELLOW}📊 Archivos Markdown:${NC}"
    echo -e "  Total: $total_md"
    echo -e "  Documentos: $docs_md"
    echo -e "  Blog posts: $blog_md"

    # Tamaño de documentación
    local docs_size=$(du -sh "$DOCS_DIR" 2>/dev/null | cut -f1)
    echo -e "${YELLOW}💾 Tamaño total:${NC} $docs_size"

    # Archivos más grandes
    echo -e "${YELLOW}📄 Documentos más grandes:${NC}"
    find "$DOCS_DIR" -name "*.md" -exec wc -l {} + 2>/dev/null | sort -nr | head -5 | while read lines file; do
        local filename=$(basename "$file")
        echo -e "  $lines líneas - $filename"
    done
}

# Función para buscar enlaces rotos
docs_broken() {
    echo -e "${CYAN}🔍 Buscando enlaces rotos...${NC}"

    if [ ! -d "$DOCS_DIR" ]; then
        echo -e "${RED}❌ Directorio de documentación no encontrado${NC}"
        return 1
    fi

    local broken_count=0

    # Buscar enlaces internos rotos
    find "$DOCS_DIR" -name "*.md" | while read file; do
        # Buscar enlaces relativos que no existen
        grep -oP '\[.*?\]\(\K[^)]+(?=\))' "$file" 2>/dev/null | while read link; do
            if [[ "$link" =~ ^\./ ]] || [[ "$link" =~ ^../ ]] || [[ ! "$link" =~ ^https?:// ]]; then
                local target_file=$(dirname "$file")/"$link"
                if [ ! -f "$target_file" ] && [ ! -d "$target_file" ]; then
                    echo -e "${RED}❌ Enlace roto en $(basename "$file"):${NC} $link"
                    ((broken_count++))
                fi
            fi
        done
    done

    if [ "$broken_count" -eq 0 ]; then
        echo -e "${GREEN}✅ No se encontraron enlaces rotos${NC}"
    else
        echo -e "${YELLOW}⚠️  Se encontraron $broken_count enlaces rotos${NC}"
    fi
}

# Función para limpiar
docs_clean() {
    echo -e "${CYAN}🧹 Limpiando archivos de documentación...${NC}"

    local cleaned=false

    # Limpiar build temporal de Docusaurus (en .docs/build)
    if [ -d "$BUILD_DIR" ]; then
        echo -e "${YELLOW}🗑️  Eliminando build temporal de Docusaurus...${NC}"
        rm -rf "$BUILD_DIR"
        cleaned=true
    fi

    # Limpiar build público (en public/docusaurus)
    if [ -d "$DOCUSAURUS_BUILD_DIR" ]; then
        echo -e "${YELLOW}🗑️  Eliminando build público...${NC}"
        rm -rf "$DOCUSAURUS_BUILD_DIR"
        cleaned=true
    fi

    # Limpiar node_modules si existe
    if [ -d "$DOCS_DIR/node_modules" ]; then
        echo -e "${YELLOW}🗑️  Eliminando node_modules...${NC}"
        rm -rf "$DOCS_DIR/node_modules"
        cleaned=true
    fi

    # Limpiar cache de Docusaurus
    if [ -d "$DOCS_DIR/.docusaurus" ]; then
        echo -e "${YELLOW}🗑️  Eliminando cache de Docusaurus...${NC}"
        rm -rf "$DOCS_DIR/.docusaurus"
        cleaned=true
    fi

    if [ "$cleaned" = true ]; then
        echo -e "${GREEN}✅ Limpieza completada${NC}"
    else
        echo -e "${BLUE}ℹ️  No hay archivos para limpiar${NC}"
    fi
}

# Función principal
main() {
    case "${1:-help}" in
        "dev")
            docs_dev
            ;;
        "start")
            docs_start
            ;;
        "build")
            docs_build "${2:-local}"
            ;;
        "build:github")
            docs_build "github"
            ;;
        "build:clean")
            docs_build "clean"
            ;;
        "create")
            docs_create "$2" "$3"
            ;;
        "status")
            docs_status
            ;;
        "stats")
            docs_stats
            ;;
        "broken")
            docs_broken
            ;;
        "clean")
            docs_clean
            ;;
        "validate")
            echo -e "${CYAN}🔍 Validando documentación...${NC}"
            docs_status
            docs_broken
            ;;
        "setup")
            echo -e "${CYAN}⚙️  Configurando Docusaurus...${NC}"
            if [ -f "$PROJECT_ROOT/scripts/setup.sh" ]; then
                "$PROJECT_ROOT/scripts/setup.sh"
            else
                echo -e "${YELLOW}⚠️  Script de setup no encontrado${NC}"
            fi
            ;;
        "update")
            if [ -d "$DOCS_DIR" ]; then
                cd "$DOCS_DIR"
                echo -e "${CYAN}📦 Actualizando dependencias de Docusaurus...${NC}"
                npm update
            else
                echo -e "${RED}❌ Directorio de documentación no encontrado${NC}"
            fi
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
