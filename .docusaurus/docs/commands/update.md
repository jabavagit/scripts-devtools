# 🔄 Comando Update

El comando `update` mantiene actualizado el entorno de desarrollo, gestionando dependencias, herramientas y configuraciones para asegurar la última versión de todo.

## 🎯 Descripción

`update` es el comando de actualización de DevTools. Gestiona automáticamente todas las actualizaciones necesarias para mantener el proyecto y entorno de desarrollo al día:

- 📦 **Dependencias**: npm, yarn, pnpm packages
- 🔧 **Herramientas**: Node.js, Docker, Git, VS Code extensions
- ⚙️ **Configuraciones**: Templates actualizados, nuevas reglas
- 🛡️ **Seguridad**: Parches de vulnerabilidades, actualizaciones críticas
- 🌐 **DevTools**: Auto-actualización de la suite DevTools
- 📚 **Documentación**: Plantillas y estructura actualizada

## 🚀 Uso

```bash
# Actualización completa automática
./devTools update

# Actualización interactiva con confirmaciones
./devTools update --interactive

# Solo verificar actualizaciones disponibles
./devTools update --check-only

# Actualización forzada (sin confirmaciones)
./devTools update --force

# Actualizar solo dependencias
./devTools update --deps-only
```

## 🎨 Opciones Disponibles

### Opciones Principales
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--interactive` | Confirmar cada actualización individualmente | `./devTools update --interactive` |
| `--force` | Actualizar sin confirmaciones | `./devTools update --force` |
| `--check-only` | Solo verificar, no actualizar | `./devTools update --check-only` |
| `--dry-run` | Simular actualizaciones sin aplicarlas | `./devTools update --dry-run` |
| `--verbose` | Información detallada del proceso | `./devTools update --verbose` |

### Opciones de Actualización Específica
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--deps-only` | Solo actualizar dependencias del proyecto | `./devTools update --deps-only` |
| `--tools-only` | Solo actualizar herramientas de desarrollo | `./devTools update --tools-only` |
| `--security-only` | Solo parches de seguridad críticos | `./devTools update --security-only` |
| `--major` | Incluir actualizaciones de versión mayor | `./devTools update --major` |
| `--devtools-only` | Solo actualizar DevTools suite | `./devTools update --devtools-only` |

### Opciones de Control
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--exclude <pattern>` | Excluir paquetes específicos | `./devTools update --exclude "react,vue"` |
| `--include <pattern>` | Solo incluir paquetes específicos | `./devTools update --include "eslint,prettier"` |
| `--no-backup` | No crear respaldo antes de actualizar | `./devTools update --no-backup` |
| `--rollback` | Revertir última actualización | `./devTools update --rollback` |

## 📦 Tipos de Actualización

### 🔧 Actualización de Dependencias
```bash
# Actualizar todas las dependencias del proyecto
./devTools update --deps-only
```

**Gestión de Dependencias:**
- 🔍 **Análisis**: Detecta dependencias desactualizadas
- 🛡️ **Seguridad**: Prioriza parches de vulnerabilidades
- 📊 **Compatibilidad**: Verifica breaking changes
- 🔄 **Testing**: Ejecuta tests después de actualizar
- 💾 **Backup**: Crea respaldo de package-lock.json

### 🛠️ Actualización de Herramientas
```bash
# Actualizar herramientas de desarrollo
./devTools update --tools-only
```

**Herramientas Gestionadas:**
- **Node.js**: Versiones LTS y actuales
- **npm/yarn/pnpm**: Últimas versiones estables
- **Docker**: Engine y Compose
- **Git**: Cliente y herramientas auxiliares
- **VS Code**: Extensions recomendadas

### 🛡️ Actualizaciones de Seguridad
```bash
# Solo parches críticos de seguridad
./devTools update --security-only
```

**Características de Seguridad:**
- 🚨 **Vulnerabilidades Críticas**: CVE scores altos
- 🔍 **Audit Automático**: npm audit, yarn audit
- 📊 **Reporte**: Detalle de vulnerabilidades resueltas
- ⚡ **Urgencia**: Prioridad para parches críticos

### 🔄 Auto-actualización DevTools
```bash
# Actualizar la suite DevTools
./devTools update --devtools-only
```

**Funcionalidades:**
- 📥 **Descarga**: Última versión desde repositorio
- 🔧 **Migración**: Configuraciones y personalizaciones
- 📚 **Documentación**: Templates actualizados
- ✅ **Verificación**: Tests de integridad post-actualización

## 📋 Ejemplo de Salida

```bash
$ ./devTools update --interactive

🔄 DevTools Update - Actualización del Sistema
=============================================

📁 Proyecto: mi-react-app
📍 Ruta: /home/usuario/proyectos/mi-react-app
⏰ Inicio: 2024-01-15 15:00:12

🔍 ANÁLISIS DE ACTUALIZACIONES DISPONIBLES
==========================================

