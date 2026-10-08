import { openGraphFor } from "../../lib/site";

export const metadata = {
  title: "dialogue support",
  alternates: { canonical: "/support" },
  openGraph: openGraphFor("/support"),
};

export default function Support() {
  return (
    <main>
      <p className="kicker">dialogue support</p>
      <h1>A little help.</h1>
      <p>Questions about your ledger, app gates, or deleting your waitlist address? Email <a href="mailto:morphiclabsdata@gmail.com">morphiclabsdata@gmail.com</a>. Include your iPhone model and iOS version when reporting a problem. You do not need to send private ledger entries.</p>
      <h2>How do I start?</h2>
      <p>Explore the sample ledger first, or choose Set up my first app. Allow Screen Time access, choose an individual app, give it a name, and set a reflection reminder. You can change these choices in Settings.</p>
      <h2>How do gates work?</h2>
      <p>Opening a watched app shows a gate. Choose a reason to open dialogue, name your intention, then tap Begin visit and switch back to the app. The pause is optional. Begin visit works even without a reason. Pause all gates in Settings whenever you want.</p>
      <h2>The gate does not open dialogue</h2>
      <p>On older iOS versions, tap the notification or open dialogue manually. Your intention screen will be waiting. If a gate is stuck, open dialogue and pause all gates. You can also remove dialogue&apos;s Screen Time access in iPhone Settings.</p>
      <h2>When do I reflect?</h2>
      <p>Tap End visit and reflect in Today, or wait for your Screen Time reminder. Choose Yes, Partly, or No, then Log reflection. Later keeps an unfinished reflection in the ledger. You can edit a reflection if you change your mind.</p>
      <h2>Why are visit lengths approximate?</h2>
      <p>iOS does not report exactly when another app closes, and Screen Time callbacks can arrive late. Visit lengths include time spent away from the app. The Screen Time total in Review measures usage separately.</p>
      <h2>What does the match score mean?</h2>
      <p>Over the last 14 days, Yes counts as one and Partly as half. No counts as zero. We divide that total by the number of reflected visits. Unlogged visits are excluded.</p>
      <h2>Can I keep a copy or delete everything?</h2>
      <p>Settings offers CSV and JSON exports. These include your written entries, not Apple&apos;s app tokens. Delete all dialogue data clears entries, selections, gates, and reminders. Export first if you want a copy. To delete a website waitlist address, email us from that address.</p>
      <h2>Is there a subscription?</h2>
      <p>Version 1.0 is free and local-only. It has no account, subscription, or cloud sync.</p>
      <footer><a href="/">Home</a><a href="/privacy">Privacy</a><a href="https://tennysontaggart.com">by Tennyson Taggart</a></footer>
    </main>
  );
}
