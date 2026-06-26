import { db, categoriesTable, networkPropertiesTable, platformSettingsTable } from "@workspace/db";
import { sql } from "drizzle-orm";

async function seed() {
  console.log("Seeding categories...");
  await db.insert(categoriesTable).values([
    { name: "Restaurants & Food", slug: "restaurants", iconName: "utensils", sortOrder: 1 },
    { name: "Health & Wellness", slug: "health", iconName: "heart", sortOrder: 2 },
    { name: "Home Services", slug: "home-services", iconName: "home", sortOrder: 3 },
    { name: "Beauty & Personal Care", slug: "beauty", iconName: "sparkles", sortOrder: 4 },
    { name: "Fitness & Sports", slug: "fitness", iconName: "dumbbell", sortOrder: 5 },
    { name: "Education & Tutoring", slug: "education", iconName: "book", sortOrder: 6 },
    { name: "Auto & Transportation", slug: "auto", iconName: "car", sortOrder: 7 },
    { name: "Pet Services", slug: "pets", iconName: "paw-print", sortOrder: 8 },
    { name: "Professional Services", slug: "professional", iconName: "briefcase", sortOrder: 9 },
    { name: "Entertainment & Events", slug: "entertainment", iconName: "music", sortOrder: 10 },
    { name: "Retail & Shopping", slug: "retail", iconName: "shopping-bag", sortOrder: 11 },
    { name: "Real Estate", slug: "real-estate", iconName: "building", sortOrder: 12 },
  ]).onConflictDoNothing();

  console.log("Seeding network properties...");
  await db.insert(networkPropertiesTable).values([
    {
      propertyName: "EarnTree.co",
      propertyUrl: "https://earntree.co",
      description: "Our main platform — share EarnTree with your network to activate your account and start earning.",
      logoUrl: null,
      isActive: true,
      isRequired: true,
      sortOrder: 1,
    },
    {
      propertyName: "Buyshare.co",
      propertyUrl: "https://buyshare.co",
      description: "A buying club for local deals — share with friends who love supporting local.",
      logoUrl: null,
      isActive: true,
      isRequired: true,
      sortOrder: 2,
    },
    {
      propertyName: "Bluetruck.co",
      propertyUrl: "https://bluetruck.co",
      description: "Local delivery and service connections — help your community discover reliable services.",
      logoUrl: null,
      isActive: true,
      isRequired: true,
      sortOrder: 3,
    },
    {
      propertyName: "Pocketcash.co",
      propertyUrl: "https://pocketcash.co",
      description: "Cash-back rewards for everyday spending — share to help neighbors save more.",
      logoUrl: null,
      isActive: true,
      isRequired: true,
      sortOrder: 4,
    },
    {
      propertyName: "Burncall.co",
      propertyUrl: "https://burncall.co",
      description: "Local business calling card — connect businesses with their ideal local customers.",
      logoUrl: null,
      isActive: true,
      isRequired: true,
      sortOrder: 5,
    },
  ]).onConflictDoNothing();

  console.log("Seeding platform settings...");
  const defaults = [
    { key: "rewardPerShare", value: "0.25", description: "USD reward per verified share" },
    { key: "payoutThreshold", value: "100", description: "Minimum balance to request payout" },
    { key: "dailyEarningCap", value: "25", description: "Max earnings per user per day" },
    { key: "weeklyEarningCap", value: "100", description: "Max earnings per user per week" },
    { key: "subscriptionWeeklyPrice", value: "10", description: "Business subscription weekly price USD" },
    { key: "networkActivationRequired", value: "true", description: "Require network activation before earning" },
    { key: "networkActivationOptional", value: "false", description: "Allow users to skip network activation" },
    { key: "fraudReviewThreshold", value: "75", description: "Fraud score threshold for auto-review flag" },
  ];

  for (const setting of defaults) {
    await db.insert(platformSettingsTable)
      .values(setting)
      .onConflictDoNothing();
  }

  console.log("Seed complete.");
  process.exit(0);
}

seed().catch(err => {
  console.error("Seed failed:", err);
  process.exit(1);
});
