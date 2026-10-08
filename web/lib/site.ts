// Public origin until a custom domain is bought. See docs/IDENTITY.md.
export const siteUrl = "https://dialogue-five.vercel.app";

export const siteDescription =
  "Every screen time app tells you how long. dialogue tells you whether you meant it. A ledger of intention for the apps you open.";

export const shareImage = {
  url: "/og.png",
  width: 1200,
  height: 630,
  alt: "dialogue. Every screen time app tells you how long. dialogue tells you whether you meant it.",
};

// A page-level openGraph object replaces the layout's, so each page carries the image.
export function openGraphFor(path: string) {
  return {
    url: path,
    siteName: "dialogue",
    type: "website" as const,
    locale: "en_US",
    images: [shareImage],
  };
}
