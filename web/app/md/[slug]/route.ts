import { PAGE_SLUGS, htmlPath, pageMarkdown, type PageSlug } from "@/lib/markdown";
import { SITE_URL } from "@/lib/site";

export const dynamic = "force-static";
export const dynamicParams = false;

export function generateStaticParams() {
  return PAGE_SLUGS.map((slug) => ({ slug }));
}

export async function GET(
  _req: Request,
  { params }: { params: Promise<{ slug: string }> },
) {
  const { slug } = await params;
  return new Response(pageMarkdown(slug as PageSlug), {
    headers: {
      "Content-Type": "text/markdown; charset=utf-8",
      Link: `<${SITE_URL}${htmlPath(slug as PageSlug)}>; rel="canonical"`,
      "Cache-Control": "public, max-age=0, s-maxage=3600",
    },
  });
}
