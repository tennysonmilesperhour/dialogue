# App Store Connect metadata

*Everything App Store Connect asks for, drafted and ready to paste. Section 1
is the store listing, 2 the name question, 3 the ratings and privacy answers,
4 the in-app purchases, 5 the screenshots, 6 the build-side settings, 7 the
open items and who they are blocked on.*

Companion files: REVIEW_NOTES.md (the Review Notes field), PRIVACY_POLICY.md
(the policy the privacy URL serves), ENTITLEMENT_REQUEST.md (Family Controls).

---

## 1. Store listing

**Name (30 char limit)**
```
dialogue
```
Fallback, if taken: `dialogue: intention ledger` (26). See section 2.

**Subtitle (30 char limit)**
```
Did you mean to open that?
```
26 characters. Locked in IDENTITY.md, do not test alternatives before launch.

**Primary category:** Health & Fitness
**Secondary category:** Productivity

Health & Fitness is deliberate. Productivity as primary reads as a utility and
loses the wellbeing browse traffic. Never file under Parental Control or
Education; the entitlement story and the review notes both say this is a
personal tool, and the category should not contradict them.

**Promotional text (170 char limit, editable without review)**
```
The gate asks why you are opening it. The debrief asks whether that held up.
Between the two questions, a record of what your attention was actually for.
```

**Description (4000 char limit)**
```
Every screen time app tells you how long. dialogue tells you whether you
meant it.

You do not open that app because you decided to. A cue fires and the hand
moves. Blockers answer that with a wall, which you resent and eventually
defeat. Trackers answer with a number, which cannot tell forty minutes
helping a friend from twelve minutes of dread-scrolling.

dialogue asks a better question, and it asks twice.

THE GATE
When you open a watched app, a card appears and asks why. Pick a reason or
write one. Bored is a legal entry, and so is Avoiding something. Honest
answers are the point. Punished answers become lies, and lied-to data is
worth nothing.

THE DEBRIEF
When you come back out, dialogue asks whether that turned out to be true.
Yes, Partly, or No. Two taps and it is logged. That is the whole ritual and
it never grows.

THE LEDGER
Between those two questions a record accumulates. Your Intention Match Score
is the percentage of sessions where what you said going in held up on the way
out, per app, over the last fourteen days. Minutes measure duration. IMS
measures integrity.

The weekly review prints the reason cost table:

Reply, average 3 minutes, matched 92 percent
Look up, average 4 minutes, matched 81 percent
Bored, average 22 minutes, matched 34 percent

Nobody needs to be told that is a problem. The numbers do the persuading.
No streaks that punish, no shame graphs, no minutes wasted counter.

WHAT DIALOGUE WILL NOT DO

It never blocks. Enter is always reachable, on every screen, permanently.
What changes is how much friction stands in front of it, and that follows
your own match rate. Earn a high IMS and the gate becomes a whisper.

It never phones home. Your reasons, verdicts and notes stay on your device
unless you turn on Sync. dialogue cannot see which apps you chose, because
Apple hands out opaque tokens instead of names, and we like it that way. No
ads, no profiling, nothing sold to anyone.

It never rents itself to you. One price, once. If you stop using dialogue,
we should not keep charging you for it.

FREE
One watched app, the full gate and debrief, your Intention Match Score, and
fourteen days of history.

DIALOGUE, ONE TIME PURCHASE
Unlimited watched apps, history that never expires, the weekly review, the
adaptive gate, the reason cost table, and export of your whole ledger to CSV
or JSON.

DIALOGUE SYNC, OPTIONAL SUBSCRIPTION
Cross-device sync, cloud backup, the web review, and monthly deep patterns.
Everything that makes dialogue dialogue is in the one-time purchase.

dialogue requires Screen Time authorization to present the gate. It is a
personal tool for the account holder's own device and cannot monitor anyone
else.

SUBSCRIPTION TERMS
dialogue Sync costs 1.99 USD per month or 14.99 USD per year. Payment is
charged to your Apple Account at confirmation of purchase. The subscription
renews automatically unless it is cancelled at least 24 hours before the end
of the current period, and your Apple Account is charged for renewal within
24 hours of the end of the period. Manage or cancel your subscription in your
Apple Account settings after purchase.

Privacy policy: https://dialogue-five.vercel.app/privacy
Terms of use: https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
```

The subscription terms block is not optional garnish. Auto-renewable
subscriptions require price, term, renewal behavior, and links to the privacy
policy and the terms of use to be visible, and metadata rejections for
omitting them are routine.

**Keywords (100 char limit, comma separated, no spaces after commas)**
```
screen time,intention,habit,focus,mindful,scrolling,doomscroll,journal,attention,phone,wellbeing
```
96 characters. Words already in the name and subtitle are indexed separately,
so none of them are repeated here. Deliberately absent: block, blocker,
parental, restrict. Wrong intent, wrong audience, and they invite the review
assumption the notes exist to defuse.

**What's New (version 1.0)**
```
First release. The gate, the debrief, and the ledger that accumulates between
them.
```

**URLs**

