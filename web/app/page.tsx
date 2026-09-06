import WaitlistForm from "./waitlist-form";
import RitualPreview from "./ritual-preview";

// Availability follows server configuration at request time, including after a deploy.
export const dynamic = "force-dynamic";

export default function Home() {
  const siteKey =
    process.env.SUPABASE_URL &&
    process.env.SUPABASE_SERVICE_ROLE_KEY &&
    process.env.TURNSTILE_SECRET_KEY
      ? (process.env.TURNSTILE_SITE_KEY ?? null)
      : null;
  return (
    <>
      <a className="skip-link" href="#main">
        Skip to content
      </a>
      <header className="site-header">
        <a className="wordmark" href="/" aria-label="dialogue home">
          dialogue<span aria-hidden="true">.</span>
        </a>
        <nav aria-label="Main navigation">
          <a href="#how-it-works">The idea</a>
          <a href="#first-entry">
            Beta access <span aria-hidden="true">↗</span>
          </a>
        </nav>
      </header>
      <main id="main" className="landing">
        <section className="hero" aria-labelledby="hero-title">
          <div className="hero-copy">
            <p className="kicker">A private ledger for your attention</p>
            <h1 id="hero-title">
              A little less
              <br />
              autopilot.
              <br />
              <em>
                A little more
                <br />
                on purpose.
              </em>
            </h1>
            <p className="hero-description">
              Name why you are opening an app. Reflect on whether it held up.
              Find out which visits were worth having.
            </p>
            <a className="btn primary cta" href="#first-entry">
              Find your first entry <span aria-hidden="true">↗</span>
            </a>
            <p className="hero-note">
              For iPhone · In development · Free first release
            </p>
          </div>
          <RitualPreview />
        </section>

        <section
          id="how-it-works"
          className="how-section"
          aria-labelledby="how-title"
        >
          <div className="section-heading">
            <p className="kicker">The two sides of a visit</p>
            <h2 id="how-title">
              Minutes tell one story.
              <br />
              Your intention tells another.
            </h2>
          </div>
          <div className="steps">
            <article>
              <span className="step-number">01</span>
              <h3>Name it.</h3>
              <p>
                Choose an app and give it a name. Before a visit, pick the
                reason that is true right now. Bored is a valid answer.
              </p>
            </article>
            <article>
              <span className="step-number">02</span>
              <h3>Notice it.</h3>
              <p>
                When your reflection is ready, answer Yes, Partly, or No. No
                essay required. You can always come back to it.
              </p>
            </article>
            <article>
              <span className="step-number">03</span>
              <h3>Learn from it.</h3>
              <p>
                Your ledger connects reasons with outcomes. A weekly review
                helps you decide what you want to repeat.
              </p>
            </article>
          </div>
        </section>

        <section className="review-section" aria-labelledby="review-title">
          <div>
            <p className="kicker">The value is in the record</p>
            <h2 id="review-title">
              Same phone.
              <br />A clearer picture.
            </h2>
            <p>
              Forty minutes helping a friend and twelve minutes scrolling can
              feel very different. Your Intention Match Score starts with what
              you meant to do.
            </p>
            <p className="score-explanation">
              Over 14 days, Yes counts in full and Partly counts half. Unlogged
              visits are left out. A score is a description, not a grade.
            </p>
          </div>
          <div className="ledger-sheet">
            <table className="ledger">
              <caption>An illustrative week, not user data</caption>
              <thead>
                <tr>
                  <th scope="col">Reason</th>
                  <th scope="col">Avg. visit</th>
                  <th scope="col">Match</th>
                </tr>
              </thead>
              <tbody>
                {[
                  ["Reply", "3 min", "92%"],
                  ["Look up", "4 min", "81%"],
                  ["Bored", "22 min", "34%"],
                  ["Avoiding something", "17 min", "28%"],
                ].map(([reason, duration, score]) => (
                  <tr key={reason}>
                    <th scope="row">{reason}</th>
                    <td className="num">{duration}</td>
                    <td className="num">{score}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            <p className="preview-aside">
              Visit lengths are approximate. Your own reflection determines the
              match.
            </p>
            <span className="stamp">For your eyes</span>
          </div>
        </section>

        <section className="principles" aria-label="Our commitments">
          <article>
            <h3>You keep the choice.</h3>
            <p>
              Gates add a pause, not a daily lockout. Pause all gates whenever
              you want.
            </p>
          </article>
          <article>
            <h3>Your ledger stays yours.</h3>
            <p>
              No account, ads, or app analytics. Your entries stay on your
              iPhone.
            </p>
          </article>
          <article>
            <h3>No subscription surprise.</h3>
            <p>
              The first release is free. There is no subscription or cloud sync
              in this version.
            </p>
          </article>
        </section>

        <section
          id="first-entry"
          className="signup-section"
          aria-labelledby="signup-title"
        >
          <div>
            <p className="kicker">Your next visit can be different</p>
            <h2 id="signup-title">Start with one intention.</h2>
            <p>
              We are preparing the iPhone beta. A small group, a useful record,
              and room to get it right.
            </p>
          </div>
          <div>
            <WaitlistForm siteKey={siteKey} />
          </div>
        </section>
        <footer>
          <a className="wordmark" href="/">
            dialogue.
          </a>
          <span>A conversation with yourself.</span>
          <a href="/privacy">Privacy</a>
          <a href="/support">Support</a>
        </footer>
      </main>
    </>
  );
}
