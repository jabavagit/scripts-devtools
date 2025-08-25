# 🌐 Comando Ports

El comando `ports` proporciona gestión completa de puertos del sistema, permitiendo verificar puertos ocupados, identificar procesos y liberar puertos bloqueados.

## 🎯 Descripción

`ports` es el comando de gestión de puertos de DevTools. Ofrece control total sobre los puertos del sistema y procesos asociados:

- 🔍 **Detección**: Identificar puertos ocupados y procesos asociados
- 📊 **Análisis**: Información detallada de PIDs, comandos y usuarios
- 🔧 **Liberación**: Terminar procesos específicos por puerto o tipo
- 🌐 **Monitoreo**: Vigilancia en tiempo real de puertos críticos
- 🧹 **Limpieza**: Eliminar procesos Node.js zombie o colgados
- 📋 **Reportes**: Exportar información de puertos para análisis

## 🚀 Uso

```bash
# Ver todos los puertos ocupados
./devTools ports

# Verificar puerto específico
./devTools ports --check 3000

# Liberar puerto específico
./devTools ports --kill 3000

# Matar todos los procesos Node.js
./devTools ports --kill-node

# Monitoreo en tiempo real
./devTools ports --watch
```

## 🎨 Opciones Disponibles

### Opciones Principales
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--check <port>` | Verificar estado de puerto específico | `./devTools ports --check 3000` |
| `--kill <port>` | Terminar proceso que usa el puerto | `./devTools ports --kill 3000` |
| `--kill-node` | Terminar todos los procesos Node.js | `./devTools ports --kill-node` |
| `--watch` | Monitoreo continuo en tiempo real | `./devTools ports --watch` |
| `--list` | Listar todos los puertos ocupados | `./devTools ports --list` |

### Opciones de Filtrado
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--range <start-end>` | Verificar rango de puertos | `./devTools ports --range 3000-4000` |
| `--process <name>` | Filtrar por nombre de proceso | `./devTools ports --process node` |
| `--user <username>` | Filtrar por usuario | `./devTools ports --user $(whoami)` |
| `--tcp` | Solo puertos TCP | `./devTools ports --tcp` |
| `--udp` | Solo puertos UDP | `./devTools ports --udp` |

### Opciones de Formato
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--verbose` | Información detallada | `./devTools ports --verbose` |
| `--json` | Salida en formato JSON | `./devTools ports --json` |
| `--table` | Vista en formato tabla | `./devTools ports --table` |
| `--brief` | Vista resumida | `./devTools ports --brief` |
| `--export <file>` | Exportar a archivo | `./devTools ports --export ports.json` |

## 🔍 Tipos de Análisis

### 📊 Listado Completo de Puertos
```bash
# Ver todos los puertos activos
./devTools ports --list --verbose
```

**Información Mostrada:**
- 🌐 **Puerto**: Número de puerto y protocolo
- 🔧 **PID**: ID del proceso
- 📝 **Comando**: Comando que ejecuta el proceso
- 👤 **Usuario**: Usuario propietario del proceso
- ⏰ **Tiempo**: Tiempo de ejecución
- 📍 **Estado**: LISTEN, ESTABLISHED, TIME_WAIT

### 🔍 Verificación de Puerto Específico
```bash
# Analizar puerto específico
./devTools ports --check 3000 --verbose
```

**Detalles del Puerto:**
- ✅ **Estado**: Libre/Ocupado
- 🔧 **Proceso**: Información completa del proceso
- 📊 **Conexiones**: Conexiones activas
- 🌐 **Interfaces**: Interfaces de red asociadas
- 📈 **Estadísticas**: Tráfico y uso

### 🧹 Gestión de Procesos Node.js
```bash
# Limpiar procesos Node.js problemáticos
./devTools ports --kill-node --verbose
```

**Funcionalidades:**
- 🔍 **Detección**: Identifica procesos Node.js activos
- ⚠️ **Análisis**: Detecta procesos zombie o colgados
- 🧹 **Limpieza**: Terminación ordenada vs forzada
- 📊 **Reporte**: Resumen de procesos terminados

## 📋 Ejemplo de Salida

```bash
$ ./devTools ports --list --verbose

