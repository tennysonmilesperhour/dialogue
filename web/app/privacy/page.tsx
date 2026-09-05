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

      <h2>From the app</h2>
      <p>
        The current build sends no analytics, identifiers, ledger entries,
        or usage data to us. If you do not join the website waitlist, we
        receive nothing from you.
      </p>

      <h2>Accounts and Sync</h2>
      <p>
        The current build has no account system and no cloud Sync feature.
        If either is added later, this policy and the App Store privacy label
        will be updated before that version is released.
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

      <h2>Questions and deletion requests</h2>
      <p>
        Use the <a href="/support">support page</a> to contact us. Waitlist
        deletion requests are handled manually and confirmed when complete.
      </p>

      <footer>
        <a href="/">Home</a>
        <a href="/support">Support</a>
      </footer>
    </main>
  );
}
