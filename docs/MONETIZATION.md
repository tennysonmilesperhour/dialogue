# MONETIZATION.md

## The category's structural weakness

Competitor pricing as of 2026:

| App | Price |
|---|---|
| Opal | $19.99/mo or $99.99/yr |
| Freedom | $8.99/mo, $39.99/yr, ~$99 lifetime |
| one sec | ~$4.99/mo, ~$20/yr |
| Jomo | $4.99/mo, $34.99/yr |
| ScreenZen | Free |
| Forest | One-time $3.99 |

Analysis of 1-to-3-star reviews across the five most-installed focus apps found that <cite index="16-1">the single biggest complaint in the category is surprise auto-renewal, prices that feel absurd for what the app does, and cancellation flows that hide the off switch, and that Forest, the one app with a one-time purchase, is the only one users report not resenting paying for.</cite>

Read that as a market instruction. The category has trained users to expect a subscription treadmill on a product they will likely stop using in a month. There is an opening for the app that prices honestly.

## The model

**dialogue Free**
- 1 watched app
- Gate + debrief + IMS
- Last 14 days of history
- No weekly review

**dialogue, one-time $24.99**
- Unlimited watched apps
- Full history, forever
- Weekly review
- Adaptive gate
- Reason cost table and pattern detection
- Export your ledger (CSV / JSON)

**dialogue Sync, $1.99/mo or $14.99/yr, optional**
- Cross-device sync (iPhone + iPad)
- Web review on the marketing domain (currently `dialogue-five.vercel.app`, pending a real domain)
- Cloud backup of the ledger
- Monthly deep patterns (time-of-day, day-of-week, reason drift)

Rationale: the one-time price captures the person who buys hopefully and churns, without generating a resentful review 11 months later. The subscription is genuinely optional and priced against a real recurring cost (Supabase, hosting), which makes it defensible in copy. Nobody feels held hostage, because everything that makes dialogue *dialogue* is in the one-time tier.

**Positioning line for the paywall:** "Pay once. If you stop using dialogue, we shouldn't keep charging you for it."

That sentence is a marketing asset. It is a direct shot at the category's worst behavior and it is quotable in every review and press piece.

## Unit economics sanity check

At $24.99 one-time, Apple takes 15% under the Small Business Program (under $1M/yr), netting ~$21.24.

| Scenario | Downloads yr 1 | Conversion | Revenue |
|---|---|---|---|
| Soft | 5,000 | 5% | ~$5,300 |
| Base | 15,000 | 8% | ~$25,500 |
| Strong | 50,000 | 10% | ~$106,000 |

Add Sync at roughly 15% of paid users: base case adds ~$2,700/yr recurring.

Costs are near zero at this scale: $99/yr Apple, Supabase free-to-$25/mo, Vercel free-to-$20/mo, RevenueCat free under $2.5k monthly tracked revenue, TelemetryDeck free tier.

This is not a venture business at these numbers. It is a profitable solo product that establishes a defensible idea (IMS) and a brand. Judge it on that.

## Pricing tests to run

1. **$19.99 vs $24.99 vs $29.99** one-time, via RevenueCat experiments, from day one of public launch.
2. **Paywall timing.** After first debrief (emotional peak, they just felt the thing work) vs at 7-day mark. Test the first-debrief trigger as the hypothesis.
3. **Free tier boundary.** One app vs two. One app is the bet: the reason cost table only gets interesting across multiple apps, and that table is the upsell.

## What we will not do

- Ads. Not only wrong for the product, it risks the Family Controls entitlement, which Apple reviews specifically for advertising and profiling use.
- Selling or brokering usage data. Same reason, plus it inverts the entire trust proposition.
- Free trial that auto-converts. The single most-complained-about mechanic in the category. If a trial ships at all, it requires an explicit opt-in charge.
- Dark-pattern cancellation. Cancellation link in the first screen of settings.
