# 📊 Comando Status

El comando `status` proporciona una vista en tiempo real del estado del sistema, procesos activos, uso de recursos y estado del proyecto de desarrollo.

## 🎯 Descripción

`status` es el comando de monitoreo de DevTools. Ofrece un dashboard completo del estado actual del sistema y proyecto:

- 🖥️ **Sistema**: CPU, memoria, disco, red
- 📦 **Proyecto**: Estado de dependencias, builds, configuraciones
- 🔄 **Procesos**: Servicios en ejecución, puertos ocupados
- 🌐 **Red**: Conectividad, APIs, servicios externos
- 🐳 **Docker**: Contenedores, imágenes, volúmenes
- 📝 **Git**: Estado del repositorio, cambios pendientes

## 🚀 Uso

```bash
# Estado completo del sistema y proyecto
./devTools status

# Estado en tiempo real (actualización continua)
./devTools status --watch

# Estado resumido (solo información crítica)
./devTools status --brief

# Estado específico del proyecto
./devTools status --project-only

# Estado del sistema solamente
./devTools status --system-only
```

## 🎨 Opciones Disponibles

### Opciones Principales
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--watch` | Actualización continua en tiempo real | `./devTools status --watch` |
| `--brief` | Vista resumida con información crítica | `./devTools status --brief` |
| `--verbose` | Información detallada completa | `./devTools status --verbose` |
| `--json` | Salida en formato JSON para scripts | `./devTools status --json` |
| `--export` | Exportar estado a archivo | `./devTools status --export status.json` |

### Opciones de Filtrado
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--system-only` | Solo información del sistema | `./devTools status --system-only` |
| `--project-only` | Solo información del proyecto | `./devTools status --project-only` |
| `--processes-only` | Solo procesos en ejecución | `./devTools status --processes-only` |
| `--docker-only` | Solo estado de Docker | `./devTools status --docker-only` |
| `--git-only` | Solo estado de Git | `./devTools status --git-only` |

### Opciones de Formato
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--no-color` | Desactivar colores | `./devTools status --no-color` |
| `--no-icons` | Desactivar iconos | `./devTools status --no-icons` |
| `--compact` | Vista compacta | `./devTools status --compact` |
| `--table` | Vista en formato tabla | `./devTools status --table` |

## 📊 Tipos de Estado

### 🖥️ Estado del Sistema
```bash
# Información completa del sistema
./devTools status --system-only --verbose
```

**Métricas Monitoreadas:**
- 🔄 **CPU**: Uso actual, procesos principales
- 💾 **Memoria**: RAM, swap, buffers
- 💿 **Disco**: Espacio libre, I/O, particiones
- 🌐 **Red**: Interfaces, tráfico, conectividad
- 🔋 **Batería**: Estado (en laptops)
- 🌡️ **Temperatura**: CPU, GPU (si disponible)

### 📦 Estado del Proyecto
```bash
# Información específica del proyecto
./devTools status --project-only
```

**Información del Proyecto:**
- 📁 **Tipo**: React, Node.js, Python, etc.
- 📦 **Dependencias**: Instaladas, desactualizadas, vulnerables
- 🏗️ **Build**: Estado del último build, errores
- ⚙️ **Configuración**: Archivos de config válidos
- 🧪 **Testing**: Estado de tests, cobertura

### 🔄 Procesos Activos
```bash
# Procesos de desarrollo activos
./devTools status --processes-only
```

**Procesos Monitoreados:**
- 🚀 **Servidores de Desarrollo**: React, Vue, Angular
- 🗃️ **Bases de Datos**: PostgreSQL, MySQL, MongoDB
- 🐳 **Docker**: Contenedores en ejecución
- 🔧 **Herramientas**: TypeScript compiler, bundlers
- 🌐 **APIs**: Servicios backend activos

### 🐳 Estado de Docker
```bash
# Estado completo de Docker
./devTools status --docker-only --verbose
```

**Información de Docker:**
- 📦 **Contenedores**: En ejecución, detenidos, salud
- 🖼️ **Imágenes**: Locales, tamaño, últimas usadas
- 🗄️ **Volúmenes**: Montados, espacio usado
- 🌐 **Redes**: Configuradas, conexiones activas

## 📋 Ejemplo de Salida

```bash
$ ./devTools status

📊 DevTools Status - Estado del Sistema
=======================================

⏰ 2024-01-15 14:45:22 | 🖥️ Ubuntu 22.04 | 👤 usuario

🖥️  SISTEMA
===========
🔄 CPU: Intel i7-12700K @ 3.6GHz
   📊 Uso: 23% (4 núcleos activos)
   🔥 Temp: 45°C
   
