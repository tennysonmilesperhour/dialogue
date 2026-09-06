import type { Metadata } from "next";
import { Fraunces, IBM_Plex_Mono, IBM_Plex_Serif } from "next/font/google";
import "./globals.css";

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
  title: "dialogue",
  description:
    "Every screen time app tells you how long. dialogue tells you whether you meant it.",
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body
        className={`${display.variable} ${mono.variable} ${serif.variable}`}
      >
        {children}
      </body>
    </html>
  );
}
