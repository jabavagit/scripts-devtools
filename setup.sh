#!/bin/bash

echo "🚀 Configurando proyecto NextJS App..."

# Verificar que Node.js esté instalado
if ! command -v node &> /dev/null; then
    echo "❌ Node.js no está instalado. Por favor instálalo primero."
    exit 1
fi

# Verificar versión de Node
NODE_VERSION=$(node -v | cut -c 2-)
REQUIRED_VERSION="18.0.0"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$NODE_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo "❌ Se requiere Node.js >= $REQUIRED_VERSION, tienes $NODE_VERSION"
    exit 1
fi

echo "✅ Node.js $NODE_VERSION detectado"

# Instalar dependencias
echo "📦 Instalando dependencias..."
npm ci

# Configurar Prisma
echo "🗃️ Configurando base de datos..."
npm run db:generate
npm run db:push

# Configurar Husky
echo "🐕 Configurando Husky..."
npm run prepare
chmod +x .husky/pre-commit .husky/pre-push .husky/commit-msg

# Ejecutar seed
echo "🌱 Poblando base de datos..."
npm run db:seed

# Verificar instalación
echo "🔍 Verificando instalación..."
npm run verify

echo "🎉 ¡Proyecto configurado correctamente!"
echo ""
echo "📝 Comandos disponibles:"
echo "  npm run dev        - Iniciar servidor de desarrollo"
echo "  npm run build      - Construir para producción"
echo "  npm run db:studio  - Abrir Prisma Studio"
echo "  npm run verify     - Verificar todo el proyecto"
echo ""
echo "🚀 Para empezar: npm run dev"