💾 Memoria: 32GB DDR4
   📊 Uso: 12.4GB / 32GB (39%)
   🔄 Swap: 0GB / 8GB (0%)
   
💿 Disco: NVMe SSD 1TB
   📊 Libre: 342GB / 1TB (34%)
   ⚡ I/O: 45 MB/s lectura, 23 MB/s escritura
   
🌐 Red: WiFi - 802.11ac
   📡 Estado: Conectado (85% señal)
   🔄 Tráfico: ↓ 2.3 MB/s ↑ 0.8 MB/s

📦 PROYECTO: mi-react-app
========================
📁 Tipo: React + TypeScript + Vite
📍 Ruta: /home/usuario/proyectos/mi-react-app
📊 Tamaño: 145 MB (sin node_modules)

📦 Dependencias:
   ✅ 847 paquetes instalados
   ⚠️  3 vulnerabilidades menores
   🔄 2 actualizaciones disponibles
   
🏗️  Build:
   ✅ Último build: exitoso (hace 2h)
   📊 Tamaño: 2.3 MB comprimido
   ⚡ Tiempo: 12.4s
   
⚙️  Configuración:
   ✅ tsconfig.json válido
   ✅ vite.config.ts válido
   ✅ .eslintrc.js válido
   ❌ jest.config.js no encontrado

🔄 PROCESOS ACTIVOS
==================
🚀 Servidores de Desarrollo:
   ✅ Vite Dev Server - http://localhost:3000 (PID: 12345)
   ✅ Storybook - http://localhost:6006 (PID: 12678)
   
🗃️  Bases de Datos:
   ✅ PostgreSQL - puerto 5432 (PID: 8901)
   ❌ Redis - no ejecutándose
   
🔧 Herramientas:
   ✅ TypeScript Compiler (watch mode) (PID: 13456)
   ✅ ESLint (cache activo)

📝 GIT
======
🌿 Branch: feature/user-dashboard
📊 Estado: 
   📄 3 archivos modificados
   ➕ 2 archivos agregados
   ❌ 0 archivos eliminados
   
🔄 Commits:
   📈 5 commits adelante de origin/main
   📉 2 commits detrás de origin/main
   
👥 Remotes:
   ✅ origin: git@github.com:usuario/mi-react-app.git

🐳 DOCKER
=========
🏃 Contenedores En Ejecución:
   ✅ postgres-dev (5432:5432) - saludable
   ✅ redis-cache (6379:6379) - saludable
   
🖼️  Imágenes Locales: 8 imágenes (3.2 GB)
🗄️  Volúmenes Activos: 3 volúmenes (456 MB)
🌐 Redes: bridge, mi-react-app_default

🌐 CONECTIVIDAD
===============
✅ Internet: Conectado
✅ GitHub: Accesible (142ms)
✅ npm registry: Accesible (89ms)
✅ Docker Hub: Accesible (234ms)
⚠️  API de producción: Timeout (api.miapp.com)

📊 RESUMEN
==========
✅ Estado general: Saludable
⚠️  Advertencias: 3 menores
❌ Errores críticos: 0
🔄 Procesos activos: 6
💾 Memoria disponible: 19.6GB
🚀 Rendimiento: Óptimo

💡 RECOMENDACIONES:
1. Actualizar 2 dependencias con vulnerabilidades
2. Configurar jest.config.js para testing
3. Verificar conectividad con API de producción
4. Considerar limpiar imágenes Docker antiguas
```

## 🔍 Modo Watch (Tiempo Real)

```bash
# Monitoreo continuo
./devTools status --watch
```

**Características del Modo Watch:**
- 🔄 Actualización automática cada 5 segundos
- 📊 Gráficos en tiempo real de CPU y memoria
- 🚨 Alertas automáticas para problemas críticos
- ⌨️ Controles de teclado para navegación
- 💾 Historial de métricas para tendencias

**Controles de Teclado:**
- `q` - Salir del modo watch
- `r` - Refrescar manualmente
- `p` - Pausar/reanudar actualización
- `s` - Guardar snapshot actual
- `h` - Mostrar ayuda

## 🚨 Códigos de Salida

| Código | Significado | Descripción |
|--------|-------------|-------------|
| `0` | ✅ Saludable | Sistema y proyecto en estado óptimo |
| `1` | ⚠️ Advertencias | Estado funcional con recomendaciones |
| `2` | ❌ Problemas | Problemas que requieren atención |
| `3` | 🚫 Crítico | Problemas críticos que impiden desarrollo |

## 🎯 Casos de Uso Comunes

### 🔍 Diagnóstico Rápido
```bash
# Ver estado general rápidamente
./devTools status --brief

