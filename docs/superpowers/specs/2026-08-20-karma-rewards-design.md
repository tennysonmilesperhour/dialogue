# karma, streaks, and self-set rewards

*Design spec. Status: approved in brainstorming 2026-08-20, not yet planned or
built. Supersedes the "never-mind streak" line in ROADMAP.md week 2 to 4.*

## 1. What this is and why it exists

A karma system: participation points, a forgiving consistency streak, badges,
and a ladder of rewards the user defines and gives themselves.

It exists to answer one hole in the current design. `INTENT.md` sets debrief
completion above 50 percent as the make-or-break beta number, and names the
day 30 retention cliff as the thing to instrument obsessively. Nothing in the
product as specified gives a user a reason to keep logging in week six. The
gate is interesting the first week and habitual by the third. The debrief asks
for effort and, until the weekly review accumulates, returns very little.

Karma is the answer to "why bother on day 34."

**Kill criterion.** If the beta shows no lift in debrief completion against a
cohort without karma, cut the feature. That is the entire justification, so it
should also be the thing that ends it. This becomes D018's reversal condition.

## 2. The name

`karma` is Sanskrit for "action". It is an Indic concept, central to Hindu,
Buddhist and Jain thought, in which intentional action accrues consequence
that shapes what becomes possible later. It reached China with Buddhism and
was absorbed into religious Daoism, most visibly by the Lingbao school around
400 CE. Daoist karma is therefore real but borrowed, not native. Say "karma"
in the product; do not claim it is originally Daoist.

The native Daoist idea that matches this feature most precisely is **dé
(德)**, the second word in the Dao De Jing. Usually rendered "virtue", it
means something closer to accrued efficacy: the potency that collects in
someone who acts in accord with the way, and which makes their action land.
Power accrued by completing an intended action, which makes desired outcomes
more probable, describes dé more exactly than it describes karma.

There is a third and closer ancestor. Ming-dynasty **gōngguò gé (功過格)**,
"Ledgers of Merit and Demerit", were daily account books in which people
tallied their own conduct against their intentions. That is the same object
dialogue is, four hundred years earlier.

**Where dialogue departs from all three, deliberately.** Those ledgers counted
demerits as well as merits. dialogue counts only the merit side. Subtracting
for an honest "No" is precisely the mechanism that teaches a user to lie, and
lied-to data makes IMS worthless (D006). The tradition is the source of the
metaphor, not a specification.

### In-app copy

A "why karma" link on the karma screen, opening a single card:

```
karma is Sanskrit for action. In the traditions that use the word,
intentional action accrues something that makes later action land
better. The Daoists have a nearer word, de, the power that collects
in someone acting in accord with the way.

Four hundred years ago people kept ledgers of merit, tallying their
conduct against their intentions each night. This is that book.

Theirs counted failures too. This one does not.
```

Voice rules apply. No em dash, no exclamation, no emoji. The diacritic in
"dé" is dropped in-app to avoid font fallback on the ledger typeface; keep it
in the docs.

## 3. karma is derived, never stored

The load-bearing structural decision. karma is a pure function of the ledger,
exactly as IMS already is:

```
karma(sessions, schedule, calendar) -> Int
```

No running total in a field anywhere. This buys:

- Immunity to double counting when the extensions replay app-group records
  into SwiftData. Per `PLAN.md` 2.1, extensions append minimal records and the
  main app ingests them; an incrementing counter would drift on replay.
- Correct recomputation after a Sync restore on a second device.
- Unit testability in `DialogueKit` beside the IMS math, which is where
  `PLAN.md` 2.4 already says correctness lives.

### Award schedule

| Event | karma | Cap |
|---|---|---|
| Debrief completed | 10 | none |
| Reason chosen at gate | 2 | 30 per day |
| "Never mind" tapped | 5 | 25 per day |
| Note written on a debrief | 3 | none |

Yes, Partly, and No award identically. This is the rule the whole design rests
on: karma attaches to participation, never to verdict. An honest No is worth
exactly what a Yes is worth, so honesty stays free and IMS stays uncorrupted.

The 5 for a dismissal is not decoration. `INTENT.md` sets gate dismissal above
20 percent as a beta success criterion, and this is the only place in the
product that actively rewards closing the app instead of entering it.