Live and serving as of 2026-08-19. Use these values today.

| Field | Value |
|---|---|
| Marketing URL | `https://dialogue-five.vercel.app` |
| Support URL | `https://dialogue-five.vercel.app/support` |
| Privacy Policy URL | `https://dialogue-five.vercel.app/privacy` |

Support and privacy URLs are required before external TestFlight, not just
before submission. All three return 200. This unblocks the week 5 Beta App
Review dependency.

These are interim. `dialogue.app` was the placeholder in earlier drafts and is
not ours: registered 2024-04-28, Cloudflare nameservers, redacted registrant.
Do not put it in App Store Connect. When a domain is secured, point it at the
same Vercel project and replace all three rows here plus the privacy policy
line in the description block above.

**Copyright:** `2026 <account holder or registered entity>`
**Content rights:** contains no third-party content.
**Version release:** Manually release this version. The launch decision waits
on the beta checkpoint (PLAN.md 2.2), and the approval date is not the launch
date.

---

## 2. The name question

App Store Connect enforces exact-string uniqueness across the store in the
primary language, and enforces nothing about trademarks. Two separate risks,
two separate answers.

**What a search of the US store surfaced (2026-08-18):** several live apps
lead with the word, including Dialogue AAC (Prentke Romich), Dialogue Health
(Dialogue Technologies Inc), and Dialogue: Your Chats Live On. None of them
appears to hold the bare string `dialogue`, so the name may well be free. The
search was not exhaustive, and the App Store and USPTO endpoints that would
settle it are unreachable from this environment.

**The authoritative test costs two minutes:** create the App Store Connect
record and type the name. It is accepted or it is not, immediately. Do that
in week 0, calmly, rather than discovering it under submission pressure.

**The trademark question is the real one, and it is not settled by
availability.** Dialogue Health Technologies operates a health and wellness
platform with a live US App Store presence, and dialogue's primary category
is Health & Fitness. Same word, adjacent space, same category shelf. That
combination is what draws a claim, not the app name field.

Recommendation:

1. Claim `dialogue` in App Store Connect if it is free. Reserving it costs
   nothing and keeps the option open.
2. Ship under `dialogue: intention ledger` unless a real clearance search
   comes back clean. The qualified name loses nothing: the wordmark carries
   the brand, the subtitle carries the pitch, and search ranking comes from
   the keyword field. It also distinguishes the listing from a telehealth
   product, which is worth doing regardless.
3. Do not commission brand assets, buy ads, or print anything until a
   trademark attorney has run a proper class 9 and class 44 search. This is
   an hour of a lawyer's time and it is the cheapest insurance in the plan.

Domain strategy lives in IDENTITY.md. Short version after the 2026-08-19
check: `dialogue.app` and every other obvious candidate is already registered
to someone else, so the site runs on the Vercel URL until a domain is bought.

---

## 3. Ratings and privacy answers

### Age rating questionnaire

Every content question answers None or No. dialogue contains no violence, no
sexual content, no profanity, no substances, no gambling, no contests, and no
horror themes. Also:

| Question | Answer |
|---|---|
| Unrestricted web access | No |
| User generated content | No |
| Messaging or chat | No |
| Contests | No |
| In-app purchases | Yes |
| Age assurance | Not applicable |

Expected result 4+. Apple has revised this questionnaire more than once
recently, so answer it live rather than trusting this table, and re-check the
computed rating after submitting the answers.

### App Privacy nutrition label

The label must match the privacy manifest and the actual behavior. It is
audited against the binary, and it is a common cause of rejection when the
two drift.

**Tracking: No.** No data is used to track across apps or websites, no ad
network SDK ships, and no ATT prompt is needed.

| Data type | Collected | Linked to identity | Purpose | When |
|---|---|---|---|---|
| Contact Info, Email Address | Yes | Yes | App Functionality | Only with a Sync account |
| Identifiers, User ID | Yes | Yes | App Functionality | Only with a Sync account |
| User Content, Other | Yes | Yes | App Functionality | Only with a Sync account, the user's own written entries |
| Usage Data, Product Interaction | Yes | No | Analytics | Anonymous aggregate signals through TelemetryDeck |
| Purchases, Purchase History | Yes | No | App Functionality | Purchase validation through RevenueCat |

Explicitly not collected: location, contacts, health and fitness, financial
info, browsing history, search history, sensitive info, photos, audio,
device ID, and crash or performance data (MetricKit reports go to Apple, not
to us, so nothing is declared under Diagnostics).

Two things worth stating plainly in case the answers are ever questioned. The
watched app selections are opaque `ApplicationToken` values that cannot be
resolved to app identities, by Apple's design, so there is no usage data to
declare in the first place. And the waitlist email address collected by the
marketing site is not app data and does not belong on this label.

### Privacy manifest

`PrivacyInfo.xcprivacy` in the app and in every extension target:

- `NSPrivacyTracking`: false
- `NSPrivacyTrackingDomains`: empty
- `NSPrivacyCollectedDataTypes`: matching the table above
- `NSPrivacyAccessedAPITypes` with required reasons: UserDefaults (CA92.1),
  file timestamp (C617.1), disk space (E174.1), system boot time (35F9.1)

