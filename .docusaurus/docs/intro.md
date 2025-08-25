# 🛠️ DevTools Suite

Una suite completa de herramientas de desarrollo diseñada para automatizar y simplificar flujos de trabajo comunes de desarrollo. Esta colección de scripts shell modulares proporciona comandos útiles para verificación de proyectos, configuración, limpieza, estado del sistema, actualizaciones y gestión de puertos.

## � Arquitectura del Proyecto

La suite DevTools sigue una arquitectura modular bien organizada que separa responsabilidades y facilita el mantenimiento:

```
scripts-devtools/
├── devTools                    # 🎯 Script principal (punto de entrada)
├── lib/                        # 📚 Librerías compartidas
│   ├── colors.sh              # 🌈 Sistema de colores inteligente
│   ├── loggers.sh             # 📝 Sistema de logging unificado
│   └── icons.sh               # 🎨 Gestión de iconos UTF-8/ASCII
├── commands/                   # ⚡ Implementación de comandos
│   ├── verify.sh              # 🔍 Verificación de proyectos
│   ├── setup.sh               # ⚙️ Configuración automática
│   ├── clean.sh               # 🧹 Limpieza del sistema
│   ├── status.sh              # 📊 Estado del sistema
│   ├── update.sh              # 🔄 Actualizaciones
│   └── ports.sh               # 🌐 Gestión de puertos
└── .docusaurus/               # � Documentación del proyecto
    └── docs/                  # 📄 Archivos de documentación
        ├── intro.md           # 🏠 Introducción general
        ├── architecture/      # 🏗️ Documentación de arquitectura
        ├── lib/              # 📚 Documentación de librerías
        └── commands/         # ⚡ Documentación de comandos
```

## 🎯 Componentes Principales

### 🎯 Script Principal (`devTools`)
El punto de entrada único que:
- Carga las librerías compartidas
- Procesa argumentos globales
- Delega a los comandos específicos
- Maneja ayuda y versiones

### 📚 Librerías Compartidas (`lib/`)
Módulos reutilizables que proporcionan:
- **Sistema de Colores**: Detección automática de capacidades del terminal
- **Sistema de Logging**: Logging unificado con niveles y formato
- **Gestión de Iconos**: Iconos UTF-8 con fallback ASCII

### ⚡ Comandos (`commands/`)
Implementaciones modulares de funcionalidades específicas:
- **Verify**: Análisis y verificación de proyectos
- **Setup**: Configuración automática de entornos
- **Clean**: Limpieza de archivos temporales
- **Status**: Monitoreo del sistema en tiempo real
- **Update**: Gestión de actualizaciones
- **Ports**: Control de puertos y procesos

## 🚀 Características Principales

- **🔍 Verificación de Proyectos**: Análisis completo de estructura, dependencias y configuración
- **⚙️ Configuración Automática**: Setup inteligente con detección de tipos de proyecto
- **🧹 Limpieza del Sistema**: Eliminación segura de archivos temporales y cachés
- **📊 Estado del Sistema**: Monitoreo en tiempo real de procesos y recursos
- **🔄 Actualizaciones**: Gestión automatizada de dependencias con parches de seguridad
- **🌐 Gestión de Puertos**: Control completo de puertos ocupados y procesos asociados

## 🎨 Interfaz Visual Avanzada

### 🌈 Sistema de Colores Inteligente
- **Detección Automática**: Adapta colores según las capacidades del terminal
- **Colores Semánticos**: Estados diferenciados por color (éxito, error, advertencia)
- **Themes**: Soporte para temas oscuros y claros
- **Fallback**: Degradación elegante en terminales sin color

### 🎯 Iconos con Fallback ASCII
- **UTF-8 Inteligente**: Detección automática de soporte UTF-8
- **Iconos Contextuales**: Iconos específicos para cada tipo de operación
- **ASCII Fallback**: Texto descriptivo en terminales sin UTF-8
- **Personalización**: Sistema extensible para iconos personalizados

### 📝 Sistema de Logging Unificado
- **Niveles de Log**: DEBUG, INFO, SUCCESS, WARNING, ERROR, CRITICAL
- **Formato Consistente**: Timestamps, prefijos y colores unificados
- **Logging a Archivo**: Persistencia opcional de logs
- **Progreso Visual**: Barras de progreso y spinners

## 🔧 Comandos Disponibles

