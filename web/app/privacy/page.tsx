export const metadata = { title: "dialogue privacy" };

export default function Privacy() {
  return (
    <main>
      <p className="kicker">privacy · updated October 6, 2026</p>
      <h1>Your ledger is yours.</h1>
      <p>dialogue 1.0 keeps your selected apps, intentions, reflections, notes, and scores on your iPhone. The native app sends no analytics or ledger data to us. There are no accounts, ads, or cloud sync.</p>
      <h2>On your device</h2>
      <p>Apple gives dialogue opaque tokens for selected apps. Labels in your ledger are names you enter. The app and its Screen Time extensions share protected local storage. The ledger keeps up to 1,000 visits and 1,000 walk-aways and may be included in your normal device backups.</p>
      <h2>Your choices</h2>
      <p>Notifications are optional. Lock-screen reminders do not contain app names, intentions, or notes. The sample ledger is fictional and stays in memory. CSV and JSON exports contain your written entries and are saved only to a destination you choose.</p>
      <h2>Delete your data</h2>
      <p>In the app, open Settings and choose Delete all dialogue data. This clears your local ledger, selected apps, gates, and scheduled notifications. Copies you previously exported and device backups are managed separately by you. Screen Time permission can be removed in iPhone Settings.</p>
      <h2>The website waitlist</h2>
      <p>If you join the waitlist, we store your email address through Supabase to contact you about the beta and launch. The website is hosted by Vercel; hosting services process network information needed to deliver and protect the site. To remove a waitlist address, email us from that address.</p>
      <h2>Website analytics</h2>
      <p>The website can use PostHog to measure page views when analytics is configured. This is separate from the native app. It does not record sessions, capture clicks automatically, create person profiles, or persist an analytics identifier in cookies or local storage. Page-view events can include page and browser information. We do not send your ledger or waitlist email to PostHog.</p>
      <h2>Questions and deletion requests</h2>
      <p>Email <a href="mailto:morphiclabsdata@gmail.com">morphiclabsdata@gmail.com</a>. We use information you include in a support message to respond to your request. You do not need to share your ledger for routine support.</p>
      <footer><a href="/">Home</a><a href="/support">Support</a></footer>
    </main>
  );
}
