import type { MetadataRoute } from "next";
import { LAST_REVIEWED, SITE_URL } from "@/lib/site";

export default function sitemap(): MetadataRoute.Sitemap {
  return ["", "/support", "/privacy"].map((p) => ({
    url: `${SITE_URL}${p}`,
    lastModified: LAST_REVIEWED,
  }));
}
