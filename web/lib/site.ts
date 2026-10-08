// Until a real domain is bought (docs/IDENTITY.md), the site lives on Vercel.
export const SITE_URL = (
  process.env.NEXT_PUBLIC_SITE_URL || "https://dialogue-five.vercel.app"
).replace(/\/$/, "");

export const siteUrl = SITE_URL;

export const siteDescription =
  "Every screen time app tells you how long. dialogue tells you whether you meant it. A ledger of intention for the apps you open.";

export const shareImage = {
  url: "/og.png",
  width: 1200,
  height: 630,
  alt: "dialogue, a ledger of intention",
};

export function openGraphFor(path: string) {
  return {
    url: path,
    siteName: "dialogue",
    type: "website" as const,
    locale: "en_US",
    images: [shareImage],
  };
}

// Shown on pages and used in the markdown twins. The monthly agent review
// bumps it only when the content was actually re-checked.
export const LAST_REVIEWED = "2026-10-08";
