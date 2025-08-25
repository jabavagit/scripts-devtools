# ⚙️ Comando Setup

El comando `setup` configura automáticamente el entorno de desarrollo, instalando dependencias, configurando herramientas y preparando el proyecto para el desarrollo.

## 🎯 Descripción

`setup` es el comando de configuración automática de DevTools. Analiza el proyecto y realiza las configuraciones necesarias para un entorno de desarrollo óptimo:

- 📦 **Instalación de Dependencias**: npm, yarn, pnpm según el proyecto
- 🔧 **Configuración de Herramientas**: ESLint, Prettier, TypeScript
- 🌐 **Variables de Entorno**: Configuración de .env files
- 🗃️ **Base de Datos**: Setup de bases de datos locales
- 🐳 **Docker**: Configuración de contenedores de desarrollo
- 🔑 **Autenticación**: Setup de tokens y credenciales

## 🚀 Uso

```bash
# Setup automático completo
./devTools setup

# Setup forzado (sobrescribe configuraciones existentes)
./devTools setup --force

# Setup interactivo con confirmaciones
./devTools setup --interactive

# Setup específico de dependencias solamente
./devTools setup --deps-only

# Setup con modo verbose para debugging
./devTools setup --verbose
```

## 🎨 Opciones Disponibles

### Opciones Principales
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--force` | Sobrescribe configuraciones existentes | `./devTools setup --force` |
| `--interactive` | Modo interactivo con confirmaciones | `./devTools setup --interactive` |
| `--verbose` | Salida detallada del proceso | `./devTools setup --verbose` |
| `--dry-run` | Simula setup sin realizar cambios | `./devTools setup --dry-run` |
| `--quiet` | Salida mínima, solo errores | `./devTools setup --quiet` |

### Opciones de Configuración Específica
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--deps-only` | Solo instalar dependencias | `./devTools setup --deps-only` |
| `--config-only` | Solo generar archivos de configuración | `./devTools setup --config-only` |
| `--env-only` | Solo configurar variables de entorno | `./devTools setup --env-only` |
| `--docker-only` | Solo configurar Docker | `./devTools setup --docker-only` |
| `--no-docker` | Omitir configuración de Docker | `./devTools setup --no-docker` |

### Opciones de Gestores de Paquetes
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--npm` | Forzar uso de npm | `./devTools setup --npm` |
| `--yarn` | Forzar uso de yarn | `./devTools setup --yarn` |
| `--pnpm` | Forzar uso de pnpm | `./devTools setup --pnpm` |

## 🏗️ Tipos de Setup

### 📦 Setup de Dependencias
```bash
# Instalación automática de dependencias
./devTools setup --deps-only
```

**Funcionalidades:**
- 🔍 Detecta automáticamente el gestor de paquetes preferido
- 📦 Instala dependencias de desarrollo y producción
- 🔒 Verifica integridad de paquetes instalados
- 🚀 Optimiza instalación para velocidad

### ⚙️ Setup de Configuración
```bash
# Generación de archivos de configuración
./devTools setup --config-only
```

**Archivos Generados:**
- `.eslintrc.js` - Configuración de ESLint
- `prettier.config.js` - Configuración de Prettier
- `.editorconfig` - Configuración del editor
- `tsconfig.json` - Configuración de TypeScript (si aplica)
- `.gitignore` - Patrones de Git (si no existe)

### 🌐 Setup de Variables de Entorno
```bash
# Configuración de variables de entorno
./devTools setup --env-only
```

**Funcionalidades:**
- 📋 Genera `.env.example` con variables requeridas
- 🔐 Crea `.env.local` para desarrollo
- ⚙️ Configura variables específicas del framework
- 🔑 Setup de tokens de desarrollo

### 🐳 Setup de Docker
```bash
# Configuración de contenedores de desarrollo
./devTools setup --docker-only
```

**Archivos Generados:**
- `Dockerfile` - Imagen de la aplicación
- `docker-compose.yml` - Orquestación de servicios
- `.dockerignore` - Patrones de exclusión
- `scripts/docker-dev.sh` - Scripts de desarrollo

## 📋 Ejemplo de Salida

```bash
$ ./devTools setup

