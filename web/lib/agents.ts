// Known AI crawlers, assistants and tools. Matching is on the user agent
// string, case-insensitive. Browsers never match, so people are never logged.
export type AgentKind = "training" | "search" | "assistant" | "seo" | "tool" | "unknown";

const KNOWN: { token: string; agent: string; kind: AgentKind }[] = [
  { token: "gptbot", agent: "GPTBot", kind: "training" },
  { token: "oai-searchbot", agent: "OAI-SearchBot", kind: "search" },
  { token: "chatgpt-user", agent: "ChatGPT-User", kind: "assistant" },
  { token: "claudebot", agent: "ClaudeBot", kind: "training" },
  { token: "claude-searchbot", agent: "Claude-SearchBot", kind: "search" },
  { token: "claude-user", agent: "Claude-User", kind: "assistant" },
  { token: "anthropic-ai", agent: "anthropic-ai", kind: "training" },
  { token: "perplexitybot", agent: "PerplexityBot", kind: "search" },
  { token: "perplexity-user", agent: "Perplexity-User", kind: "assistant" },
  { token: "google-extended", agent: "Google-Extended", kind: "training" },
  { token: "googleother", agent: "GoogleOther", kind: "training" },
  { token: "google-cloudvertexbot", agent: "Google-CloudVertexBot", kind: "assistant" },
  { token: "googlebot", agent: "Googlebot", kind: "search" },
  { token: "bingbot", agent: "Bingbot", kind: "search" },
  { token: "duckassistbot", agent: "DuckAssistBot", kind: "assistant" },
  { token: "applebot-extended", agent: "Applebot-Extended", kind: "training" },
  { token: "applebot", agent: "Applebot", kind: "search" },
  { token: "meta-externalagent", agent: "Meta-ExternalAgent", kind: "training" },
  { token: "meta-externalfetcher", agent: "Meta-ExternalFetcher", kind: "assistant" },
  { token: "bytespider", agent: "Bytespider", kind: "training" },
  { token: "amazonbot", agent: "Amazonbot", kind: "search" },
  { token: "ccbot", agent: "CCBot", kind: "training" },
  { token: "cohere-ai", agent: "cohere-ai", kind: "training" },
  { token: "mistralai-user", agent: "MistralAI-User", kind: "assistant" },
  { token: "youbot", agent: "YouBot", kind: "search" },
  { token: "ahrefsbot", agent: "AhrefsBot", kind: "seo" },
  { token: "semrushbot", agent: "SemrushBot", kind: "seo" },
  { token: "mj12bot", agent: "MJ12bot", kind: "seo" },
  { token: "dotbot", agent: "DotBot", kind: "seo" },
  { token: "curl/", agent: "curl", kind: "tool" },
  { token: "wget/", agent: "wget", kind: "tool" },
  { token: "python-requests", agent: "python-requests", kind: "tool" },
  { token: "python-httpx", agent: "python-httpx", kind: "tool" },
  { token: "node-fetch", agent: "node-fetch", kind: "tool" },
  { token: "axios/", agent: "axios", kind: "tool" },
  { token: "go-http-client", agent: "Go-http-client", kind: "tool" },
];

const GENERIC = /bot\b|crawler|spider|scraper|crawl/i;

export function classify(ua: string): { agent: string; kind: AgentKind } | null {
  const lower = ua.toLowerCase();
  for (const k of KNOWN) {
    if (lower.includes(k.token)) return { agent: k.agent, kind: k.kind };
  }
  // Bot-shaped but not on the list: logged as unknown so the review can add it.
  if (GENERIC.test(ua)) return { agent: "unknown", kind: "unknown" };
  return null;
}
