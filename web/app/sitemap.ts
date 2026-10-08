import type { MetadataRoute } from "next";
import { siteUrl } from "../lib/site";

export default function sitemap(): MetadataRoute.Sitemap {
  const updated = new Date("2026-10-08");
  return [
    { url: siteUrl, lastModified: updated, changeFrequency: "weekly", priority: 1 },
    {
      url: `${siteUrl}/privacy`,
      lastModified: updated,
      changeFrequency: "yearly",
      priority: 0.4,
    },
    {
      url: `${siteUrl}/support`,
      lastModified: updated,
      changeFrequency: "yearly",
      priority: 0.4,
    },
  ];
}
