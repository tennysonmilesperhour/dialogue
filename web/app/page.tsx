import WaitlistForm from "./waitlist-form";

export default function Home() {
  return (
    <main>
      <p className="kicker">an iOS app, in the works</p>
      <h1>dialogue</h1>
      <p style={{ fontSize: 21 }}>
        Every screen time app tells you how long.{" "}
        <strong>dialogue tells you whether you meant it.</strong>
      </p>

      <p>
        Sometimes the hand reaches for an app before a decision catches up.
        dialogue gives you a moment to name what you came for, then a chance
        to notice whether it happened.
      </p>

      <div className="card" aria-label="A sample gate card">
        <div className="app-line">
          <span>instagram</span>
          <span>9:47 pm</span>
        </div>
        <p style={{ marginBottom: 8 }}>Why are you opening it?</p>
        <p className="reminder" style={{ marginBottom: 0 }}>
          You wanted evenings for the book.
        </p>
        <div className="chip-row">
          <span className="chip">Reply</span>
          <span className="chip">Look up</span>
          <span className="chip">Post</span>
          <span className="chip honest">Bored</span>
          <span className="chip honest">Avoiding something</span>
        </div>
        <div className="gate-buttons">
          <span className="btn primary">Begin visit</span>
          <span className="btn secondary">Never mind</span>
        </div>
      </div>

      <p>
        On the way in, the gate asks why. When you finish a visit, a debrief asks
        whether that turned out to be true. Two taps, honest options included.
        Bored is a legal entry. The record that accumulates between those two
        questions is the product.
      </p>

      <h2>The one number that matters</h2>
      <p>
        <span className="mono">Intention Match Score</span>: the percentage of
        sessions where what you said going in held up on the way out. Minutes
        cannot tell forty minutes helping a friend from twelve minutes of
        dread-scrolling. IMS can.
      </p>

      <table className="ledger">
        <caption>A week in the ledger (sample)</caption>
        <thead>
          <tr>
            <th>Stated reason</th>
            <th style={{ textAlign: "right" }}>Avg session</th>
            <th style={{ textAlign: "right" }}>Matched</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Reply</td>
            <td className="num">3 min</td>
            <td className="num">92%</td>
          </tr>
          <tr>
            <td>Look up</td>
            <td className="num">4 min</td>
            <td className="num">81%</td>
          </tr>
          <tr>
            <td>Bored</td>
            <td className="num">22 min</td>
            <td className="num">34%</td>
          </tr>
          <tr>
            <td>Avoiding something</td>
            <td className="num">17 min</td>
            <td className="num">28%</td>
          </tr>
        </tbody>
      </table>

      <p>
        Numbers like these do the persuading. No streaks that punish, no
        shame graphs, no minutes wasted counter.
      </p>

      <h2>Three things dialogue refuses to do</h2>
      <p>
        <strong>It never blocks.</strong> Enter is always reachable. Friction
        follows your own match rate after enough reflections. You can always
        continue immediately or pause all gates in Settings.
        <br />
        <strong>It never phones home.</strong> Your reasons and verdicts stay
        on your device. There is no account or cloud sync in version 1.0.
        Export a copy whenever you want.
        <br />
        <strong>Version 1.0 is free.</strong> No subscriptions or in-app
        purchases.
      </p>

      <h2>Get the first entry</h2>
      <p>
        Join the iPhone beta waitlist for an invitation when testing opens.
        We will email you about the beta and launch, with no marketing drip.
      </p>
      <WaitlistForm />

      <p style={{ marginTop: 60 }}>
        <span className="stamp">Logged</span>{" "}
        <span className="stamp red" style={{ transform: "rotate(3deg)" }}>
          On purpose
        </span>
      </p>

      <footer>
        <a href="/privacy">Privacy</a>
        <a href="/support">Support</a>
        <span>dialogue, in progress, {new Date().getFullYear()}</span>
      </footer>
    </main>
  );
}
