import { TOPIC_SLUGS, topicMarkdown, type Topic } from "@/lib/markdown";
import { SITE_URL } from "@/lib/site";

export const dynamic = "force-static";
export const dynamicParams = false;

export function generateStaticParams() {
  return TOPIC_SLUGS.map((topic) => ({ topic }));
}

export async function GET(
  _req: Request,
  { params }: { params: Promise<{ topic: string }> },
) {
  const { topic } = await params;
  const canonical = topic === "privacy-stance" ? "/privacy" : "/";
  return new Response(topicMarkdown(topic as Topic), {
    headers: {
      "Content-Type": "text/markdown; charset=utf-8",
      Link: `<${SITE_URL}${canonical}>; rel="canonical"`,
      "Cache-Control": "public, max-age=0, s-maxage=3600",
    },
  });
}
