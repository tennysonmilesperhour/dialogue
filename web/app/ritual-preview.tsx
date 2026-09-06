"use client";

import { useRef, useState } from "react";

const reasons = ["Reply", "Look up", "Post", "Bored", "Avoiding something"];

export default function RitualPreview() {
  const [step, setStep] = useState<"gate" | "reflect" | "logged" | "away">(
    "gate",
  );
  const [reason, setReason] = useState("Reply");
  const [verdict, setVerdict] = useState("");
  const heading = useRef<HTMLHeadingElement>(null);

  function changeStep(next: typeof step) {
    setStep(next);
    requestAnimationFrame(() => heading.current?.focus());
  }

  return (
    <section
      className="ritual-preview"
      aria-label="Interactive product preview"
    >
      <div className="preview-caption">
        <span>Try a sample visit</span>
        <span>Nothing is saved</span>
      </div>
      <div className="card preview-card">
        <div className="app-line">
          <span>instagram</span>
          <span>Sample entry / 001</span>
        </div>
        <div
          className="preview-progress"
          aria-label={
            step === "gate"
              ? "Step 1 of 2: intention"
              : "Step 2 of 2: reflection"
          }
        >
          <span className={step === "gate" ? "current" : ""}>
            01 / Intention
          </span>
          <span className={step === "reflect" ? "current" : ""}>
            02 / Reflection
          </span>
        </div>
        <h2 ref={heading} tabIndex={-1} className="preview-title">
          {step === "gate"
            ? "Why are you opening it?"
            : step === "reflect"
              ? "Did it go as intended?"
              : step === "away"
                ? "A choice, recorded."
                : "One visit, understood."}
        </h2>
        {step === "gate" && (
          <>
            <p className="reminder">A reply. A quick look. Or just bored.</p>
            <fieldset>
              <legend className="sr-only">Choose an intention</legend>
              <div className="chip-row">
                {reasons.map((item) => (
                  <button
                    key={item}
                    type="button"
                    className={`chip ${reason === item ? "selected" : ""}`}
                    aria-pressed={reason === item}
                    onClick={() => setReason(item)}
                  >
                    {item}
                  </button>
                ))}
              </div>
            </fieldset>
            <p className="preview-aside">Honest reasons belong here, too.</p>
            <div className="gate-buttons">
              <button
                className="btn secondary"
                onClick={() => changeStep("away")}
              >
                Never mind
              </button>
              <button
                className="btn primary"
                onClick={() => changeStep("reflect")}
              >
                Enter with intention
              </button>
            </div>
          </>
        )}
        {step === "reflect" && (
          <>
            <p>
              You opened it to <strong>{reason.toLowerCase()}</strong>.
            </p>
            <p className="preview-aside">
              Imagine the visit has ended. Did it match?
            </p>
            <div className="verdict-buttons">
              {["Yes", "Partly", "No"].map((item) => (
                <button
                  key={item}
                  className="btn secondary"
                  onClick={() => {
                    setVerdict(item);
                    changeStep("logged");
                  }}
                >
                  {item}
                </button>
              ))}
            </div>
            <p className="preview-aside">
              No right answer. Just a useful record.
            </p>
          </>
        )}
        {(step === "logged" || step === "away") && (
          <>
            <span className="stamp">
              {step === "away" ? "Walked away" : "Logged"}
            </span>
            <p className="sample-result">
              {step === "away"
                ? "You chose not to open it. That belongs in the ledger, too."
                : `${reason} · ${verdict}. Your reflection is the part a screen time total cannot tell you.`}
            </p>
            <p className="preview-aside">
              In the app, these entries become your private weekly review.
            </p>
          </>
        )}
        {step !== "gate" && (
          <button className="text-button" onClick={() => changeStep("gate")}>
            Try another intention
          </button>
        )}
      </div>
      <p className="preview-footnote">
        A simplified preview. On iPhone, your gate adds a short pause and your
        reflection follows a soft budget or a visit you end yourself.
      </p>
    </section>
  );
}
