-- AlterTable
ALTER TABLE "profiles" ADD COLUMN     "tags" TEXT[] DEFAULT ARRAY[]::TEXT[];

-- AlterTable
ALTER TABLE "subscriptions" ALTER COLUMN "ends_at" DROP NOT NULL;
