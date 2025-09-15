/**
 * Script para crear backup de la base de datos SQLite
 * Parte de TASK-A002: Database Schema Extension
 */

import fs from "fs";
import path from "path";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function backupDatabase() {
  const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
  const backupDir = path.join(process.cwd(), "backups");

  if (!fs.existsSync(backupDir)) {
    fs.mkdirSync(backupDir);
  }

  const backupFile = path.join(backupDir, `backup-${timestamp}.json`);

  try {
    console.log("📦 Creando backup de la base de datos...");

    const data = {
      events: await prisma.event.findMany(),
      eventTypes: await prisma.eventType.findMany(),
      timestamp: new Date().toISOString(),
      version: "1.0.0",
    };

    fs.writeFileSync(backupFile, JSON.stringify(data, null, 2));
    console.log(`✅ Backup creado: ${backupFile}`);

    // También crear backup del archivo de base de datos físico
    const dbPath = path.join(process.cwd(), "prisma", "dev.db");
    const dbBackupPath = path.join(backupDir, `dev-backup-${timestamp}.db`);

    if (fs.existsSync(dbPath)) {
      fs.copyFileSync(dbPath, dbBackupPath);
      console.log(`✅ Backup del archivo DB creado: ${dbBackupPath}`);
    }

    return {
      jsonBackup: backupFile,
      dbBackup: dbBackupPath,
      data,
    };
  } catch (error) {
    console.error("❌ Error al crear backup:", error);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

if (process.argv[1] === new URL(import.meta.url).pathname) {
  backupDatabase().catch(console.error);
}

export { backupDatabase };