⚙️  DevTools Setup - Configuración del Proyecto
=============================================

📁 Proyecto: mi-react-app
📍 Ruta: /home/usuario/proyectos/mi-react-app
⏰ Inicio: 2024-01-15 14:35:22

🔍 ANÁLISIS DEL PROYECTO
✅ Proyecto React detectado
✅ TypeScript configurado
✅ Package.json válido
📦 Gestor de paquetes: pnpm (detectado)

📦 INSTALACIÓN DE DEPENDENCIAS
🔄 Instalando dependencias de producción...
✅ React, TypeScript, Vite instalados
🔄 Instalando dependencias de desarrollo...
✅ ESLint, Prettier, Testing Library instalados
📊 Total: 847 paquetes instalados en 24.3s

⚙️  CONFIGURACIÓN DE HERRAMIENTAS
🔄 Generando .eslintrc.js...
✅ ESLint configurado para React + TypeScript
🔄 Generando prettier.config.js...
✅ Prettier configurado con reglas estándar
🔄 Generando .editorconfig...
✅ EditorConfig configurado
🔄 Actualizando tsconfig.json...
✅ TypeScript optimizado para desarrollo

🌐 VARIABLES DE ENTORNO
🔄 Generando .env.example...
✅ Plantilla de variables creada
🔄 Creando .env.local...
✅ Variables de desarrollo configuradas
⚠️  RECORDATORIO: Configurar API_KEY en .env.local

🐳 DOCKER (OPCIONAL)
❓ ¿Configurar Docker para desarrollo? (y/N): y
🔄 Generando Dockerfile...
✅ Dockerfile creado para Node.js 18
🔄 Generando docker-compose.yml...
✅ Docker Compose configurado
✅ Scripts de Docker creados

🔧 CONFIGURACIÓN ADICIONAL
🔄 Configurando Git hooks...
✅ Pre-commit hooks instalados
🔄 Configurando VS Code settings...
✅ Workspace settings creados
🔄 Actualizando .gitignore...
✅ Patrones adicionales agregados

📊 RESUMEN
=============================================
✅ Dependencias instaladas: 847 paquetes
✅ Archivos de configuración: 8 creados
✅ Variables de entorno: configuradas
✅ Docker: configurado
🕒 Tiempo total: 1m 45s

🚀 SIGUIENTE PASO:
Configurar tu API_KEY en .env.local y ejecutar:
  pnpm dev

💡 COMANDOS ÚTILES:
  ./devTools verify     # Verificar configuración
  ./devTools status     # Ver estado del proyecto
  pnpm dev             # Iniciar desarrollo
  pnpm build           # Construir para producción
```

## 🚨 Códigos de Salida

| Código | Significado | Descripción |
|--------|-------------|-------------|
| `0` | ✅ Éxito | Setup completado exitosamente |
| `1` | ⚠️ Advertencias | Setup completado con advertencias menores |
| `2` | ❌ Errores | Fallos parciales en configuración |
| `3` | 🚫 Crítico | Setup falló completamente |

## 🎯 Casos de Uso Comunes

### 🆕 Configuración de Proyecto Nuevo
```bash
# Después de clonar un repositorio
git clone <repo-url> mi-proyecto
cd mi-proyecto
./devTools setup

# Verificar que todo está listo
./devTools verify
```

### 🔄 Reconfiguración Completa
```bash
# Limpiar y reconfigurar desde cero
./devTools clean --all
./devTools setup --force

# Configuración interactiva para control manual
./devTools setup --interactive --force
```

### 🐳 Setup Solo para Docker
```bash
# Solo configurar Docker sin tocar dependencias
./devTools setup --docker-only

# Setup sin Docker
./devTools setup --no-docker
```

### 🧪 Modo de Prueba
```bash
# Ver qué haría el setup sin realizar cambios
./devTools setup --dry-run --verbose

