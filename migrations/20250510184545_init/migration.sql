/*
  Warnings:

  - You are about to drop the column `created_at` on the `subscriptions` table. All the data in the column will be lost.
  - You are about to drop the column `plan` on the `subscriptions` table. All the data in the column will be lost.
  - You are about to drop the column `provider_customer_id` on the `subscriptions` table. All the data in the column will be lost.
  - You are about to drop the column `provider_subscription_current_period_ends_at` on the `subscriptions` table. All the data in the column will be lost.
  - You are about to drop the column `provider_subscription_current_period_starts_at` on the `subscriptions` table. All the data in the column will be lost.
  - You are about to drop the column `provider_subscription_ends_at` on the `subscriptions` table. All the data in the column will be lost.
  - You are about to drop the column `provider_subscription_id` on the `subscriptions` table. All the data in the column will be lost.
  - You are about to drop the column `provider_subscription_starts_at` on the `subscriptions` table. All the data in the column will be lost.
  - You are about to drop the column `provider_subscription_status` on the `subscriptions` table. All the data in the column will be lost.
  - You are about to drop the column `updated_at` on the `subscriptions` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[subscription_id]` on the table `subscriptions` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `current_period_ends_at` to the `subscriptions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `current_period_starts_at` to the `subscriptions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `customer_id` to the `subscriptions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `ends_at` to the `subscriptions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `plan_id` to the `subscriptions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `starts_at` to the `subscriptions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `status` to the `subscriptions` table without a default value. This is not possible if the table is not empty.
  - Added the required column `subscription_id` to the `subscriptions` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "subscriptions_provider_customer_id_key";

-- DropIndex
DROP INDEX "subscriptions_provider_subscription_id_key";

-- AlterTable
ALTER TABLE "subscriptions" DROP COLUMN "created_at",
DROP COLUMN "plan",
DROP COLUMN "provider_customer_id",
DROP COLUMN "provider_subscription_current_period_ends_at",
DROP COLUMN "provider_subscription_current_period_starts_at",
DROP COLUMN "provider_subscription_ends_at",
DROP COLUMN "provider_subscription_id",
DROP COLUMN "provider_subscription_starts_at",
DROP COLUMN "provider_subscription_status",
DROP COLUMN "updated_at",
ADD COLUMN     "cancellation_reason" TEXT,
ADD COLUMN     "current_period_ends_at" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "current_period_starts_at" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "customer_id" TEXT NOT NULL,
ADD COLUMN     "ends_at" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "plan_id" TEXT NOT NULL,
ADD COLUMN     "proration_behavior" TEXT,
ADD COLUMN     "starts_at" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "status" TEXT NOT NULL,
ADD COLUMN     "subscription_id" TEXT NOT NULL,
ADD COLUMN     "trial_ends_at" TIMESTAMP(3);

-- CreateIndex
CREATE UNIQUE INDEX "subscriptions_subscription_id_key" ON "subscriptions"("subscription_id");