📦 DEPENDENCIAS DEL PROYECTO
============================
🔄 React: 18.2.0 → 18.2.3 (patch)
   📝 Cambios: Bug fixes, performance improvements
   🛡️ Seguridad: No vulnerabilities
   ❓ ¿Actualizar? (Y/n): y

🔄 TypeScript: 4.9.5 → 5.0.2 (major)
   📝 Cambios: New features, breaking changes
   ⚠️  Atención: Posibles breaking changes
   📚 Guía: https://devblogs.microsoft.com/typescript/
   ❓ ¿Actualizar? (y/N): n

🔄 @types/react: 18.0.26 → 18.0.28 (patch)
   📝 Cambios: Type definitions updates
   ❓ ¿Actualizar? (Y/n): y

🔄 eslint: 8.34.0 → 8.39.0 (minor)
   📝 Cambios: New rules, bug fixes
   🛡️ Seguridad: CVE-2023-12345 fixed
   ❓ ¿Actualizar? (Y/n): y

🛠️  HERRAMIENTAS DE DESARROLLO
=============================
🔄 Node.js: 18.17.0 → 20.2.0 (major)
   📝 LTS nueva disponible
   ⚠️  Atención: Testing requerido
   ❓ ¿Actualizar? (y/N): n

🔄 npm: 9.6.7 → 9.8.1 (minor)
   📝 Cambios: Performance improvements
   ❓ ¿Actualizar? (Y/n): y

🔄 Docker: 24.0.2 → 24.0.5 (patch)
   📝 Cambios: Security patches
   🛡️ Seguridad: Múltiples CVEs resueltos
   ❓ ¿Actualizar? (Y/n): y

⚙️  CONFIGURACIONES
==================
🔄 ESLint Config Template: Nueva versión disponible
   📝 Cambios: Nuevas reglas para TypeScript 5.0
   ❓ ¿Actualizar configuración? (y/N): n

🔄 DevTools Suite: 2.1.0 → 2.2.0 (minor)
   📝 Cambios: Nuevo comando 'ports', mejoras UI
   📚 Documentación actualizada
   ❓ ¿Actualizar DevTools? (Y/n): y

📊 RESUMEN DE ACTUALIZACIONES SELECCIONADAS
==========================================
✅ React: 18.2.0 → 18.2.3
✅ @types/react: 18.0.26 → 18.0.28
✅ eslint: 8.34.0 → 8.39.0
✅ npm: 9.6.7 → 9.8.1
✅ Docker: 24.0.2 → 24.0.5
✅ DevTools: 2.1.0 → 2.2.0

⏭️  Omitidas (versiones mayores): 2
🛡️ Parches de seguridad: 2
📦 Total de actualizaciones: 6

❓ ¿Continuar con las actualizaciones? (Y/n): y

🔄 EJECUTANDO ACTUALIZACIONES
============================

💾 Creando respaldo...
✅ package.json respaldado como package.json.backup
✅ package-lock.json respaldado

📦 Actualizando dependencias del proyecto...
🔄 Descargando React 18.2.3...
✅ React actualizado (8.2s)
🔄 Descargando @types/react 18.0.28...
✅ @types/react actualizado (3.1s)
🔄 Descargando eslint 8.39.0...
✅ eslint actualizado (12.4s)

🧪 Ejecutando tests de compatibilidad...
✅ Build test: exitoso
✅ Unit tests: 24/24 passed
✅ Lint check: sin errores

🛠️  Actualizando herramientas del sistema...
🔄 Actualizando npm...
✅ npm actualizado a 9.8.1 (15.3s)
🔄 Actualizando Docker...
✅ Docker actualizado a 24.0.5 (45.2s)

🔄 Actualizando DevTools...
📥 Descargando DevTools 2.2.0...
🔧 Migrando configuraciones...
📚 Actualizando documentación...
✅ DevTools actualizado exitosamente

📋 POST-ACTUALIZACIÓN
=====================
🔧 Regenerando lock files...
✅ package-lock.json actualizado
🧹 Limpiando cachés...
✅ npm cache limpiado
🔍 Verificando integridad...
✅ Todas las dependencias íntegras

✅ ACTUALIZACIÓN COMPLETADA
==========================
📦 Paquetes actualizados: 6
🛡️ Vulnerabilidades resueltas: 2
⏰ Tiempo total: 2m 34s
💾 Respaldo guardado en: .devtools-backups/

🚀 SIGUIENTE PASO:
Verificar que todo funciona correctamente:
  ./devTools verify
  npm run dev

💡 NOTA:
Si encuentras problemas, puedes revertir:
  ./devTools update --rollback
```

## 🚨 Códigos de Salida

| Código | Significado | Descripción |
|--------|-------------|-------------|
| `0` | ✅ Éxito | Todas las actualizaciones completadas |
| `1` | ⚠️ Parcial | Algunas actualizaciones fallaron |
| `2` | ❌ Error | Fallos críticos en actualización |
| `3` | 🚫 Crítico | Sistema en estado inconsistente |

## 🎯 Casos de Uso Comunes

### 🔄 Actualización de Rutina
```bash
# Verificación semanal de actualizaciones
./devTools update --check-only

