# 🧹 Comando Clean

El comando `clean` elimina archivos temporales, cachés y directorios generados para mantener el proyecto limpio y resolver problemas comunes de desarrollo.

## 🎯 Descripción

`clean` es el comando de limpieza de DevTools. Identifica y elimina archivos temporales, cachés y directorios que pueden causar problemas durante el desarrollo:

- 🗑️ **Cachés de Paquetes**: node_modules, .pnpm-cache, yarn cache
- 📦 **Archivos de Build**: dist/, build/, .next/, coverage/
- 🔧 **Cachés de Herramientas**: .eslintcache, .tsbuildinfo, .parcel-cache
- 🐳 **Docker**: Contenedores, imágenes y volúmenes no utilizados
- 🌐 **Navegadores**: Cachés de Playwright, Puppeteer, Cypress
- 💾 **Temporales del Sistema**: .DS_Store, Thumbs.db, logs

## 🚀 Uso

```bash
# Limpieza estándar (segura)
./devTools clean

# Limpieza completa (incluye node_modules)
./devTools clean --all

# Limpieza agresiva (incluye datos de usuario)
./devTools clean --deep

# Vista previa sin eliminar archivos
./devTools clean --dry-run

# Limpieza interactiva con confirmaciones
./devTools clean --interactive
```

## 🎨 Opciones Disponibles

### Opciones Principales
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--all` | Limpieza completa incluyendo node_modules | `./devTools clean --all` |
| `--deep` | Limpieza agresiva incluyendo datos de usuario | `./devTools clean --deep` |
| `--dry-run` | Mostrar qué se eliminaría sin hacerlo | `./devTools clean --dry-run` |
| `--interactive` | Confirmar cada eliminación | `./devTools clean --interactive` |
| `--force` | Eliminar sin confirmaciones | `./devTools clean --force` |
| `--verbose` | Mostrar detalles de lo eliminado | `./devTools clean --verbose` |

### Opciones de Limpieza Específica
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--cache-only` | Solo eliminar cachés | `./devTools clean --cache-only` |
| `--build-only` | Solo eliminar archivos de build | `./devTools clean --build-only` |
| `--deps-only` | Solo eliminar dependencias | `./devTools clean --deps-only` |
| `--docker-only` | Solo limpiar Docker | `./devTools clean --docker-only` |
| `--logs-only` | Solo eliminar logs | `./devTools clean --logs-only` |

### Opciones de Exclusión
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--no-docker` | Omitir limpieza de Docker | `./devTools clean --all --no-docker` |
| `--no-cache` | Omitir limpieza de cachés | `./devTools clean --no-cache` |
| `--keep-logs` | Conservar archivos de log | `./devTools clean --all --keep-logs` |

## 🗑️ Tipos de Limpieza

### 🧹 Limpieza Estándar (Segura)
```bash
# Limpieza básica y segura
./devTools clean
```

**Archivos/Directorios Eliminados:**
- `dist/`, `build/`, `coverage/`
- `.eslintcache`, `.tsbuildinfo`
- `.parcel-cache`, `.cache/`
- `*.log` (archivos de log)
- `.DS_Store`, `Thumbs.db`

### 🧽 Limpieza Completa
```bash
# Incluye dependencias instaladas
./devTools clean --all
```

**Eliminaciones Adicionales:**
- `node_modules/`
- `.pnpm-cache/`, `~/.yarn/cache/`
- `~/.npm/_cacache/`
- Cachés de gestores de paquetes

### 🌊 Limpieza Profunda
```bash
# Limpieza agresiva (usar con precaución)
./devTools clean --deep
```

**Eliminaciones Agresivas:**
- Todos los datos de usuario de herramientas
- Configuraciones temporales
- Cachés del sistema operativo
- Datos de navegadores de testing

### 🐳 Limpieza de Docker
```bash
# Solo limpiar Docker
./devTools clean --docker-only
```

**Operaciones de Docker:**
- Contenedores detenidos
- Imágenes sin tag
- Volúmenes no utilizados
- Redes sin usar
- Cache de build

## 📋 Ejemplo de Salida

```bash
$ ./devTools clean --all --verbose

