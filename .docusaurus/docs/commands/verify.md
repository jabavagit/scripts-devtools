# 🔍 Comando Verify

El comando `verify` realiza un análisis completo de la estructura y configuración del proyecto actual, verificando dependencias, configuraciones y estado general del desarrollo.

## 🎯 Descripción

`verify` es el comando de diagnóstico principal de DevTools. Examina el proyecto actual y proporciona un informe detallado sobre:

- ✅ **Estructura del Proyecto**: Verifica archivos y directorios esenciales
- 📦 **Dependencias**: Analiza package.json, requirements.txt, etc.
- ⚙️ **Configuraciones**: Revisa archivos de configuración críticos
- 🔧 **Herramientas**: Verifica disponibilidad de herramientas de desarrollo
- 🌐 **Estado de Red**: Comprueba conectividad y puertos

## 🚀 Uso

```bash
# Verificación básica del proyecto
./devTools verify

# Verificación detallada con información adicional
./devTools verify --verbose

# Verificación silenciosa (solo errores)
./devTools verify --quiet

# Verificar proyecto específico
./devTools verify --path /ruta/al/proyecto

# Verificar solo dependencias
./devTools verify --deps-only
```

## 🎨 Opciones Disponibles

### Opciones Principales
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--verbose` | Salida detallada con información adicional | `./devTools verify --verbose` |
| `--quiet` | Salida mínima, solo errores críticos | `./devTools verify --quiet` |
| `--path <dir>` | Verificar proyecto en ruta específica | `./devTools verify --path ../mi-proyecto` |
| `--deps-only` | Verificar solo dependencias | `./devTools verify --deps-only` |
| `--config-only` | Verificar solo configuraciones | `./devTools verify --config-only` |

### Opciones de Filtrado
| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `--no-network` | Omitir verificaciones de red | `./devTools verify --no-network` |
| `--skip-tools` | Omitir verificación de herramientas | `./devTools verify --skip-tools` |
| `--fast` | Verificación rápida (omite chequeos lentos) | `./devTools verify --fast` |

## 📊 Tipos de Verificación

### 🏗️ Estructura del Proyecto
```bash
# Verifica la presencia de archivos esenciales
./devTools verify --check-structure
```

**Archivos Verificados:**
- `package.json` / `requirements.txt` / `Cargo.toml`
- `README.md`
- `.gitignore`
- Archivos de configuración específicos del framework

### 📦 Dependencias
```bash
# Análisis completo de dependencias
./devTools verify --deps-only --verbose
```

**Verificaciones Realizadas:**
- ✅ Dependencias instaladas vs declaradas
- 🔄 Versiones obsoletas o vulnerables
- 🚫 Dependencias faltantes
- 📊 Tamaño total de node_modules

### ⚙️ Configuraciones
```bash
# Verificación de archivos de configuración
./devTools verify --config-only
```

**Configuraciones Analizadas:**
- `tsconfig.json` / `jsconfig.json`
- `.eslintrc.*` / `prettier.config.*`
- `vite.config.*` / `webpack.config.*`
- Variables de entorno (`.env*`)

### 🔧 Herramientas de Desarrollo
```bash
# Verificación de herramientas disponibles
./devTools verify --tools-only
```

**Herramientas Verificadas:**
- Node.js / npm / yarn / pnpm
- Git / GitHub CLI
- Docker / Docker Compose
- Herramientas específicas del proyecto

## 📋 Ejemplo de Salida

```bash
$ ./devTools verify

🔍 DevTools Verify - Análisis del Proyecto
==========================================

📁 Proyecto: mi-react-app
📍 Ruta: /home/usuario/proyectos/mi-react-app
⏰ Inicio: 2024-01-15 14:30:15

🏗️  ESTRUCTURA DEL PROYECTO
✅ package.json encontrado
✅ README.md encontrado  
✅ .gitignore encontrado
⚠️  LICENSE no encontrado
✅ src/ directorio presente
✅ public/ directorio presente

📦 DEPENDENCIAS
✅ React 18.2.0 (actualizado)
✅ TypeScript 4.9.5 (actualizado)
⚠️  @types/react 18.0.26 (nueva versión disponible: 18.0.28)
❌ lodash tiene vulnerabilidades conocidas
✅ 847 dependencias instaladas correctamente

