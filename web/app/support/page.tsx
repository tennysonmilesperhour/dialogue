export const metadata = { title: "dialogue support" };

export default function Support() {
  return (
    <main>
      <p className="kicker">support</p>
      <h1>Questions, answered plainly</h1>

      <h2>What is dialogue?</h2>
      <p>
        A ledger for your attention. When you open a watched app, dialogue
        asks why. When you leave, it asks whether that held up. The record is
        the product.
      </p>

      <h2>Does dialogue block apps?</h2>
      <p>
        No. Never. The Enter path is always available. What changes over time
        is how light or deliberate the gate is, and that follows your own
        match rate.
      </p>

      <h2>Why can dialogue not see my app names?</h2>
      <p>
        Apple&apos;s Screen Time system hands apps opaque tokens instead of
        names, by design. The names in your ledger are the labels you wrote
        during setup.
      </p>

      <h2>Why is my session length approximate?</h2>
      <p>
        iOS does not tell apps exactly when another app closes. dialogue
        triangulates from the signals it does get and labels estimates
        honestly instead of faking precision.
      </p>

      <h2>What does the subscription add?</h2>
      <p>
        The current build has no subscription. Optional Sync is planned for a
        later version, after the local ledger has been tested in public.
      </p>

      <h2>Contact</h2>
      <p>
        <a href="https://github.com/tennysonmilesperhour/dialogue/issues/new">
          Open a support request on GitHub
        </a>
        . Requests are public, so do not include private ledger entries or
        other personal information.
      </p>

      <footer>
        <a href="/">Home</a>
        <a href="/privacy">Privacy</a>
      </footer>
    </main>
  );
}
