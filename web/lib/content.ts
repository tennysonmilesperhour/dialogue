// Single source for the pages, the markdown twins, llms.txt and the JSON-LD.
// Edit copy here and every surface follows. Voice rules: docs/IDENTITY.md.

export type Faq = { q: string; a: string };

export const TAGLINE =
  "Every screen time app tells you how long. dialogue tells you whether you meant it.";

export const SUMMARY =
  "dialogue is an iOS app, in development, that wraps each session in a watched app with two questions. On the way in, a gate asks why you are opening it. On the way out, a debrief asks whether that turned out to be true. It never blocks, and no usage data leaves the device.";

export const PITCH =
  "You do not open Instagram because you decided to. A cue fires and the hand moves. Blockers answer that with a wall, which you resent and defeat. Trackers answer with a number, which tells you nothing about whose time that was. dialogue asks a better question, twice.";

export const GATE_AND_DEBRIEF =
  "On the way in, the gate asks why. On the way out, a debrief asks whether that turned out to be true. Two taps, honest options included. Bored is a legal entry. The record that accumulates between those two questions is the product.";

export const IMS_HEADING = "The one number that matters";

export const IMS_TEXT =
  "Intention Match Score (IMS): the percentage of sessions where what you said going in held up on the way out, per app, over a rolling 14 days. A Yes counts in full, a Partly counts half, and sessions you did not log are left out rather than counted against you. Minutes cannot tell forty minutes helping a friend from twelve minutes of dread-scrolling. IMS can.";

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
    text: "Enter is always reachable. In the planned adaptive gate (version 1.1), friction follows your own match rate: earn an 85% IMS and the gate becomes a whisper.",
  },
  {
    lead: "It never phones home.",
    text: "Your reasons and verdicts stay on your device. The current build has no account and no sync. We cannot even see which apps you picked; Apple designed it that way and we like it.",
  },
  {
    lead: "It never rents itself to you.",
    text: "The app is one price, once. Optional Sync is planned as a separate later add-on, and nothing in the core app depends on it.",
  },
];

export const REFUSALS_CLOSER =
  "If you stop using dialogue, we should not keep charging you for it.";

export const WAITLIST_HEADING = "Get the first entry";

export const WAITLIST_TEXT =
  "The iOS beta, 50 seats, opens when Apple approves the Screen Time entitlement dialogue needs. The waitlist is the queue and nothing else; one address, no marketing drip.";

export const NOT_AFFILIATED =
  "dialogue is not affiliated with Dialogue Health Technologies, the Canadian telehealth company, or with any other product called Dialogue.";

export const FAQ: Faq[] = [
  {
    q: "What is dialogue?",
    a: "A ledger for your attention. When you open a watched app, dialogue asks why. When you leave, it asks whether that held up. The record is the product.",
  },
  {
    q: "Does dialogue block apps?",
    a: "No. Never. The Enter path is always available. In the planned adaptive gate (version 1.1), how light or deliberate the gate is will follow your own match rate, and Enter stays reachable at every level.",
  },
  {
    q: "Why can dialogue not see my app names?",
    a: "Apple's Screen Time system hands apps opaque tokens instead of names, by design. The names in your ledger are the labels you wrote during setup.",
  },
  {
    q: "Why is my session length approximate?",
    a: "iOS does not tell apps exactly when another app closes. dialogue triangulates from the signals it does get and labels estimates honestly instead of faking precision.",
  },
  {
    q: "Is dialogue related to Dialogue Health Technologies?",
    a: NOT_AFFILIATED,
  },
  {
    q: "What does the subscription add?",
    a: "The current build has no subscription. Optional Sync is planned for a later version, after the local ledger has been tested in public.",
  },
];

export const PRIVACY_TITLE = "The short version";

export const PRIVACY_INTRO =
  "dialogue is a ledger you keep with yourself. Your reasons, verdicts, and notes live on your device. We cannot see which apps you watch. We do not collect usage data. We do not run ads, sell data, or profile you. If you never create an account, nothing leaves your phone.";

export const PRIVACY_SECTIONS: { heading: string; text: string }[] = [
  {
    heading: "On your device",
    text: "The apps you choose are opaque system tokens; Apple designed them so dialogue cannot learn which apps they are. The names in your ledger are labels you typed yourself. Your entries stay in the app's private storage, covered by your normal device backups.",
  },
  {
    heading: "From the app",
    text: "The current build sends no analytics, identifiers, ledger entries, or usage data to us. If you do not join the website waitlist, we receive nothing from you.",
  },
  {
    heading: "Accounts and Sync",
    text: "The current build has no account system and no cloud Sync feature. If either is added later, this policy and the App Store privacy label will be updated before that version is released.",
  },
  {
    heading: "This waitlist",
    text: "The only thing this site stores about people is the email address you give it, used to tell you about the beta and the launch. No analytics cookies, no trackers. Write to us and we will remove your address the same day.",
  },
  {
    heading: "Automated visitors",
    text: "The site keeps a short log of visits from crawlers and AI agents: the agent name, the page, and the time. Web browsers are never logged, and the log holds no personal data.",
  },
  {
    heading: "Never",
    text: "No selling or sharing data. No usage data collected for advertising or profiling. No ad SDKs. We do not read your ledger. It is yours.",
  },
];

export const PRIVACY_CLOSER_HEADING = "Questions and deletion requests";

export const PRIVACY_CLOSER =
  "Use the support page to contact us. Waitlist deletion requests are handled manually and confirmed when complete.";

export const SUPPORT_CONTACT =
  "Open a support request on GitHub. Requests are public, so do not include private ledger entries or other personal information.";
