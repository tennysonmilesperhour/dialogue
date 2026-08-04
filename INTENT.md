# INTENT.md

## The problem in one paragraph

People do not open Instagram because they decided to. They open it because a cue fired and the hand moved. Existing tools respond by taking the phone away, which produces reactance and gets defeated, or by reporting minutes at the end of the week, which produces shame and no information. Neither tells you the thing you actually want to know: was that time mine, or did it happen to me?

## What dialogue is trying to change

Not screen time. Screen time is a bad target because 40 minutes replying to a friend is good and 12 minutes of dread-scrolling is bad, and the number cannot tell them apart.

The target is the gap between stated intention and actual behavior. Close that gap and screen time falls as a side effect, but more importantly the remaining time stops feeling stolen.

## Success criteria

**Beta (first 50 users, 6 weeks)**
- Debrief completion rate above 50%. This is the make-or-break number. If people skip the debrief, dialogue is just a worse one sec.
- Gate dismissal rate above 20% (taps of "Never mind" per 100 gates).
- Week-6 retention above 30%.
- IMS trends upward for a majority of users who complete 3+ weeks.

**Year one**
- 10,000 downloads, 8% paid conversion.
- Retention curve that does not collapse at day 30, which is where every friction competitor dies. This is the thing to instrument obsessively.
- At least one credible press or podcast placement built on the IMS idea, not on "another screen time app."

## What we refuse to build

- **Hard blocking.** Ever. It contradicts the autonomy-support thesis and puts us in a bypass arms race we cannot win.
- **Social feeds, leaderboards, friend accountability.** V1 and V2. This is a private conversation with yourself. Shame is a competitor's business model.
- **Streak mechanics that punish.** The never-mind streak is the only streak, and breaking it costs nothing.
- **AI-written insights in V1.** One rule-based pattern per week, written in plain language. AI summaries can come later and only if they beat the rules.
- **Guilt copy.** No "you've wasted X hours." Ever. Read IDENTITY.md before writing a single string.
- **Parental controls / monitoring another person.** Different product, different App Store category, different trust model.
- **Android before iOS is retained and monetized.** One platform done well.

## The honest risk list

1. **Debrief compliance.** Users may state an intention happily and refuse to be graded on it. Mitigation: two taps, no punishment for a No, and framing the No verdict as data rather than failure. If beta debrief completion lands below 35%, the concept needs rework before spend.
2. **Apple's Screen Time API cannot reliably detect app close.** Confirmed limitation. Mitigation and fallbacks in ARCHITECTURE.md. This is the single biggest technical unknown and must be de-risked in week one with a throwaway prototype.
3. **Entitlement approval delay.** Reported anywhere from four business days to several weeks, per bundle ID including every extension. Mitigation: submit day one, all bundle IDs at once, build against the development entitlement in parallel.
4. **Self-report noise.** Users may grade themselves generously. Accepted. The act of grading is the intervention; accuracy is secondary.
5. **Category price fatigue.** Addressed in MONETIZATION.md.
