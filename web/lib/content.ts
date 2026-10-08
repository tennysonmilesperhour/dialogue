// Single source for the pages, the markdown twins, llms.txt and the JSON-LD.
// Edit copy here and every surface follows. Voice rules: docs/IDENTITY.md.

export type Faq = { q: string; a: string };

export const SUPPORT_EMAIL = "morphiclabsdata@gmail.com";

export const TAGLINE =
  "Every screen time app tells you how long. dialogue tells you whether you meant it.";

export const SUMMARY =
  "dialogue is an iPhone app, in development, that wraps each visit to a watched app with two questions. On the way in, a gate asks why you are opening it. When you finish, a debrief asks whether that turned out to be true. It never blocks, and no usage data leaves the device.";

export const PITCH =
  "Sometimes the hand reaches for an app before a decision catches up. dialogue gives you a moment to name what you came for, then a chance to notice whether it happened.";

export const GATE_AND_DEBRIEF =
  "On the way in, the gate asks why. When you finish a visit, a debrief asks whether that turned out to be true. Two taps, honest options included. Bored is a legal entry. The record that accumulates between those two questions is the product.";

export const IMS_HEADING = "The one number that matters";

export const IMS_TEXT =
  "Intention Match Score (IMS): the percentage of visits where what you said going in held up on the way out, per app, over a rolling 14 days. A Yes counts in full, a Partly counts half, and visits you did not log are left out rather than counted against you. Minutes cannot tell forty minutes helping a friend from twelve minutes of dread-scrolling. IMS can.";

export const LEDGER_CAPTION =
  "A week in the ledger (illustrative sample, not measured data)";

export const LEDGER_ROWS: { reason: string; avg: string; matched: string }[] = [
  { reason: "Reply", avg: "3 min", matched: "92%" },
  { reason: "Look up", avg: "4 min", matched: "81%" },
  { reason: "Bored", avg: "22 min", matched: "34%" },
  { reason: "Avoiding something", avg: "17 min", matched: "28%" },
];

export const LEDGER_NOTE =
  "These figures show the shape of the weekly review. They are a design sample, not results from real users. No beta data exists yet. No streaks that punish, no shame graphs, no minutes wasted counter.";

export const REFUSALS_HEADING = "Three things dialogue refuses to do";

export const REFUSALS: { lead: string; text: string }[] = [
  {
    lead: "It never blocks.",
    text: "Enter is always reachable. Friction follows your own match rate after enough reflections. You can always continue immediately or pause all gates in Settings.",
  },
  {
    lead: "It never phones home.",
    text: "Your reasons and verdicts stay on your device. There is no account or cloud sync in version 1.0. Export a copy whenever you want.",
  },
  {
    lead: "Version 1.0 is free.",
    text: "No subscriptions or in-app purchases.",
  },
];

export const WAITLIST_HEADING = "Get the first entry";

export const WAITLIST_TEXT =
  "Join the iPhone beta waitlist for an invitation when testing opens. The beta opens when Apple approves the Screen Time entitlement dialogue needs. We will email you about the beta and launch, with no marketing drip.";

export const NOT_AFFILIATED =
  "dialogue is not affiliated with Dialogue Health Technologies, the Canadian telehealth company, or with any other product called Dialogue.";

export const SUPPORT_INTRO_AFTER_EMAIL =
  ". Include your iPhone model and iOS version when reporting a problem. You do not need to send private ledger entries.";

export const SUPPORT_INTRO_BEFORE_EMAIL =
  "Questions about your ledger, app gates, or deleting your waitlist address? Email ";