# Solo verificar si los servicios están ejecutándose
./devTools status --processes-only
```

### 🔧 Debugging de Rendimiento
```bash
# Monitorear recursos durante desarrollo
./devTools status --watch --system-only

# Exportar métricas para análisis
./devTools status --json --export metrics.json
```

### 🚀 Verificación de Deploy
```bash
# Antes de hacer deploy, verificar estado
./devTools status --project-only --verbose

# Verificar que servicios necesarios están activos
./devTools status --processes-only --docker-only
```

### 📊 Reportes Automatizados
```bash
# Generar reporte diario
./devTools status --verbose > "status-$(date +%Y%m%d).log"

# Reporte en JSON para processing
./devTools status --json > status.json
```

## 🔧 Personalización

### Variables de Entorno
```bash
# Configurar intervalo de actualización en modo watch
export DEVTOOLS_STATUS_INTERVAL=3

# Definir umbrales de alerta
export DEVTOOLS_CPU_WARNING=80
export DEVTOOLS_MEMORY_WARNING=85
export DEVTOOLS_DISK_WARNING=90

# Configurar métricas a mostrar
export DEVTOOLS_SHOW_TEMPERATURE=true
export DEVTOOLS_SHOW_NETWORK=true
```

### Archivo de Configuración
```json
// .devtools.json
{
  "status": {
    "refreshInterval": 5,
    "showSystemInfo": true,
    "showProjectInfo": true,
    "showProcesses": true,
    "showDocker": true,
    "showGit": true,
    "alerts": {
      "cpuThreshold": 80,
      "memoryThreshold": 85,
      "diskThreshold": 90
    },
    "customMetrics": [
      "scripts/custom-metrics.sh"
    ]
  }
}
```

## 📈 Métricas Personalizadas

### Script de Métrica Personalizada
```bash
# scripts/custom-metrics.sh
#!/bin/bash

echo "🔧 MÉTRICAS PERSONALIZADAS"
echo "========================="

# Verificar API personalizada
if curl -s http://localhost:8080/health > /dev/null; then
    echo "✅ API Backend: Activa"
else
    echo "❌ API Backend: No disponible"
fi

# Verificar base de datos
if pg_isready -h localhost -p 5432 > /dev/null 2>&1; then
    echo "✅ PostgreSQL: Conectado"
else
    echo "❌ PostgreSQL: No disponible"
fi

# Métricas de testing
if [ -f "coverage/lcov.info" ]; then
    coverage=$(grep -o "SF:" coverage/lcov.info | wc -l)
    echo "📊 Cobertura de Tests: ${coverage} archivos"
fi
```

## 💡 Tips y Trucos

### 🚀 Aliases Útiles
```bash
# Crear aliases para uso frecuente
alias dts='./devTools status'
alias dtsw='./devTools status --watch'
alias dtsb='./devTools status --brief'
alias dtsp='./devTools status --project-only'
```

### 📊 Dashboard Personalizado
```bash
# Crear dashboard simple
watch -n 2 './devTools status --brief --no-color'

# Dashboard con múltiples ventanas (tmux)
tmux new-session -d './devTools status --watch'
tmux split-window -h 'htop'
tmux split-window -v 'docker stats'
tmux attach
```

### 🔄 Automatización
```bash
# Script de monitoreo automático
#!/bin/bash
# monitor.sh

while true; do
    status=$(./devTools status --json)
    
    # Verificar estado crítico
    if echo "$status" | jq -r '.exitCode' | grep -q "3"; then
        echo "🚨 Estado crítico detectado!" | mail -s "Alerta DevTools" admin@ejemplo.com
    fi
    
    sleep 300  # Verificar cada 5 minutos
done
```

## 🔄 Integración con Herramientas

### Grafana/Prometheus
```bash
# Exportar métricas para Grafana
./devTools status --json | jq '{
  cpu_usage: .system.cpu.usage,
  memory_usage: .system.memory.usage,
  disk_usage: .system.disk.usage
}' > metrics.json
```

### Scripts de CI/CD
```bash
# En pipeline: verificar que servicios estén listos
./devTools status --processes-only --json | jq -r '.processes.servers[] | select(.status != "running") | .name'

if [ $? -eq 0 ]; then
    echo "❌ Algunos servicios no están ejecutándose"
    exit 1
fi
```

### Slack/Discord Notifications
```bash
# Notificar estado en Slack
status_brief=$(./devTools status --brief --no-color)
curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"📊 Estado del proyecto:\n\`\`\`$status_brief\`\`\`\"}" \
    $SLACK_WEBHOOK_URL
```

---

> 💡 **Tip**: Usa `status --watch` durante sesiones de desarrollo intenso para monitorear recursos en tiempo real.
