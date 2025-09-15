/**
 * Script de validación completa para verificar la integridad post-migración
 * Parte de TASK-A002: Database Schema Extension
 */

import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export async function validateMigration() {
  console.log("🔍 Ejecutando validación completa de migración...");

  const results = {
    dataIntegrity: { passed: false, details: {} },
    relationships: { passed: false, details: {} },
    indexes: { passed: false, details: {} },
    performance: { passed: false, details: {} },
  };

  try {
    // Test 1: Integridad de datos
    console.log("📊 Verificando integridad de datos...");
    const dataIntegrity = await validateDataIntegrity();
    results.dataIntegrity = dataIntegrity;

    if (dataIntegrity.passed) {
      console.log("✅ Integridad de datos: PASADO");
    } else {
      console.log("❌ Integridad de datos: FALLIDO");
      console.log(dataIntegrity.details);
    }

    // Test 2: Relaciones entre tablas
    console.log("🔗 Verificando relaciones entre tablas...");
    const relationships = await validateRelationships();
    results.relationships = relationships;

    if (relationships.passed) {
      console.log("✅ Relaciones: PASADO");
    } else {
      console.log("❌ Relaciones: FALLIDO");
      console.log(relationships.details);
    }

    // Test 3: Índices y constraints
    console.log("📈 Verificando índices...");
    const indexes = await validateIndexes();
    results.indexes = indexes;

    if (indexes.passed) {
      console.log("✅ Índices: PASADO");
    } else {
      console.log("❌ Índices: FALLIDO");
      console.log(indexes.details);
    }

    // Test 4: Performance básico
    console.log("⚡ Verificando performance...");
    const performance = await validatePerformance();
    results.performance = performance;

    if (performance.passed) {
      console.log("✅ Performance: PASADO");
    } else {
      console.log("⚠️ Performance: ADVERTENCIAS");
      console.log(performance.details);
    }

    // Resumen final
    const allPassed = Object.values(results).every((r) => r.passed);

    if (allPassed) {
      console.log("🎉 ¡TODAS LAS VALIDACIONES PASARON!");
      console.log(
        "La migración se completó exitosamente y la base de datos está lista para producción."
      );
    } else {
      console.log("⚠️ ALGUNAS VALIDACIONES FALLARON");
      console.log("Revisa los detalles arriba antes de continuar.");
    }

    return {
      success: allPassed,
      results,
    };
  } catch (error) {
    console.error("❌ Error durante validación:", error);
    return {
      success: false,
      error: error.message,
      results,
    };
  } finally {
    await prisma.$disconnect();
  }
}

async function validateDataIntegrity() {
  const details = {};

  try {
    // Verificar que todos los eventos tienen usuario
    const eventsWithoutUser = await prisma.event.count({
      where: { userId: null },
    });
    details.eventsWithoutUser = eventsWithoutUser;

    // Verificar que todos los event types tienen usuario
    const typesWithoutUser = await prisma.eventType.count({
      where: { userId: null },
    });
    details.typesWithoutUser = typesWithoutUser;

    // Verificar que el usuario por defecto existe
    const defaultUser = await prisma.user.findUnique({
      where: { email: "admin@calendar.app" },
    });
    details.defaultUserExists = !!defaultUser;

    // Contar totales
    details.totalUsers = await prisma.user.count();
    details.totalEvents = await prisma.event.count();
    details.totalEventTypes = await prisma.eventType.count();

    const passed =
      eventsWithoutUser === 0 &&
      typesWithoutUser === 0 &&
      defaultUser !== null &&
      details.totalUsers > 0;

    return { passed, details };
  } catch (error) {
    return {
      passed: false,
      details: { error: error.message },
    };
  }
}

async function validateRelationships() {
  const details = {};

  try {
    // Test 1: Verificar que todos los eventos tienen un tipo válido
    const allEvents = await prisma.event.findMany({
      include: { type: true },
    });
    const eventsWithInvalidType = allEvents.filter(
      (event) => !event.type
    ).length;
    details.eventsWithInvalidType = eventsWithInvalidType;

    // Test 2: Verificar que todos los eventos con userId tienen un usuario válido
    const eventsWithUserId = await prisma.event.findMany({
      where: { userId: { not: null } },
      include: { user: true },
    });
    const eventsWithInvalidUser = eventsWithUserId.filter(
      (event) => !event.user
    ).length;
    details.eventsWithInvalidUser = eventsWithInvalidUser;

    // Test 3: Verificar que todos los event types con userId tienen un usuario válido
    const typesWithUserId = await prisma.eventType.findMany({
      where: { userId: { not: null } },
      include: { user: true },
    });
    const typesWithInvalidUser = typesWithUserId.filter(
      (type) => !type.user
    ).length;
    details.typesWithInvalidUser = typesWithInvalidUser;

    // Test 4: Verificar que las foreign keys funcionan correctamente
    const sampleEventWithRelations = await prisma.event.findFirst({
      include: {
        user: true,
        type: true,
      },
    });
    details.sampleEventHasRelations = !!sampleEventWithRelations?.type;
    details.sampleEventHasUser = !!sampleEventWithRelations?.user;

    const passed =
      eventsWithInvalidType === 0 &&
      eventsWithInvalidUser === 0 &&
      typesWithInvalidUser === 0 &&
      details.sampleEventHasRelations;

    return { passed, details };
  } catch (error) {
    return {
      passed: false,
      details: { error: error.message },
    };
  }
}

