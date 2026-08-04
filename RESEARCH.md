# RESEARCH.md

The evidence base. Cite the first two publicly; the rest ground internal design decisions.

## 1. Friction interventions work (the gate)

**Grüning, Riedel & Lorenz-Spreen, PNAS 2023.** Field study of the one sec app. In 36% of attempts, participants closed the target app after the intervention fired, and open attempts dropped 37% over six weeks. The intervention combines three mechanisms: an explicit option to dismiss consumption, friction via a short time delay, and a deliberation message.

**Haliburton et al., CHI 2024** (N=1,039, longitudinal). Confirms friction reduces open attempts and produces more intentional openings over time. Also documents habituation, which is the empirical basis for the adaptive gate.

*Design implications:* all three mechanisms appear in dialogue's gate. The dismiss option is the primary button, not the secondary.

## 2. Implementation intentions (the reason chips)

**Gollwitzer 1999; Gollwitzer & Sheeran 2006** (meta-analysis, d ≈ .65). If-then plans substantially improve goal follow-through. Asking "why are you opening this" converts an automatic habit into a stated intention, which is the active ingredient of the gate.

*Design implication:* the chip must be selected before Enter unlocks. No skip.

## 3. Habit cue disruption (why a brief pause works)

**Wood & Neal 2007; Verplanken & Wood 2006.** Habits run on environmental cues, not goals. The gate interrupts the cue-response loop long enough for the goal system to come back online. This is why the intervention works even though the user can always bypass it.

## 4. Self-monitoring and discrepancy feedback (the debrief)

**Harkin et al. 2016** (meta-analysis on progress monitoring). **Michie et al. 2013** BCT Taxonomy lists self-monitoring as a core behavior change technique. **Carver & Scheier's control theory** frames the debrief as real-time discrepancy feedback between stated intention and observed behavior.

*Design implication:* the stat line must show the discrepancy directly (session length against soft budget, verdict against stated reason) rather than raw totals.

## 5. Autonomy support (why soft beats hard)

**Deci & Ryan, self-determination theory.** Controlling restrictions trigger reactance; autonomy-supportive tools sustain motivation. This is the entire argument for gatekeeper-not-blocker, and the PNAS design backs it: the whole intervention is a self-installed nudge.

*Design implication:* every piece of copy must preserve the user's sense of authorship. The app explains its own tier changes rather than imposing them silently.

## Open questions worth testing in beta

- Does the exit debrief add measurable effect over the entry gate alone? No published study tests the two-sided version. If dialogue's beta shows it does, that is a publishable result and the strongest possible marketing asset.
- Optimal delay length per tier. Existing apps use 5 to 20 seconds with no clear justification.
- Does honest reason-labeling ("Bored") predict session length well enough to surface as a live warning at the gate?
