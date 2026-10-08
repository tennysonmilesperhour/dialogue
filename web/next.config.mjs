import { fileURLToPath } from "node:url";

/** @type {import('next').NextConfig} */
const nextConfig = {
  outputFileTracingRoot: fileURLToPath(new URL(".", import.meta.url)),
  // Markdown twins: same URL plus .md, built from lib/content.ts.
  async rewrites() {
    return [
      { source: "/index.md", destination: "/md/index" },
      { source: "/support.md", destination: "/md/support" },
      { source: "/privacy.md", destination: "/md/privacy" },
      { source: "/llms/how-it-works.md", destination: "/llms/how-it-works" },
      { source: "/llms/privacy-stance.md", destination: "/llms/privacy-stance" },
    ];
  },
};

export default nextConfig;
