import { fileURLToPath } from "node:url";

const securityHeaders = [
  {
    key: "Strict-Transport-Security",
    value: "max-age=63072000; includeSubDomains; preload",
  },
  { key: "X-Content-Type-Options", value: "nosniff" },
  { key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
  {
    key: "Permissions-Policy",
    value: "camera=(), microphone=(), geolocation=()",
  },
  { key: "X-Frame-Options", value: "SAMEORIGIN" },
];

/** @type {import('next').NextConfig} */
const nextConfig = {
  outputFileTracingRoot: fileURLToPath(new URL(".", import.meta.url)),
  async headers() {
    return [{ source: "/:path*", headers: securityHeaders }];
  },
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
