import posthog from "posthog-js";

const token = process.env.NEXT_PUBLIC_POSTHOG_KEY;

if (token) {
  // The native app's usage data remains on-device. The public marketing site
  // sends anonymous pageviews only, without replay, click capture, or profiles.
  posthog.init(token, {
    api_host: process.env.NEXT_PUBLIC_POSTHOG_HOST || "https://us.i.posthog.com",
    defaults: "2026-05-30",
    person_profiles: "never",
    persistence: "memory",
    autocapture: false,
    capture_pageview: true,
    capture_pageleave: false,
    disable_session_recording: true,
    capture_exceptions: true,
    before_send: (event) => {
      if (!event) return null;
      event.properties = { ...event.properties, app: "dialogue-marketing" };
      return event;
    },
  });
}