🌐 DevTools Ports - Gestión de Puertos
======================================

⏰ 2024-01-15 15:10:45 | 🖥️ Sistema: Ubuntu 22.04

🔍 PUERTOS OCUPADOS (TCP)
========================

Port  PID    Process              User     State      Command
----  ----   -------              ----     -----      -------
22    1234   sshd                root     LISTEN     /usr/sbin/sshd -D
80    5678   nginx               www-data  LISTEN     nginx: master process
443   5678   nginx               www-data  LISTEN     nginx: master process
3000  9123   node                usuario   LISTEN     node server.js
3001  9456   node                usuario   LISTEN     npm run dev
5432  7890   postgres            postgres  LISTEN     /usr/lib/postgresql/14/bin/postgres
6006  9789   node                usuario   LISTEN     npm run storybook
8080  1023   java                usuario   LISTEN     java -jar app.jar

🔍 PUERTOS OCUPADOS (UDP)
========================

Port  PID    Process              User     State      Command
----  ----   -------              ----     -----      -------
53    1111   systemd-resolved    root     LISTEN     /usr/lib/systemd/systemd-resolved
68    2222   NetworkManager      root     LISTEN     /usr/sbin/NetworkManager

📊 ANÁLISIS DETALLADO
====================

🚀 SERVIDORES DE DESARROLLO
Puerto 3000: React Dev Server
  📍 PID: 9123
  👤 Usuario: usuario
  ⏰ Uptime: 2h 34m
  🌐 Interfaz: 0.0.0.0:3000
  📊 Conexiones activas: 3
  🔄 Estado: Saludable

Puerto 3001: Next.js Dev Server  
  📍 PID: 9456
  👤 Usuario: usuario
  ⏰ Uptime: 1h 45m
  🌐 Interfaz: localhost:3001
  📊 Conexiones activas: 1
  🔄 Estado: Saludable

Puerto 6006: Storybook Server
  📍 PID: 9789
  👤 Usuario: usuario
  ⏰ Uptime: 45m
  🌐 Interfaz: 0.0.0.0:6006
  📊 Conexiones activas: 0
  ⚠️  Estado: Sin conexiones

🗃️  BASES DE DATOS
Puerto 5432: PostgreSQL
  📍 PID: 7890
  👤 Usuario: postgres
  ⏰ Uptime: 5d 12h
  🌐 Interfaz: 127.0.0.1:5432
  📊 Conexiones activas: 8
  ✅ Estado: Operacional

🔧 SERVICIOS DEL SISTEMA
Puerto 22: SSH Server
  📍 PID: 1234
  👤 Usuario: root
  ⏰ Uptime: 12d 6h
  🌐 Interfaz: 0.0.0.0:22
  📊 Conexiones activas: 2
  🔒 Estado: Seguro

Puerto 80/443: Nginx Web Server
  📍 PID: 5678
  👤 Usuario: www-data
  ⏰ Uptime: 8d 14h
  🌐 Interfaz: 0.0.0.0:80,443
  📊 Conexiones activas: 45
  🚀 Estado: Alto tráfico

📊 RESUMEN
==========
✅ Puertos TCP activos: 8
✅ Puertos UDP activos: 2
🚀 Servidores de desarrollo: 3
🗃️  Bases de datos: 1
🔧 Servicios sistema: 4
⚠️  Procesos sin conexiones: 1

💡 RECOMENDACIONES:
1. Storybook (6006) sin conexiones - considerar detener
2. Multiple Node.js servers - verificar si todos son necesarios
3. Alto tráfico en Nginx - monitorear rendimiento

🔧 COMANDOS ÚTILES:
  ./devTools ports --kill 6006        # Detener Storybook
  ./devTools ports --check 3000       # Verificar React server
  ./devTools ports --kill-node        # Limpiar procesos Node.js
```

## 🔍 Verificación de Puerto Específico

```bash
$ ./devTools ports --check 3000

🔍 Análisis del Puerto 3000
==========================

✅ ESTADO: OCUPADO
📍 PID: 9123
🔧 Proceso: node server.js
👤 Usuario: usuario
⏰ Iniciado: 2024-01-15 12:36:11 (hace 2h 34m)