**Caps exist because dismissals are farmable.** Open a watched app, tap "Never
mind", repeat, 5 each time. The daily caps bound the exploit without
constraining honest use: 25 dismissal karma is five dismissals, 30 gate karma
is fifteen gates. Debrief and note karma stay uncapped because completing
debriefs is the behavior that should be unbounded.

Caps and values are provisional and should be tuned against real beta
distributions. They are a schedule struct, not scattered literals, precisely
so tuning is a one-line change.

## 4. Streaks, with grace

A streak is consecutive days containing at least one completed debrief.

`INTENT.md` refuses "streak mechanics that punish". A streak that resets to
zero is punishment, so this one does not.

- **Grace accrues** at one day for every seven consecutive logged days, so a
  fourteen-day run banks two. Held to a maximum of three. The counter for the
  next grace day resets when one is earned, not when one is spent.
- **Grace is spent automatically** on a missed day. The streak survives and
  does not increment for the forgiven day.
- **When grace runs out** the streak rests. It does not break, crash, or turn
  red. Copy: "Streak rested at 12. Best is still 19."
- **Best-ever is never reset.** It is a separate value that only rises.

Grace consumption is derived, not persisted: walk the day sequence in order
from the first logged day, spending banked grace greedily on each gap. Same
input, same answer, every time, on any device.

**Today is never a miss.** Evaluation runs through yesterday. The current day
is pending until it ends, so opening the app at 9am does not show a broken
streak.

Day boundaries use the user's current local calendar. Travel and daylight
saving produce occasional 23 and 25 hour days; the existing IMS window-edge
tests establish the precedent for covering these.

## 5. Badges

Badges reward range and honesty. They never reward score.

This is not a stylistic preference. A badge for reaching 90 percent IMS would
reintroduce exactly the incentive to misreport that section 3 designed out,
through the back door. No badge may reference an IMS threshold.

Starting set:

| Badge | Earned by |
|---|---|
| First entry | First completed debrief |
| Said the quiet part | First session logged with reason "Bored" |
| Called it | First "No" verdict logged |
| Full range | Logged all three verdicts |
| Second thoughts | Ten dismissals |
| A full week | Seven-day streak |
| Hundred entries | One hundred completed debriefs |

Earned state is derived. Only "has the user seen this badge yet" is persisted,
so the screen can mark new ones without recomputing history.

## 6. The reward ladder

Five tiers, escalating. Every label is user-editable at any time, including
before it is earned.

| Level | karma | Default label |
|---|---|---|
| 1 | 100 | a good coffee |
| 2 | 300 | a book you have been putting off |
| 3 | 750 | a night out |
| 4 | 1500 | an expensive steak |
| 5 | 3000 | you decide |

Header copy: "These are suggestions. Yours will be better."

Rewards are honor-system. dialogue cannot and should not verify that anyone
ate a steak. Crossing a threshold surfaces one card naming the reward the user
themselves wrote, with "Mark as claimed" and "Not yet". It never nags, and an
unclaimed reward stays available forever.

**Pacing, and a real problem with it.** A user logging five sessions a day,
two of them with notes, plus two dismissals, earns roughly 76 karma per day.
They reach level 1 in under two days and level 5 near day 40. That is well
aimed: level 5 lands just past the day 30 cliff this feature exists to
survive. But a user logging one session a day earns about 12 per day and does
not reach level 4 for over four months. The spread between light and heavy use
is roughly six to one, which is too wide to serve both.

This is unresolved and should not be guessed at. Options to evaluate against
beta data: thresholds scaled to the user's own baseline rate, a per-day karma
floor for any day with at least one debrief, or simply fewer and closer tiers.
Ship the flat ladder to beta, instrument time-to-level, and fix it with real
distributions rather than intuition.

## 7. Placement, and the two-tap rule

`D010` fixes the debrief at two taps permanently and rejects by default any
feature adding a required tap. karma therefore never introduces a step.

- **Debrief.** The award rides the existing stamp animation (D007). No
  interstitial, no confirmation, no new screen. The delta appears on the stamp
  and the interaction is over.
- **Home.** IMS remains the headline per `D003`. karma sits below it in
  subordinate type: level, total, current streak, one line. If the two numbers
  ever compete for the eye, the one-metric discipline is gone and the fix is
  typographic, not architectural.
