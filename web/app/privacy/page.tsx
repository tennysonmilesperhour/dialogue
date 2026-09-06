export const metadata = { title: "dialogue privacy" };

export default function Privacy() {
  return (
    <main>
      <p className="kicker">privacy</p>
      <h1>The short version</h1>
      <p>
        dialogue is a ledger you keep with yourself. Your reasons, verdicts, and
        notes live on your device. We cannot see which apps you watch. We do not
        collect usage data. We do not run ads, sell data, or profile you. The
        current app has no account or cloud sync.
      </p>

      <h2>On your device</h2>
      <p>
        The apps you choose are opaque system tokens; Apple designed them so
        dialogue cannot learn which apps they are. The names in your ledger are
        labels you typed yourself. Your entries stay in the app&apos;s private
        storage, covered by your normal device backups.
      </p>

      <h2>From the app</h2>
      <p>
        The current build sends no analytics, identifiers, ledger entries, or
        usage data to us. If you do not join the website waitlist, we receive
        nothing from you.
      </p>

      <h2>Accounts and Sync</h2>
      <p>
        The current build has no account system and no cloud Sync feature. If
        either is added later, this policy and the App Store privacy label will
        be updated before that version is released.
      </p>

      <h2>This waitlist</h2>
      <p>
        The waitlist stores the email address you give it, used to tell you
        about the beta and the launch. There are no advertising or analytics
        cookies. When signups are enabled, Cloudflare Turnstile verifies
        submissions to reduce automated abuse. The website host and verification
        provider process technical request information, such as IP addresses, to
        deliver and protect the service.
      </p>

      <h2>Deleting your app data</h2>
      <p>
        In dialogue, open Settings and choose Delete all dialogue data. This
        removes your ledger, watched app choices, and dialogue notifications
        from this device. Existing device backups are managed separately through
        your Apple settings.
      </p>

      <h2>Never</h2>
      <p>
        No selling data or sharing it for advertising. No usage data collected for advertising or
        profiling. No ad SDKs. We do not read your ledger. It is yours.
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