# Actualización mensual completa
./devTools update --interactive
```

### 🛡️ Parches de Seguridad Urgentes
```bash
# Solo parches críticos de seguridad
./devTools update --security-only --force

# Verificar vulnerabilidades después
npm audit
```

### 🚀 Preparación para Nueva Funcionalidad
```bash
# Actualizar todo antes de nueva feature
./devTools update --interactive
./devTools verify
./devTools clean --cache-only
```

### 🔧 Mantenimiento del Sistema
```bash
# Actualizar solo herramientas de desarrollo
./devTools update --tools-only

# Actualizar DevTools a la última versión
./devTools update --devtools-only
```

## 🔧 Personalización

### Variables de Entorno
```bash
# Configurar estrategia de actualización
export DEVTOOLS_UPDATE_STRATEGY=interactive

# Definir umbrales de versión
export DEVTOOLS_ALLOW_MAJOR=false
export DEVTOOLS_AUTO_SECURITY=true

# Configurar timeouts
export DEVTOOLS_UPDATE_TIMEOUT=300
```

### Archivo de Configuración
```json
// .devtools.json
{
  "update": {
    "strategy": "interactive",
    "autoSecurity": true,
    "allowMajor": false,
    "createBackups": true,
    "excludePackages": [
      "react",
      "vue"
    ],
    "testAfterUpdate": true,
    "notifyOnUpdates": true
  }
}
```

## 🛡️ Gestión de Riesgos

### Respaldos Automáticos
```bash
# Crear respaldo manual antes de actualizar
./devTools update --backup-only

# Ver respaldos disponibles
ls -la .devtools-backups/

# Restaurar desde respaldo específico
./devTools update --restore .devtools-backups/2024-01-15_14-30-12/
```

### Rollback Automático
```bash
# Revertir última actualización
./devTools update --rollback

# Rollback con verificación
./devTools update --rollback --verify
```

### Testing Automatizado
```bash
# Actualizar con testing automático
./devTools update --test

# Solo actualizar si los tests pasan
./devTools update --safe-only
```

## 📊 Análisis de Dependencias

### Reporte de Actualizaciones
```bash
# Generar reporte detallado
./devTools update --report > update-analysis.txt

# Reporte en formato JSON
./devTools update --check-only --json > updates.json
```

### Análisis de Impacto
```bash
# Ver breaking changes potenciales
./devTools update --check-only --breaking-changes

# Análisis de compatibilidad
./devTools update --compatibility-check
```

## 💡 Tips y Trucos

### 🚀 Aliases Útiles
```bash
# Crear aliases para uso frecuente
alias dtu='./devTools update'
alias dtuc='./devTools update --check-only'
alias dtui='./devTools update --interactive'
alias dtus='./devTools update --security-only'
```

### 🔄 Automatización
```bash
# Script de actualización automática semanal
#!/bin/bash
# weekly-update.sh

echo "🔄 Actualización automática semanal..."

# Solo parches de seguridad automáticamente
./devTools update --security-only --force

# Verificar estado después
./devTools verify --fast

# Notificar si hay actualizaciones mayores disponibles
updates=$(./devTools update --check-only --major)
if [ -n "$updates" ]; then
    echo "📢 Actualizaciones mayores disponibles" | mail -s "DevTools Update" admin@ejemplo.com
fi
```

### 📊 Dashboard de Actualizaciones
```bash
# Ver estado de actualizaciones en formato tabla
./devTools update --check-only --table

# Generar gráfico de tendencias (con herramientas adicionales)
./devTools update --check-only --json | jq -r '.packages[] | [.name, .current, .latest] | @csv' > updates.csv
```

## 🔄 Integración con CI/CD

### Pipeline de Actualizaciones
```yaml
# .github/workflows/auto-update.yml
name: Auto Update Dependencies

on:
  schedule:
    - cron: '0 2 * * 1'  # Lunes a las 2 AM

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup DevTools
        run: chmod +x devTools
      
      - name: Check for updates
        run: ./devTools update --check-only --security-only
      
      - name: Apply security updates
        run: ./devTools update --security-only --force
      
      - name: Run tests
        run: npm test
      
      - name: Create PR for other updates
        if: success()
        run: ./devTools update --check-only --create-pr
```

### Notificaciones
```bash
# Integración con Slack para notificar actualizaciones
./devTools update --check-only --slack-webhook $SLACK_WEBHOOK

# Notificación por email
./devTools update --security-only --notify-email admin@ejemplo.com
```

---

> 💡 **Tip**: Usa `update --check-only` regularmente para mantener visibilidad sobre actualizaciones disponibles sin aplicarlas inmediatamente.