# Setup silencioso para scripts
./devTools setup --quiet
```

## 🔧 Personalización

### Variables de Entorno
```bash
# Configurar gestor de paquetes preferido
export DEVTOOLS_PACKAGE_MANAGER=pnpm

# Omitir configuraciones específicas
export DEVTOOLS_SKIP_DOCKER=true
export DEVTOOLS_SKIP_ESLINT=true

# Configurar timeout para instalación
export DEVTOOLS_INSTALL_TIMEOUT=300
```

### Archivo de Configuración
```json
// .devtools.json
{
  "setup": {
    "packageManager": "pnpm",
    "skipDocker": false,
    "skipLinting": false,
    "generateVSCodeSettings": true,
    "installGitHooks": true,
    "environmentVariables": {
      "NODE_ENV": "development",
      "PORT": "3000"
    },
    "customScripts": [
      "scripts/post-setup.sh"
    ]
  }
}
```

## 🎨 Templates de Configuración

### ESLint Template (React + TypeScript)
```javascript
// .eslintrc.js
module.exports = {
  root: true,
  env: { browser: true, es2020: true },
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
    '@typescript-eslint/recommended-requiring-type-checking',
    'plugin:react-hooks/recommended',
  ],
  ignorePatterns: ['dist', '.eslintrc.cjs'],
  parser: '@typescript-eslint/parser',
  plugins: ['react-refresh'],
  rules: {
    'react-refresh/only-export-components': [
      'warn',
      { allowConstantExport: true },
    ],
  },
}
```

### Prettier Template
```javascript
// prettier.config.js
module.exports = {
  semi: true,
  trailingComma: 'es5',
  singleQuote: true,
  printWidth: 80,
  tabWidth: 2,
  useTabs: false,
}
```

### Docker Template
```dockerfile
# Dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
```

## 🤖 Detección Automática

### Tipos de Proyecto Soportados
- **React**: Vite, Create React App, Next.js
- **Vue**: Vue CLI, Nuxt.js, Vite
- **Angular**: Angular CLI
- **Node.js**: Express, Fastify, NestJS
- **Python**: Django, Flask, FastAPI
- **PHP**: Laravel, Symfony
- **Go**: Gin, Echo, Fiber

### Gestores de Paquetes
```bash
# Detección automática basada en lock files
# pnpm-lock.yaml -> pnpm
# yarn.lock -> yarn
# package-lock.json -> npm
```

## 💡 Tips y Trucos

### 🚀 Setup Rápido
```bash
# Alias útil para setup rápido
alias dts='./devTools setup'
alias dtsf='./devTools setup --force'
alias dtsi='./devTools setup --interactive'
```

### 🔄 Actualización de Configuraciones
```bash
# Solo actualizar configuraciones sin tocar dependencias
./devTools setup --config-only --force

# Regenerar solo variables de entorno
./devTools setup --env-only --force
```

### 🐛 Debugging de Setup
```bash
# Ver exactamente qué está haciendo
./devTools setup --verbose --dry-run > setup-plan.txt

# Setup paso a paso para debugging
./devTools setup --interactive --verbose
```

## 🤝 Extensibilidad

### Scripts Post-Setup
```bash
# scripts/post-setup.sh
#!/bin/bash
echo "🔧 Ejecutando configuración personalizada..."

# Tu lógica personalizada aquí
if [ -d "src/components" ]; then
    echo "✅ Creando index barrel files..."
    # Generar archivos index.ts automáticamente
fi

echo "✅ Setup personalizado completado"
```

### Hooks de Setup
```json
// .devtools.json
{
  "setup": {
    "hooks": {
      "preInstall": "scripts/pre-install.sh",
      "postInstall": "scripts/post-install.sh",
      "preConfig": "scripts/pre-config.sh",
      "postConfig": "scripts/post-config.sh"
    }
  }
}
```

---

> 💡 **Tip**: Usa `setup --interactive` la primera vez para revisar qué configuraciones se aplicarán a tu proyecto.