🌐 DETALLES DE RED
=================
📡 Protocolo: TCP
🔗 Interfaz: 0.0.0.0:3000 (todas las interfaces)
📊 Estado: LISTEN
🔄 Conexiones activas: 3

📈 CONEXIONES ACTIVAS
====================
192.168.1.100:52341 → localhost:3000 (ESTABLISHED)
192.168.1.100:52342 → localhost:3000 (ESTABLISHED)  
127.0.0.1:52343 → localhost:3000 (ESTABLISHED)

🔧 INFORMACIÓN DEL PROCESO
==========================
💾 Memoria: 145.2 MB
🔄 CPU: 2.3%
📁 Directorio: /home/usuario/mi-proyecto
📝 Comando completo: node server.js --port 3000

🛠️  ACCIONES DISPONIBLES
========================
🔧 Reiniciar proceso: ./devTools ports --restart 3000
🛑 Detener proceso: ./devTools ports --kill 3000
📊 Monitorear: ./devTools ports --watch --port 3000
```

## 🧹 Limpieza de Procesos Node.js

```bash
$ ./devTools ports --kill-node --verbose

🧹 DevTools - Limpieza de Procesos Node.js
==========================================

🔍 DETECTANDO PROCESOS NODE.JS
=============================

PID    Puerto  Uptime  Memoria   CPU   Comando
----   ------  ------  -------   ---   -------
9123   3000    2h34m   145.2MB   2.3%  node server.js
9456   3001    1h45m   89.4MB    1.1%  npm run dev
9789   6006    45m     234.1MB   0.8%  npm run storybook
10234  -       5m      12.3MB    0.0%  node build.js (zombie)
10567  8080    12m     67.8MB    3.2%  node api-server.js

📊 ANÁLISIS DE PROCESOS
======================
✅ Procesos saludables: 4
⚠️  Procesos zombie: 1 (PID: 10234)
🔄 Total procesos Node.js: 5
💾 Memoria total: 548.8 MB

⚠️  PROCESOS PROBLEMÁTICOS DETECTADOS
===================================
🚨 PID 10234: Proceso zombie detectado
   📝 Comando: node build.js
   ⏰ Sin actividad por: 5m
   💾 Memoria: 12.3MB (bloqueada)
   🔧 Acción recomendada: Terminar

❓ CONFIRMACIÓN DE LIMPIEZA
==========================
Los siguientes procesos serán terminados:

🛑 Procesos zombie:
   - PID 10234 (node build.js)

⚠️  ¿Terminar procesos seleccionados? (y/N): y

🔄 EJECUTANDO LIMPIEZA
=====================
🛑 Terminando PID 10234 (node build.js)...
   ✅ SIGTERM enviado
   ⏰ Esperando terminación ordenada... (3s)
   ✅ Proceso terminado exitosamente
   💾 12.3MB de memoria liberada

📊 RESUMEN DE LIMPIEZA
=====================
✅ Procesos terminados: 1
💾 Memoria liberada: 12.3MB
⏰ Tiempo total: 4.2s
🔄 Procesos Node.js restantes: 4

✅ LIMPIEZA COMPLETADA
Los procesos saludables siguen ejecutándose normalmente.
```

## 🚨 Códigos de Salida

| Código | Significado | Descripción |
|--------|-------------|-------------|
| `0` | ✅ Éxito | Operación completada exitosamente |
| `1` | ⚠️ Advertencias | Puerto ocupado o procesos detectados |
| `2` | ❌ Error | Fallos en operaciones de red |
| `3` | 🚫 Crítico | Errores de permisos o sistema |

## 🎯 Casos de Uso Comunes

### 🔍 Diagnóstico de Puerto Bloqueado
```bash
# Verificar por qué el puerto 3000 no está disponible
./devTools ports --check 3000

# Si está ocupado, ver proceso completo
./devTools ports --check 3000 --verbose

# Liberar el puerto si es necesario
./devTools ports --kill 3000
```

### 🧹 Limpieza de Desarrollo
```bash
# Limpiar todos los servidores de desarrollo
./devTools ports --kill-node

# Verificar que los puertos están libres
./devTools ports --range 3000-4000

