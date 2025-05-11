/*
  Warnings:

  - You are about to drop the column `totalRevenue` on the `metrics` table. All the data in the column will be lost.
  - You are about to drop the column `totalSubscriptions` on the `metrics` table. All the data in the column will be lost.
  - You are about to drop the column `totalUsers` on the `metrics` table. All the data in the column will be lost.
  - You are about to drop the column `authId` on the `profiles` table. All the data in the column will be lost.
  - You are about to drop the column `firstName` on the `profiles` table. All the data in the column will be lost.
  - You are about to drop the column `lastName` on the `profiles` table. All the data in the column will be lost.
  - You are about to drop the column `totalAudioGenerations` on the `user_metrics` table. All the data in the column will be lost.
  - You are about to drop the column `totalImageGenerations` on the `user_metrics` table. All the data in the column will be lost.
  - You are about to drop the column `totalTextGenerations` on the `user_metrics` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[auth_id]` on the table `profiles` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `auth_id` to the `profiles` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "profiles_authId_key";

-- AlterTable
ALTER TABLE "metrics" DROP COLUMN "totalRevenue",
DROP COLUMN "totalSubscriptions",
DROP COLUMN "totalUsers",
ADD COLUMN     "total_revenue" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "total_subscriptions" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "total_users" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "profiles" DROP COLUMN "authId",
DROP COLUMN "firstName",
DROP COLUMN "lastName",
ADD COLUMN     "auth_id" TEXT NOT NULL,
ADD COLUMN     "first_name" TEXT,
ADD COLUMN     "last_name" TEXT;

-- AlterTable
ALTER TABLE "user_metrics" DROP COLUMN "totalAudioGenerations",
DROP COLUMN "totalImageGenerations",
DROP COLUMN "totalTextGenerations",
ADD COLUMN     "total_audio_generations" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "total_image_generations" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "total_revenue" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "total_subscriptions" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "total_text_generations" INTEGER NOT NULL DEFAULT 0;

-- CreateIndex
CREATE UNIQUE INDEX "profiles_auth_id_key" ON "profiles"("auth_id");
