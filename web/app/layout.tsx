import type { Metadata } from "next";
import { Fraunces, IBM_Plex_Mono, IBM_Plex_Serif } from "next/font/google";
import "./globals.css";
import { TAGLINE } from "@/lib/content";
import { SITE_URL } from "@/lib/site";

const display = Fraunces({
  subsets: ["latin"],
  variable: "--font-display",
  weight: ["400", "600"],
});

const mono = IBM_Plex_Mono({
  subsets: ["latin"],
  variable: "--font-mono",
  weight: ["400", "500"],
});

const serif = IBM_Plex_Serif({
  subsets: ["latin"],
  variable: "--font-serif",
  weight: ["400", "500"],
  style: ["normal", "italic"],
});

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: "dialogue",
  description: TAGLINE,
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body className={`${display.variable} ${mono.variable} ${serif.variable}`}>
        {children}
      </body>
    </html>
  );
}
