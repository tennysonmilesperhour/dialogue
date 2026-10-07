// Until a real domain is bought (docs/IDENTITY.md), the site lives on Vercel.
export const SITE_URL = (
  process.env.NEXT_PUBLIC_SITE_URL || "https://dialogue-five.vercel.app"
).replace(/\/$/, "");

export const CONTACT_URL =
  "https://github.com/tennysonmilesperhour/dialogue/issues/new";

// Shown on pages and used in the markdown twins. The monthly agent review
// bumps it only when the content was actually re-checked.
export const LAST_REVIEWED = "2026-10-07";