RevenueCat, Supabase, and TelemetryDeck ship their own manifests. Keep the
versions current so their declarations stay accurate at submission.

### Export compliance

`ITSAppUsesNonExemptEncryption = NO` in the Info.plist of all five targets.
Standard HTTPS is exempt and dialogue adds no custom cryptography. Setting it
in only the app target and missing the extensions is a known way to stall an
upload.

---

## 4. In-app purchases

All three must exist, be attached to the build, and be submitted with the
first review. IAPs reviewed after the app is approved do not appear on
release day.

### Non-consumable

| Field | Value |
|---|---|
| Product ID | `app.dialogue.ios.unlock` |
| Reference name | dialogue full ledger unlock |
| Type | Non-consumable |
| Display name | dialogue, the full ledger |
| Price | 24.99 USD |

Description:
```
Unlimited watched apps, history that never expires, the weekly review, the
adaptive gate, the reason cost table, and export of your ledger. Paid once,
yours permanently.
```

### Subscription group

Group reference name `dialogue Sync`, display name `dialogue Sync`. One group,
two durations, so a subscriber can move between them without a second
purchase.

| Field | Monthly | Annual |
|---|---|---|
| Product ID | `app.dialogue.ios.sync.monthly` | `app.dialogue.ios.sync.annual` |
| Reference name | dialogue Sync monthly | dialogue Sync annual |
| Duration | 1 month | 1 year |
| Price | 1.99 USD | 14.99 USD |
| Display name | dialogue Sync | dialogue Sync, yearly |

Description, both:
```
Keep your ledger on every device, backed up, with the web review and monthly
deep patterns. Optional. Everything essential to dialogue is in the one-time
purchase.
```

No introductory offer and no free trial. A trial that auto-converts is the
single most-complained-about mechanic in this category (MONETIZATION.md), and
refusing it is a positioning asset, not a missed conversion.

### Paywall requirements

The paywall screen must show, without scrolling: the product name, the price,
the billing term for each subscription option, a restore purchases control, a
link to the privacy policy, and a link to the terms of use. Cancellation
guidance belongs in the first screen of settings, not buried.

Each IAP needs a review screenshot of that paywall and a one-line review note.
Submit all three with the build.

---

## 5. Screenshots

Order is fixed by IDENTITY.md and it is a ranking decision, not a design one.
The first two are what a browsing user actually sees.

1. **The gate card.** The hook and the most-shared artifact in the product.
2. **The debrief with the stamp landing.** The moment nobody else in the
   category has.
3. **The weekly review with the reason cost table.** The proof.
4. **Home, the app rows with their scores.**
5. **The adaptive gate explainer.** Friction as consequence, not constant.

Sizes: produce the 6.9 inch iPhone set, which is the required one and scales
to the other iPhone slots. Add a 6.5 inch set only if it needs different art.
No iPad set is needed while V1 is iPhone only. Apple revises the required
sizes periodically, so confirm in App Store Connect at upload.

Caption discipline: burned-in captions are allowed and useful, but they follow
the voice rules like every other string. No exclamation points, no emoji, no
em dashes, and no shame framing. Numbers do the persuading here too.

---

## 6. App Review Information

- **Sign-in required:** No. The core loop (gate, session, debrief, score) runs
  on the free tier with no account.
- **Demo account:** not needed. If a reviewer wants to exercise Sync, provide
  a Sign in with Apple test account in the notes at that time.
- **Contact:** account holder name, phone, and email.
- **Notes:** paste REVIEW_NOTES.md verbatim. It preempts the three assumptions
  reviewers make about this category (that it blocks, that it is parental
  control, that usage data is collected) and includes the demo script.
- **Attachment:** none required.

---

## 7. Open items

Blocked on the account holder, in the portal:

- [ ] Create the App Store Connect record and learn whether `dialogue` is
      claimable. Everything in section 1 is ready to paste behind it.
- [ ] Trademark clearance with an attorney before any brand spend (section 2).
- [ ] Secure the domain, then replace the three URLs in section 1. Deferred by
      the account holder on 2026-08-19; the live Vercel URLs stand in and are
      sufficient for TestFlight and submission in the meantime.
- [ ] Small Business Program application. The 15 percent rate in
      MONETIZATION.md assumes approval.

Done since this list was written:

- [x] Marketing, support, and privacy URLs live and returning 200 (section 1)
- [x] All five bundle IDs and the `group.app.dialogue` App Group registered
      (D017)
- [x] Family Controls (Distribution) requested, 2026-08-19 (D016)

Blocked on the build:

- [ ] IAP products created and attached (section 4). Needs the app record.
- [ ] Screenshots (section 5). Needs the real screens, which are gated on D012.
- [ ] Privacy manifest and export compliance keys in all five targets
      (section 3). Needs the Xcode project.

Not blocked, done here: sections 1, 2, 3, 4, and 6 are drafted and reviewed
against the voice rules. Nothing in this file needs to wait on the prototype.
