/**
 * Script para migrar datos existentes a schema multi-usuario
 * Parte de TASK-A002: Database Schema Extension
 */

import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export async function migrateToMultiUser() {
  console.log("🚀 Iniciando migración a multi-usuario...");

  try {
    // Paso 1: Crear usuario por defecto
    console.log("📝 Creando usuario por defecto...");
    const defaultUser = await prisma.user.upsert({
      where: { email: "admin@calendar.app" },
      update: {},
      create: {
        email: "admin@calendar.app",
        name: "Usuario Administrador",
        emailVerified: new Date(),
      },
    });

    console.log(`✅ Usuario por defecto creado/encontrado: ${defaultUser.id}`);

    // Paso 2: Migrar eventos existentes que no tienen userId
    console.log("📅 Migrando eventos existentes...");
    const eventsToUpdate = await prisma.event.findMany({
      where: { userId: null },
    });

    if (eventsToUpdate.length > 0) {
      const eventCount = await prisma.event.updateMany({
        where: { userId: null },
        data: { userId: defaultUser.id },
      });
      console.log(`✅ Migrados ${eventCount.count} eventos`);
    } else {
      console.log("ℹ️ No se encontraron eventos sin usuario asignado");
    }

    // Paso 3: Migrar tipos de eventos existentes que no tienen userId
    console.log("🏷️ Migrando tipos de eventos existentes...");
    const typesToUpdate = await prisma.eventType.findMany({
      where: { userId: null },
    });

    if (typesToUpdate.length > 0) {
      const typeCount = await prisma.eventType.updateMany({
        where: { userId: null },
        data: { userId: defaultUser.id },
      });
      console.log(`✅ Migrados ${typeCount.count} tipos de eventos`);
    } else {
      console.log("ℹ️ No se encontraron tipos de eventos sin usuario asignado");
    }

    // Paso 4: Verificar migración
    console.log("🔍 Verificando migración...");
    const verification = await verifyMigration(defaultUser.id);

    if (verification.success) {
      console.log("✅ ¡Migración completada exitosamente!");
      console.log(`📊 Resumen:
- Usuario creado: ${defaultUser.email}
- Eventos migrados: ${verification.stats.eventsCount}
- Tipos migrados: ${verification.stats.typesCount}
- Eventos sin usuario: ${verification.stats.eventsWithoutUser}
- Tipos sin usuario: ${verification.stats.typesWithoutUser}`);
    } else {
      throw new Error("La verificación de migración falló");
    }

    return {
      success: true,
      defaultUser,
      stats: verification.stats,
    };
  } catch (error) {
    console.error("❌ Migración falló:", error);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

export async function verifyMigration(userId) {
  try {
    const stats = {
      eventsWithoutUser: await prisma.event.count({
        where: { userId: null },
      }),
      typesWithoutUser: await prisma.eventType.count({
        where: { userId: null },
      }),
      eventsCount: await prisma.event.count({
        where: { userId },
      }),
      typesCount: await prisma.eventType.count({
        where: { userId },
      }),
    };

    const userExists = await prisma.user.findUnique({
      where: { id: userId },
    });

    const success =
      stats.eventsWithoutUser === 0 &&
      stats.typesWithoutUser === 0 &&
      userExists !== null;

    return {
      success,
      stats,
      userExists: !!userExists,
    };
  } catch (error) {
    console.error("❌ Error en verificación:", error);
    return {
      success: false,
      error: error.message,
    };
  }
}

// Función para rollback en caso de problemas
export async function rollbackMigration() {
  console.log("🔄 Iniciando rollback de migración...");

  try {
    // Eliminar usuarios creados durante la migración
    const adminUser = await prisma.user.findUnique({
      where: { email: "admin@calendar.app" },
    });

    if (adminUser) {
      // Primero, hacer null los userId de eventos y tipos
      await prisma.event.updateMany({
        where: { userId: adminUser.id },
        data: { userId: null },
      });

      await prisma.eventType.updateMany({
        where: { userId: adminUser.id },
        data: { userId: null },
      });

      // Luego eliminar el usuario
      await prisma.user.delete({
        where: { id: adminUser.id },
      });

      console.log("✅ Rollback completado");
    }
  } catch (error) {
    console.error("❌ Error en rollback:", error);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

if (process.argv[1] === new URL(import.meta.url).pathname) {
  const command = process.argv[2];

  switch (command) {
    case "migrate":
      migrateToMultiUser().catch(console.error);
      break;
    case "verify":
      // Verificar con el primer usuario encontrado
      prisma.user
        .findFirst()
        .then((user) => {
          if (user) {
            return verifyMigration(user.id);
          } else {
            console.log("❌ No se encontró ningún usuario");
          }
        })
        .then((result) => {
          if (result) {
            console.log("Resultado de verificación:", result);
          }
        })
        .catch(console.error);
      break;
    case "rollback":
      rollbackMigration().catch(console.error);
      break;
    default:
      console.log(
        "Uso: node migrate-to-multiuser.mjs [migrate|verify|rollback]"
      );
  }
}