⚙️  CONFIGURACIONES
✅ tsconfig.json válido
✅ .eslintrc.js válido
❌ prettier.config.js no encontrado
✅ vite.config.ts válido

🔧 HERRAMIENTAS
✅ Node.js v18.17.0
✅ npm v9.6.7
✅ Git v2.40.1
❌ Docker no instalado

🌐 CONECTIVIDAD
✅ Conexión a internet activa
✅ npm registry accesible
✅ GitHub accesible

📊 RESUMEN
==========================================
✅ Verificaciones exitosas: 15
⚠️  Advertencias: 2
❌ Errores: 3
🕒 Tiempo total: 3.2 segundos

🔧 ACCIONES RECOMENDADAS:
1. Actualizar @types/react: npm update @types/react
2. Revisar vulnerabilidades: npm audit fix
3. Agregar prettier.config.js
4. Considerar instalar Docker para desarrollo
```

## 🚨 Códigos de Salida

| Código | Significado | Descripción |
|--------|-------------|-------------|
| `0` | ✅ Éxito | Proyecto verificado sin problemas críticos |
| `1` | ⚠️ Advertencias | Proyecto funcional pero con recomendaciones |
| `2` | ❌ Errores | Problemas que pueden afectar el desarrollo |
| `3` | 🚫 Crítico | Errores graves que impiden el desarrollo |

## 🎯 Casos de Uso Comunes

### 📋 Verificación de Proyecto Nuevo
```bash
# Al clonar un repositorio
git clone <repo-url> mi-proyecto
cd mi-proyecto
./devTools verify

# Si hay problemas, usar setup para resolverlos
./devTools setup
```

### 🔄 Verificación Periódica
```bash
# Verificación diaria rápida
./devTools verify --fast

# Verificación semanal completa
./devTools verify --verbose
```

### 🐛 Debugging de Problemas
```bash
# Cuando algo no funciona
./devTools verify --verbose > verify-report.txt

# Verificar específicamente dependencias
./devTools verify --deps-only --verbose
```

### 🤖 Integración en CI/CD
```bash
# En pipeline de CI
./devTools verify --quiet --no-network
if [ $? -ne 0 ]; then
    echo "❌ Verificación falló"
    exit 1
fi
```

## 🔧 Personalización

### Variables de Entorno
```bash
# Configurar timeout para verificaciones de red
export DEVTOOLS_NETWORK_TIMEOUT=10

# Omitir verificaciones específicas
export DEVTOOLS_SKIP_DOCKER=true
export DEVTOOLS_SKIP_LINT=true

# Configurar nivel de verbosidad por defecto
export DEVTOOLS_VERIFY_VERBOSE=true
```

### Archivos de Configuración
```json
// .devtools.json
{
  "verify": {
    "skipNetworkChecks": false,
    "skipToolChecks": false,
    "timeout": 30,
    "customChecks": [
      "scripts/custom-verify.sh"
    ]
  }
}
```

## 💡 Tips y Trucos

### 🚀 Verificación Rápida
```bash
# Alias útil para verificación rápida
alias dvf='./devTools verify --fast'
alias dvv='./devTools verify --verbose'
```

### 📊 Reportes Automatizados
```bash
# Generar reporte diario
./devTools verify --verbose > "verify-$(date +%Y%m%d).log"

# Comparar con verificación anterior
./devTools verify --verbose > current.log
diff previous.log current.log
```

### 🔍 Verificación Selectiva
```bash
# Solo verificar lo que necesitas
./devTools verify --deps-only --config-only --fast
```

## 🤝 Extensibilidad

### Agregando Verificaciones Personalizadas
```bash
# Crear script personalizado
cat > scripts/verify-custom.sh << 'EOF'
#!/bin/bash
# Verificación personalizada para mi proyecto

echo "🔍 Verificando configuración personalizada..."

# Tu lógica aquí
if [ -f "mi-config.json" ]; then
    echo "✅ mi-config.json encontrado"
else
    echo "❌ mi-config.json no encontrado"
    return 1
fi
EOF

chmod +x scripts/verify-custom.sh
```

### Configuración en .devtools.json
```json
{
  "verify": {
    "customChecks": [
      "scripts/verify-custom.sh",
      "scripts/verify-database.sh"
    ]
  }
}
```

---

> 💡 **Tip**: Usa `verify` antes de empezar cualquier trabajo de desarrollo para asegurar que tu entorno está listo.
