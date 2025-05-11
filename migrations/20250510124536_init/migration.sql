/*
  Warnings:

  - You are about to drop the column `userId` on the `subscriptions` table. All the data in the column will be lost.
  - The primary key for the `user_metrics` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `userId` on the `user_metrics` table. All the data in the column will be lost.
  - Added the required column `user_id` to the `subscriptions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `user_id` to the `user_metrics` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "subscriptions" DROP CONSTRAINT "subscriptions_userId_fkey";

-- DropForeignKey
ALTER TABLE "user_metrics" DROP CONSTRAINT "user_metrics_userId_fkey";

-- AlterTable
ALTER TABLE "subscriptions" DROP COLUMN "userId",
ADD COLUMN     "user_id" UUID NOT NULL;

-- AlterTable
ALTER TABLE "user_metrics" DROP CONSTRAINT "user_metrics_pkey",
DROP COLUMN "userId",
ADD COLUMN     "user_id" UUID NOT NULL,
ADD CONSTRAINT "user_metrics_pkey" PRIMARY KEY ("user_id");

-- AddForeignKey
ALTER TABLE "user_metrics" ADD CONSTRAINT "user_metrics_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscriptions" ADD CONSTRAINT "subscriptions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;
