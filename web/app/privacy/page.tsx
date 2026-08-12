export const metadata = { title: "dialogue privacy" };

export default function Privacy() {
  return (
    <main>
      <p className="kicker">privacy</p>
      <h1>The short version</h1>
      <p>
        dialogue is a ledger you keep with yourself. Your reasons, verdicts,
        and notes live on your device. We cannot see which apps you watch. We
        do not collect usage data. We do not run ads, sell data, or profile
        you. If you never create an account, nothing leaves your phone.
      </p>

      <h2>On your device</h2>
      <p>
        The apps you choose are opaque system tokens; Apple designed them so
        dialogue cannot learn which apps they are. The names in your ledger
        are labels you typed yourself. Your entries stay in the app&apos;s
        private storage, covered by your normal device backups.
      </p>

      <h2>If you do nothing</h2>
      <p>
        We receive anonymous, aggregate app health signals (for example, a
        debrief was completed) through TelemetryDeck, with no advertising
        identifier and no way to tie a signal to you.
      </p>

      <h2>If you create a Sync account</h2>
      <p>
        Sync is optional and off by default. With an account, your written
        entries are encrypted in transit and stored with our database
        provider so your ledger can back up and appear on your other devices.
        App tokens never sync; they are meaningless off your device. You can
        delete your account and every synced row from inside the app, at any
        time, completely.
      </p>

      <h2>This waitlist</h2>
      <p>
        The only thing this site stores is the email address you give it,
        used to tell you about the beta and the launch. No analytics cookies,
        no trackers. Write to us and we will remove your address the same
        day.
      </p>

      <h2>Never</h2>
      <p>
        No selling or sharing data. No usage data collected for advertising
        or profiling. No ad SDKs. We do not read your ledger. It is yours.
      </p>

      <footer>
        <a href="/">Home</a>
        <a href="/support">Support</a>
      </footer>
    </main>
  );
}
