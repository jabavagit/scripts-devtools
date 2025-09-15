# 🔧 Script Managers - Sistema Centralizado de Scripts

Este proyecto utiliza un sistema de **managers centralizados** para organizar y simplificar la gestión de scripts. En lugar de tener 40+ comandos individuales en `package.json`, ahora tenemos 4 managers principales que agrupan funcionalidades relacionadas.

## 📋 Managers Disponibles

### 🔄 Git Manager (`npm run git:man`)

Gestiona todos los flujos de trabajo relacionados con Git:

- **Flujo de trabajo:** `save`, `sync`, `status`, `clean`, `stash`
- **Gestión de ramas:** `feature`, `merge`, `switch`, `delete`
- **Información:** `log`, `diff`, `branches`, `remotes`
- **Utilidades:** `setup`, `hooks`, `config`

### 📚 Docs Manager (`npm run docs:man`)

Administra toda la documentación y Docusaurus:

- **Desarrollo:** `dev`, `start`, `create`, `validate`
- **Build:** `build`, `build:github`, `build:clean`, `deploy`
- **Análisis:** `status`, `stats`, `broken`, `outdated`
- **Utilidades:** `setup`, `clean`, `update`, `backup`

### ⚡ Performance Manager (`npm run perf:man`)

Maneja métricas y análisis de rendimiento:

- **Benchmarks:** `benchmark`, `quick`, `detailed`, `compare`
- **Análisis:** `analyze`, `bundle`, `lighthouse`, `memory`
- **Reportes:** `report`, `history`, `trends`, `dashboard`
- **Utilidades:** `setup`, `clean`, `watch`, `profile`

### 🔌 Port Manager (`npm run port:man`)

Gestiona puertos y procesos de desarrollo:

- **Consulta:** `status`, `check`, `list`, `dev`
- **Gestión:** `kill`, `killall`, `cleanup`, `restart`
- **Desarrollo:** `free`, `next`, `docs`
- **Utilidades:** `find`, `monitor`, `scan`

## 🚀 Uso Rápido

```bash
# Ver ayuda de cualquier manager
npm run git:man help
npm run docs:man help
npm run perf:man help
npm run port:man help

# O simplemente ejecutar sin argumentos
npm run git:man
npm run docs:man
npm run perf:man
npm run port:man
```

## 📖 Ejemplos de Uso

### Git Workflow

```bash
# Guardar cambios con mensaje automático
npm run git:man save "feat: nueva funcionalidad"

# Sincronizar con remote
npm run git:man sync

# Ver estado detallado
npm run git:man status

# Crear nueva feature branch
npm run git:man feature mi-nueva-feature

# Mergear a develop
npm run git:man merge
```

### Documentación

```bash
# Servidor de desarrollo
npm run docs:man dev

# Build para producción
npm run docs:man build

# Crear nuevo documento
npm run docs:man create doc api/usuarios

# Ver estadísticas
npm run docs:man stats
```

### Performance

```bash
# Benchmark completo
npm run perf:man benchmark

# Métricas rápidas
npm run perf:man quick

# Análisis de bundle
npm run perf:man bundle

# Monitor en tiempo real
npm run perf:man watch
```

### Gestión de Puertos

```bash
# Ver estado de puertos
npm run port:man status

# Liberar puerto específico
npm run port:man kill 3000

# Liberar puertos comunes
npm run port:man free

# Ver procesos de desarrollo
npm run port:man dev
```

## 🗂️ Estructura de Scripts

```
scripts/
├── git-manager.sh          # Manager principal de Git
├── docs-manager.sh         # Manager principal de Docs
├── performance-manager.sh  # Manager principal de Performance
├── git/
│   ├── git-workflow.sh     # Scripts específicos de Git
│   ├── new-feature.sh
│   └── merge-to-develop.sh
├── docs/
│   └── generate-docs.sh    # Scripts específicos de Docs
├── performance/
│   └── performance-benchmark.sh  # Scripts específicos de Performance
└── port/
    └── port-manager.sh     # Manager de puertos
```

## 🎯 Ventajas del Sistema

### ✅ Simplicidad

- **Antes:** 40+ comandos en package.json
- **Ahora:** 4 managers principales + comandos específicos

### ✅ Organización

- Scripts agrupados por funcionalidad
- Estructura de carpetas clara
- Fácil mantenimiento

### ✅ Discoverable

- Sistema de ayuda integrado
- Comandos auto-descriptivos
- Ejemplos incluidos

### ✅ Escalable

- Fácil agregar nuevos comandos
- Managers independientes
- Sin duplicación de código

## 🔧 Migración desde Scripts Antiguos

Los comandos antiguos han sido reorganizados:

| Comando Anterior         | Comando Nuevo                |
| ------------------------ | ---------------------------- |
| `npm run git:save`       | `npm run git:man save`       |
| `npm run docs:dev`       | `npm run docs:man dev`       |
| `npm run perf:benchmark` | `npm run perf:man benchmark` |
| `npm run port:status`    | `npm run port:man status`    |

## 📝 Agregando Nuevos Comandos

Para agregar un nuevo comando a un manager:

1. **Editar el manager correspondiente** (ej: `git-manager.sh`)
2. **Agregar la función** en el script
3. **Actualizar la ayuda** en `show_help()`
4. **Agregar el case** en la función `main()`

### Ejemplo:

```bash
# En git-manager.sh
git_new_command() {
    echo "Ejecutando nuevo comando..."
}

# En main()
case "${1:-help}" in
    "new-command")
        git_new_command
        ;;
```

## 🐛 Troubleshooting

### Scripts no ejecutables

```bash
chmod +x scripts/*.sh scripts/*/*.sh
```

### Manager no funciona

```bash
# Verificar que el manager existe y es ejecutable
ls -la scripts/git-manager.sh

# Ejecutar directamente para ver errores
./scripts/git-manager.sh help
```

### Comandos antiguos

Los comandos antiguos fueron removidos del `package.json`. Usa los nuevos managers o agrega comandos específicos si es necesario.

---

_Sistema de Script Managers creado para mejorar la experiencia de desarrollo y mantenibilidad del proyecto._