# Reiniciar desarrollo
npm run dev
```

### 📊 Monitoreo de Sistema
```bash
# Monitorear puertos críticos continuamente
./devTools ports --watch --range 80-443

# Exportar estado actual para análisis
./devTools ports --export ports-$(date +%Y%m%d).json
```

### 🔧 Resolución de Conflictos
```bash
# Ver todos los procesos Node.js en ejecución
./devTools ports --process node --verbose

# Identificar procesos zombie
./devTools ports --kill-node --dry-run

# Limpieza selectiva
./devTools ports --kill-node --interactive
```

## 🔧 Personalización

### Variables de Entorno
```bash
# Configurar puertos por defecto para monitoreo
export DEVTOOLS_MONITOR_PORTS="3000,3001,8080"

# Configurar timeout para terminación de procesos
export DEVTOOLS_KILL_TIMEOUT=10

# Habilitar terminación automática de zombies
export DEVTOOLS_AUTO_KILL_ZOMBIES=true
```

### Archivo de Configuración
```json
// .devtools.json
{
  "ports": {
    "monitorPorts": [3000, 3001, 6006, 8080],
    "autoKillZombies": false,
    "killTimeout": 10,
    "watchInterval": 2,
    "showSystemPorts": false,
    "highlightDevelopmentPorts": true
  }
}
```

## 🤖 Detección Inteligente

### Identificación de Tipos de Proceso
```bash
# DevTools identifica automáticamente:
- 🚀 Servidores de desarrollo (React, Vue, Angular)
- 🗃️ Bases de datos (PostgreSQL, MySQL, MongoDB)
- 🌐 Servidores web (Nginx, Apache)
- 🐳 Contenedores Docker
- 🔧 Herramientas de desarrollo (Webpack, Vite)
```

### Detección de Procesos Problemáticos
```bash
# Identifica automáticamente:
- 🧟 Procesos zombie (sin actividad)
- 💔 Procesos colgados (alto CPU, sin red)
- 🔄 Procesos duplicados (mismo puerto)
- ⚠️ Procesos con memory leaks
```

## 💡 Tips y Trucos

### 🚀 Aliases Útiles
```bash
# Crear aliases para uso frecuente
alias dtp='./devTools ports'
alias dtpk='./devTools ports --kill-node'
alias dtpc='./devTools ports --check'
alias dtpw='./devTools ports --watch'
```

### 🔄 Automatización
```bash
# Script para limpiar puertos antes de desarrollo
#!/bin/bash
# start-dev.sh

echo "🧹 Limpiando puertos de desarrollo..."
./devTools ports --kill-node --force

echo "⏰ Esperando liberación de puertos..."
sleep 2

echo "🚀 Iniciando servidores de desarrollo..."
npm run dev &
npm run storybook &

echo "✅ Desarrollo iniciado"
./devTools ports --range 3000-6010 --brief
```

### 📊 Monitoreo Avanzado
```bash
# Dashboard de puertos en tiempo real
watch -n 1 './devTools ports --brief --no-color'

# Alertas por email cuando puerto crítico se libera
while true; do
    if ! ./devTools ports --check 3000 --quiet; then
        echo "🚨 Puerto 3000 liberado!" | mail -s "Alerta Puerto" admin@ejemplo.com
        break
    fi
    sleep 60
done
```

## 🔄 Integración con Otros Comandos

### Flujo de Desarrollo
```bash
# Secuencia típica para resolver problemas de puertos
./devTools ports --list                    # Ver estado actual
./devTools ports --kill-node              # Limpiar Node.js
./devTools clean --cache-only             # Limpiar cachés
./devTools setup --deps-only              # Reinstalar si necesario
./devTools status --processes-only        # Verificar estado final
```

### Scripts de CI/CD
```bash
# En pipeline: asegurar puertos libres
./devTools ports --kill-node --force || true
./devTools ports --check 3000 --quiet
if [ $? -eq 1 ]; then
    echo "❌ Puerto 3000 aún ocupado"
    exit 1
fi
```

---

> 💡 **Tip**: Usa `ports --watch` durante sesiones intensas de desarrollo para monitorear el uso de puertos en tiempo real.