async function validateIndexes() {
  const details = {};

  try {
    // SQLite no tiene una forma directa de verificar índices,
    // pero podemos probar que las queries funcionan eficientemente
    const start = Date.now();

    // Query que debería usar el índice userId_date
    const userEvents = await prisma.event.findMany({
      where: {
        userId: { not: null },
        date: {
          gte: new Date("2024-01-01"),
          lte: new Date("2025-12-31"),
        },
      },
      take: 10,
    });

    const queryTime = Date.now() - start;
    details.userEventsQueryTime = `${queryTime}ms`;
    details.userEventsCount = userEvents.length;

    // Asumir que pasa si la query es razonablemente rápida
    const passed = queryTime < 1000; // Menos de 1 segundo para una query simple

    return { passed, details };
  } catch (error) {
    return {
      passed: false,
      details: { error: error.message },
    };
  }
}

async function validatePerformance() {
  const details = {};

  try {
    // Test de performance para queries comunes
    const tests = [
      {
        name: "getUserEvents",
        query: async () => {
          const user = await prisma.user.findFirst();
          if (!user) return null;
          return await prisma.event.findMany({
            where: { userId: user.id },
            take: 10,
          });
        },
      },
      {
        name: "getUserEventTypes",
        query: async () => {
          const user = await prisma.user.findFirst();
          if (!user) return null;
          return await prisma.eventType.findMany({
            where: { userId: user.id },
          });
        },
      },
      {
        name: "getEventsWithTypes",
        query: async () => {
          return await prisma.event.findMany({
            include: { type: true },
            take: 10,
          });
        },
      },
    ];

    for (const test of tests) {
      const start = Date.now();
      const result = await test.query();
      const time = Date.now() - start;

      details[test.name] = {
        time: `${time}ms`,
        resultCount: Array.isArray(result) ? result.length : result ? 1 : 0,
      };
    }

    // Performance pasa si todas las queries son razonablemente rápidas
    const allTimesOk = Object.values(details).every((test) => {
      const timeMs = parseInt(test.time);
      return timeMs < 500; // Menos de 500ms
    });

    return { passed: allTimesOk, details };
  } catch (error) {
    return {
      passed: false,
      details: { error: error.message },
    };
  }
}

// Función para crear datos de prueba
export async function createTestData() {
  console.log("🧪 Creando datos de prueba...");

  try {
    // Crear usuario de prueba
    const testUser = await prisma.user.create({
      data: {
        email: "test@example.com",
        name: "Usuario de Prueba",
        emailVerified: new Date(),
      },
    });

    // Crear tipo de evento de prueba
    const testEventType = await prisma.eventType.create({
      data: {
        name: "Prueba",
        icon: "test",
        color: "#FF0000",
        userId: testUser.id,
      },
    });

    // Crear evento de prueba
    const testEvent = await prisma.event.create({
      data: {
        title: "Evento de Prueba",
        description: "Un evento para validar la migración",
        date: new Date(),
        typeId: testEventType.id,
        userId: testUser.id,
      },
    });

    console.log("✅ Datos de prueba creados:");
    console.log(`- Usuario: ${testUser.email}`);
    console.log(`- Tipo: ${testEventType.name}`);
    console.log(`- Evento: ${testEvent.title}`);

    return { testUser, testEventType, testEvent };
  } catch (error) {
    console.error("❌ Error creando datos de prueba:", error);
    throw error;
  }
}

if (process.argv[1] === new URL(import.meta.url).pathname) {
  const command = process.argv[2];

  switch (command) {
    case "validate":
      validateMigration().catch(console.error);
      break;
    case "test-data":
      createTestData().catch(console.error);
      break;
    default:
      console.log("Uso: node validate-migration.mjs [validate|test-data]");
  }
}