| Comando | Archivo | Descripción | Icono |
|---------|---------|-------------|-------|
| `verify` | `commands/verify.sh` | Verifica estructura y configuración del proyecto | 🔍 |
| `setup` | `commands/setup.sh` | Configura automáticamente el entorno de desarrollo | ⚙️ |
| `clean` | `commands/clean.sh` | Limpia archivos temporales y cachés del sistema | 🧹 |
| `status` | `commands/status.sh` | Muestra el estado actual del sistema y procesos | 📊 |
| `update` | `commands/update.sh` | Actualiza dependencias y herramientas de desarrollo | 🔄 |
| `ports` | `commands/ports.sh` | Gestiona puertos ocupados y procesos asociados | 🌐 |

## 🚀 Inicio Rápido

### Instalación y Configuración
```bash
# Clonar y configurar DevTools
git clone <repository-url> scripts-devtools
cd scripts-devtools

# Hacer ejecutable el script principal
chmod +x devTools

# Verificar instalación
./devTools --help
```

### Primer Uso
```bash
# 1. Verificar proyecto actual
./devTools verify

# 2. Configurar entorno de desarrollo
./devTools setup

# 3. Ver estado del sistema
./devTools status

# 4. Verificar puertos disponibles
./devTools ports
```

## 🌟 Características Avanzadas

### 🤖 Detección Automática
- **Tipos de Proyecto**: React, Node.js, Vue, Angular, Python automáticamente
- **Gestores de Paquetes**: npm, yarn, pnpm según archivos lock
- **Capacidades del Terminal**: Colores, UTF-8, ancho de pantalla

### 🔧 Configuración Personalizable
- **Variables de Entorno**: Control completo via `DEVTOOLS_*`
- **Archivos de Config**: `.devtools.json` para configuración persistente
- **Hooks Personalizados**: Scripts pre/post para cada comando

### 🚀 Rendimiento Optimizado
- **Carga Lazy**: Librerías cargadas solo cuando se necesitan
- **Cache Inteligente**: Evita verificaciones redundantes
- **Ejecución Paralela**: Operaciones optimizadas para velocidad

## 🎯 Casos de Uso Típicos

### 🔄 Flujo de Desarrollo Diario
```bash
# Rutina matutina de desarrollo
./devTools verify          # Verificar estado del proyecto
./devTools clean           # Limpiar cachés obsoletos
./devTools status --brief  # Ver estado del sistema
./devTools ports           # Verificar puertos disponibles
```

### 🚨 Resolución de Problemas
```bash
# Cuando algo no funciona
./devTools verify --verbose      # Diagnóstico detallado
./devTools clean --all           # Limpieza completa
./devTools setup --force         # Reconfiguración forzada
./devTools ports --kill-node     # Limpiar procesos colgados
```

### 🔄 Mantenimiento Semanal
```bash
# Mantenimiento proactivo
./devTools update --check-only   # Verificar actualizaciones
./devTools update --security-only # Parches de seguridad
./devTools clean --all           # Limpieza profunda
./devTools verify               # Verificación final
```

## 🤝 Extensibilidad

DevTools está diseñado para ser fácilmente extensible:

### Agregar Nuevos Comandos
1. Crear `commands/nuevo-comando.sh`
2. Implementar función `cmd_nuevo_comando()`
3. Agregar case en `devTools` principal
4. Documentar en `.docusaurus/docs/commands/`

### Personalizar Librerías
1. Modificar `lib/colors.sh` para nuevos colores
2. Extender `lib/icons.sh` con iconos personalizados
3. Añadir funciones en `lib/loggers.sh` para nuevo formato

## 📚 Documentación Detallada

### 🏗️ Arquitectura
- [📋 Visión General](./architecture/overview.md)
- [🎯 Script Principal](./architecture/main-script.md)
- [📚 Sistema de Librerías](./architecture/libraries.md)

### 📚 Librerías
- [🌈 Sistema de Colores](./lib/colors.md)
- [📝 Sistema de Logging](./lib/loggers.md)
- [🎨 Gestión de Iconos](./lib/icons.md)

### ⚡ Comandos
- [🔍 Comando Verify](./commands/verify.md)
- [⚙️ Comando Setup](./commands/setup.md)
- [🧹 Comando Clean](./commands/clean.md)
- [📊 Comando Status](./commands/status.md)
- [🔄 Comando Update](./commands/update.md)
- [🌐 Comando Ports](./commands/ports.md)

---

> 💡 **Tip**: Explora la documentación específica de cada componente para entender en detalle su funcionamiento y opciones de personalización.