export const FAQ: Faq[] = [
  {
    q: "How do I start?",
    a: "Explore the sample ledger first, or choose Set up my first app. Allow Screen Time access, choose an individual app, give it a name, and set a reflection reminder. You can change these choices in Settings.",
  },
  {
    q: "How do gates work?",
    a: "Opening a watched app shows a gate. Choose a reason to open dialogue, name your intention, then tap Begin visit and switch back to the app. The pause is optional. Begin visit works even without a reason. Pause all gates in Settings whenever you want.",
  },
  {
    q: "The gate does not open dialogue",
    a: "On older iOS versions, tap the notification or open dialogue manually. Your intention screen will be waiting. If a gate is stuck, open dialogue and pause all gates. You can also remove dialogue's Screen Time access in iPhone Settings.",
  },
  {
    q: "When do I reflect?",
    a: "Tap End visit and reflect in Today, or wait for your Screen Time reminder. Choose Yes, Partly, or No, then Log reflection. Later keeps an unfinished reflection in the ledger. You can edit a reflection if you change your mind.",
  },
  {
    q: "Why are visit lengths approximate?",
    a: "iOS does not report exactly when another app closes, and Screen Time callbacks can arrive late. Visit lengths include time spent away from the app. The Screen Time total in Review measures usage separately.",
  },
  {
    q: "What does the match score mean?",
    a: "Over the last 14 days, Yes counts as one and Partly as half. No counts as zero. We divide that total by the number of reflected visits. Unlogged visits are excluded.",
  },
  {
    q: "Can I keep a copy or delete everything?",
    a: "Settings offers CSV and JSON exports. These include your written entries, not Apple's app tokens. Delete all dialogue data clears entries, selections, gates, and reminders. Export first if you want a copy. To delete a website waitlist address, email us from that address.",
  },
  {
    q: "Is there a subscription?",
    a: "Version 1.0 is free and local-only. It has no account, subscription, or cloud sync.",
  },
  {
    q: "Is dialogue related to Dialogue Health Technologies?",
    a: NOT_AFFILIATED,
  },
];

export const PRIVACY_UPDATED = "October 8, 2026";
export const PRIVACY_TITLE = "Your ledger is yours.";

export const PRIVACY_INTRO =
  "dialogue 1.0 keeps your selected apps, intentions, reflections, notes, and scores on your iPhone. The native app sends no analytics or ledger data to us. There are no accounts, ads, or cloud sync.";

export const PRIVACY_SECTIONS: { heading: string; text: string }[] = [
  {
    heading: "On your device",
    text: "Apple gives dialogue opaque tokens for selected apps. Labels in your ledger are names you enter. The app and its Screen Time extensions share protected local storage. The ledger keeps up to 1,000 visits and 1,000 walk-aways and may be included in your normal device backups.",
  },
  {
    heading: "Your choices",
    text: "Notifications are optional. Lock-screen reminders do not contain app names, intentions, or notes. The sample ledger is fictional and stays in memory. CSV and JSON exports contain your written entries and are saved only to a destination you choose.",
  },
  {
    heading: "Delete your data",
    text: "In the app, open Settings and choose Delete all dialogue data. This clears your local ledger, selected apps, gates, and scheduled notifications. Copies you previously exported and device backups are managed separately by you. Screen Time permission can be removed in iPhone Settings.",
  },
  {
    heading: "The website waitlist",
    text: "If you join the waitlist, we store your email address through Supabase to contact you about the beta and launch. The website is hosted by Vercel; hosting services process network information needed to deliver and protect the site. To remove a waitlist address, email us from that address.",
  },
  {
    heading: "Website analytics",
    text: "The website can use PostHog to measure page views when analytics is configured. This is separate from the native app. It does not record sessions, capture clicks automatically, create person profiles, or persist an analytics identifier in cookies or local storage. Page-view events can include page and browser information. We do not send your ledger or waitlist email to PostHog.",
  },
  {
    heading: "Automated visitors",
    text: "The website keeps a short log of visits from crawlers and AI agents: the agent name, the page, and the time. Web browsers are never logged, and the log holds no personal data.",
  },
];

export const PRIVACY_CLOSER_HEADING = "Questions and deletion requests";

export const PRIVACY_CLOSER_BEFORE_EMAIL = "Email ";
export const PRIVACY_CLOSER_AFTER_EMAIL =
  ". We use information you include in a support message to respond to your request. You do not need to share your ledger for routine support.";