🧹 DevTools Clean - Limpieza del Proyecto
========================================

📁 Proyecto: mi-react-app
📍 Ruta: /home/usuario/proyectos/mi-react-app
⏰ Inicio: 2024-01-15 14:40:33

🔍 ANÁLISIS DE ARCHIVOS A ELIMINAR
==================================

📦 DEPENDENCIAS Y CACHÉS
🗑️  node_modules/ (2.1 GB)
🗑️  .pnpm-cache/ (456 MB)
🗑️  ~/.npm/_cacache/ (234 MB)

🏗️  ARCHIVOS DE BUILD
🗑️  dist/ (34 MB)
🗑️  coverage/ (12 MB)
🗑️  .parcel-cache/ (89 MB)

🔧 CACHÉS DE HERRAMIENTAS
🗑️  .eslintcache (2.3 MB)
🗑️  .tsbuildinfo (847 KB)
🗑️  .vite/ (45 MB)

📝 LOGS Y TEMPORALES
🗑️  npm-debug.log (1.2 KB)
🗑️  yarn-error.log (3.4 KB)
🗑️  .DS_Store (6 KB)

🐳 DOCKER (si existe)
🗑️  3 contenedores detenidos
🗑️  2 imágenes sin tag (1.2 GB)
🗑️  1 volumen no utilizado (234 MB)

📊 RESUMEN DE ELIMINACIÓN
========================================
📁 Directorios: 8
📄 Archivos: 23
💾 Espacio a liberar: 4.8 GB

❓ ¿Continuar con la eliminación? (y/N): y

🔄 EJECUTANDO LIMPIEZA
====================

📦 Eliminando dependencias...
🗑️  ✅ node_modules/ eliminado (2.1 GB liberado)
🗑️  ✅ .pnpm-cache/ eliminado (456 MB liberado)
🗑️  ✅ ~/.npm/_cacache/ limpiado (234 MB liberado)

🏗️  Eliminando archivos de build...
🗑️  ✅ dist/ eliminado (34 MB liberado)
🗑️  ✅ coverage/ eliminado (12 MB liberado)
🗑️  ✅ .parcel-cache/ eliminado (89 MB liberado)

🔧 Eliminando cachés de herramientas...
🗑️  ✅ .eslintcache eliminado (2.3 MB liberado)
🗑️  ✅ .tsbuildinfo eliminado (847 KB liberado)
🗑️  ✅ .vite/ eliminado (45 MB liberado)

📝 Eliminando logs y temporales...
🗑️  ✅ 5 archivos de log eliminados
🗑️  ✅ Archivos temporales del sistema eliminados

🐳 Limpiando Docker...
🗑️  ✅ 3 contenedores eliminados
🗑️  ✅ 2 imágenes eliminadas (1.2 GB liberado)
🗑️  ✅ 1 volumen eliminado (234 MB liberado)

✅ LIMPIEZA COMPLETADA
========================================
🗑️  Archivos eliminados: 23
📁 Directorios eliminados: 8
💾 Espacio liberado: 4.8 GB
🕒 Tiempo total: 34.7 segundos

🚀 SIGUIENTE PASO:
Para restaurar el proyecto ejecuta:
  ./devTools setup

💡 RECOMENDACIÓN:
Usa 'verify' para confirmar el estado después de setup:
  ./devTools verify
```

## 🚨 Códigos de Salida

| Código | Significado | Descripción |
|--------|-------------|-------------|
| `0` | ✅ Éxito | Limpieza completada exitosamente |
| `1` | ⚠️ Advertencias | Algunos archivos no pudieron eliminarse |
| `2` | ❌ Errores | Fallos en operaciones de eliminación |
| `3` | 🚫 Crítico | Error crítico durante la limpieza |

## 🎯 Casos de Uso Comunes

### 🔄 Resolución de Problemas de Build
```bash
# Cuando el build está fallando
./devTools clean --build-only
./devTools setup --deps-only