- **karma screen.** Reached from that line. Holds the ladder, the badges, the
  streak detail, and the "why karma" card.
- **Onboarding.** One sentence only, setting the expectation that karma only
  accrues. The word invites people to expect bad karma, and this is the
  cheapest place to close that gap. Onboarding is already carrying
  authorization, the picker, per-app naming, and chip setup; it does not get a
  tutorial.

## 8. Data model

Derived, no storage: karma total, level, streak, grace balance, best-ever,
badge earned state.

Persisted, new:

| Entity | Fields | Why |
|---|---|---|
| `RewardTier` | level, threshold, label, claimedAt | The label is user-authored and the claim is a user act. Neither is derivable. |
| `BadgeSeen` | badgeID, seenAt | Only "already shown" needs storing. Earned state is computed. |

`KarmaSchedule` is a value type holding the award amounts and daily caps, not
persisted, so tuning ships as a code change and cannot drift per user.

Free tier. karma, streaks, badges, and the ladder are all available without
purchase. Debrief completion is the number the entire beta turns on, and
putting the retention mechanic behind the paywall would suppress the metric
being measured. Revisit only after the one-time unlock has conversion data.

## 9. Testing

`DialogueKit` unit tests, mirroring the existing `IMSTests` structure:

- Award schedule: each event type, verdict-independence of the debrief award
  (the Yes, Partly, and No cases must assert equality explicitly)
- Cap behavior: at, below, and above each daily cap; caps reset at local
  midnight
- Streak: unbroken run, single gap covered by grace, gap exceeding grace,
  grace accrual at exactly seven days, grace ceiling at three, best-ever
  preserved across a rest, today never counted as a miss
- Calendar edges: 23 and 25 hour days, timezone change mid-streak
- Levels: exact threshold boundaries, karma between tiers, karma past the top
  tier
- Determinism: the same session set produces the same karma and streak on
  repeated evaluation and after a simulated replay of app-group records

Copy lint covers the new strings automatically once they are in tracked files.

## 10. Documents this changes

None of these are edited by this spec. They are the work the implementation
plan must include.

| Document | Change |
|---|---|
| `INTENT.md` | Refuse-list currently reads "the never-mind streak is the only streak". Now false. Reword to refuse punishing streaks and permit forgiving ones. |
| `ROADMAP.md` line 37 | "Home: app rows with IMS, never-mind streak" is superseded. |
| `DECISIONS.md` | Add D018: karma attaches to participation and never to verdict. Reversal condition is the kill criterion in section 1. |
| `IDENTITY.md` | Add `karma` to naming, with the attribution rules from section 2. |
| `ARCHITECTURE.md` | Add `RewardTier` and `BadgeSeen` to the data model. |

**No marketing copy needs rewriting.** `web/app/page.tsx` line 91 and the App
Store description both say "No streaks that punish". Under this design that
remains literally true, which is why the forgiving streak was chosen over the
classic one.

## 11. Risks

1. **A second number in a one-metric product.** This is the real cost. CONTEXT
   says a feature that does not make IMS more accurate or actionable does not
   ship, and karma does neither directly. It is justified only as a retention
   mechanism for the ritual that produces IMS. Mitigated by subordinate
   placement and by the kill criterion.
2. **Overjustification.** `RESEARCH.md` section 5 rests the product on Deci and
   Ryan. Extrinsic reward layered on intrinsically motivated behavior can erode
   the motivation it is meant to support. Participation-only awards reduce this
   considerably, since nothing is paid for a particular answer, but the risk is
   not zero and self-set rewards are the mitigation with the best support
   (Michie BCT taxonomy, self-reward).
3. **Pacing spread.** Section 6. Unresolved by design, to be fixed with data.
4. **Name expectation.** Users will expect karma to fall. Handled with one
   onboarding line and the "why karma" card.
5. **Farming.** Bounded by daily caps, and self-defeating in a single-user
   private tool, but the caps are cheap insurance against the number becoming
   meaningless.

## 12. Open questions

- Thresholds and award values are provisional pending beta distributions.
- Whether badges warrant a visual treatment beyond the ledger stamp language
  already established in D007.
- Whether the karma line belongs on Home at all, or only behind the weekly
  review, if Home starts to feel crowded once app rows and IMS are real.
