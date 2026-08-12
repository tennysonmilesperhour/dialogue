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
        You do not open Instagram because you decided to. A cue fires and the
        hand moves. Blockers answer that with a wall, which you resent and
        defeat. Trackers answer with a number, which tells you nothing about
        whose time that was. dialogue asks a better question, twice.
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
          <span className="btn primary">Never mind</span>
          <span className="btn secondary">Enter</span>
        </div>
      </div>

      <p>
        On the way in, the gate asks why. On the way out, a debrief asks
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
        follows your own match rate: earn an 85% IMS and the gate becomes a
        whisper.
        <br />
        <strong>It never phones home.</strong> Your reasons and verdicts stay
        on your device unless you choose to sync them. We cannot even see
        which apps you picked; Apple designed it that way and we like it.
        <br />
        <strong>It never rents itself to you.</strong> One price, once.{" "}
        <em>If you stop using dialogue, we should not keep charging you for
        it.</em>
      </p>

      <h2>Get the first entry</h2>
      <p>
        iOS beta opens soon, 50 seats. The waitlist is the queue and nothing
        else; one address, no marketing drip.
      </p>
      <WaitlistForm />

      <p style={{ marginTop: 60 }}>
        <span className="stamp">Logged</span>{" "}
        <span className="stamp red" style={{ transform: "rotate(3deg)" }}>
          Dismissed +1
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