# Si persisten los problemas
./devTools clean --all
./devTools setup
```

### 🧽 Limpieza de Rutina
```bash
# Limpieza semanal de desarrollo
./devTools clean --cache-only

# Limpieza mensual completa
./devTools clean --all --docker-only
```

### 🚀 Preparación para Deploy
```bash
# Antes de crear un build de producción
./devTools clean --build-only
npm run build
```

### 💾 Liberación de Espacio
```bash
# Ver cuánto espacio se puede liberar
./devTools clean --deep --dry-run

# Liberar máximo espacio posible
./devTools clean --deep --force
```

## 🔧 Personalización

### Variables de Entorno
```bash
# Configurar directorios adicionales a limpiar
export DEVTOOLS_CLEAN_DIRS="tmp,temp,cache"

# Omitir confirmaciones por defecto
export DEVTOOLS_CLEAN_FORCE=true

# Conservar ciertos tipos de archivos
export DEVTOOLS_KEEP_LOGS=true
```

### Archivo de Configuración
```json
// .devtools.json
{
  "clean": {
    "defaultMode": "standard",
    "preserveFiles": [
      "important-cache.json",
      "user-preferences.json"
    ],
    "customDirectories": [
      "tmp/",
      "temp/",
      "custom-cache/"
    ],
    "dockerCleanup": true,
    "confirmBeforeDelete": true
  }
}
```

## 🛡️ Protecciones de Seguridad

### Archivos Protegidos
```bash
# Nunca se eliminan automáticamente:
- .git/
- .env*
- package.json
- README.md
- src/
- Archivos de configuración principales
```

### Confirmaciones Requeridas
```bash
# Operaciones que siempre piden confirmación:
./devTools clean --deep        # Datos de usuario
./devTools clean --all         # node_modules
./devTools clean --docker-only # Contenedores Docker
```

### Modo Seguro
```bash
# Vista previa antes de eliminar
./devTools clean --dry-run --verbose

# Confirmación interactiva
./devTools clean --interactive
```

## 📊 Análisis de Uso de Espacio

### Reporte Detallado
```bash
# Ver uso de espacio antes de limpiar
./devTools clean --analyze

# Comparar antes y después
du -sh . > before.txt
./devTools clean --all
du -sh . > after.txt
```

### Identificación de Archivos Grandes
```bash
# Encontrar archivos grandes en el proyecto
find . -type f -size +100M -not -path "./.git/*"

# Top 10 directorios más grandes
du -sh */ | sort -hr | head -10
```

## 💡 Tips y Trucos

### 🚀 Aliases Útiles
```bash
# Crear aliases para uso frecuente
alias dtc='./devTools clean'
alias dtca='./devTools clean --all'
alias dtcd='./devTools clean --dry-run'
alias dtci='./devTools clean --interactive'
```

### 🔄 Automatización
```bash
# Script de limpieza automática semanal
#!/bin/bash
# weekly-clean.sh

echo "🧹 Limpieza automática semanal..."
./devTools clean --cache-only --force

echo "🔍 Verificando estado después de limpieza..."
./devTools verify --fast
```

### 🎯 Limpieza Selectiva
```bash
# Solo limpiar cachés de herramientas específicas
./devTools clean --cache-only --include "eslint,typescript"

# Limpiar todo excepto Docker
./devTools clean --all --no-docker
```

## 🔄 Integración con Otros Comandos

### Flujo de Trabajo Completo
```bash
# Secuencia típica de resolución de problemas
./devTools clean --all      # Limpiar todo
./devTools setup            # Reconfigurar
./devTools verify           # Verificar estado
./devTools status           # Confirmar que todo funciona
```

### Scripts de CI/CD
```bash
# En pipeline de CI: limpiar antes de build
./devTools clean --build-only --force
npm run build

# En ambiente de testing: limpieza completa
./devTools clean --all --no-docker --force
```

---

> 💡 **Tip**: Usa `clean --dry-run` primero para ver exactamente qué se eliminará antes de confirmar la operación.
