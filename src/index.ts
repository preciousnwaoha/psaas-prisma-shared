// /*
import { PrismaClient } from '../prisma/generated/client'
import {PrismaClientContext} from './index.d'
// import { withAccelerate } from '@prisma/extension-accelerate'

const globalForPrisma = global as unknown as { 
    prisma: PrismaClient
}

const prisma = globalForPrisma.prisma || new PrismaClient()

// .$extends(withAccelerate())

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma


export const prismaClientContext: PrismaClientContext = {
    prisma
}

// */
