import type { Metadata } from "next";
import localFont from "next/font/local";
import "./globals.css";

const display = localFont({
  src: [
    { path: "./fonts/Fraunces-400-normal.woff2", weight: "400", style: "normal" },
    { path: "./fonts/Fraunces-600-normal.woff2", weight: "600", style: "normal" },
  ],
  variable: "--font-display", display: "swap",
});
const mono = localFont({
  src: [
    { path: "./fonts/IBM-Plex-Mono-400-normal.woff2", weight: "400", style: "normal" },
    { path: "./fonts/IBM-Plex-Mono-500-normal.woff2", weight: "500", style: "normal" },
  ],
  variable: "--font-mono", display: "swap",
});
const serif = localFont({
  src: [
    { path: "./fonts/IBM-Plex-Serif-400-normal.woff2", weight: "400", style: "normal" },
    { path: "./fonts/IBM-Plex-Serif-500-normal.woff2", weight: "500", style: "normal" },
    { path: "./fonts/IBM-Plex-Serif-400-italic.woff2", weight: "400", style: "italic" },
    { path: "./fonts/IBM-Plex-Serif-500-italic.woff2", weight: "500", style: "italic" },
  ],
  variable: "--font-serif", display: "swap",
});

export const metadata: Metadata = {
  title: "dialogue",
  description:
    "Every screen time app tells you how long. dialogue tells you whether you meant it.",
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
