// Sync method
import type { PrismaClient } from '../prisma/generated/client';

export * from "../prisma/generated/client/index.d";

export interface PrismaClientContext {
    prisma: PrismaClient;
}

export const prismaClientContext: PrismaClientContext;
