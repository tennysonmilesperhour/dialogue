import type { MetadataRoute } from "next";
import { LAST_REVIEWED, SITE_URL } from "@/lib/site";

export default function sitemap(): MetadataRoute.Sitemap {
  return ["", "/support", "/privacy"].map((p, index) => ({
    url: `${SITE_URL}${p}`,
    lastModified: LAST_REVIEWED,
    changeFrequency: index === 0 ? "weekly" as const : "yearly" as const,
    priority: index === 0 ? 1 : 0.4,
  }));
}
