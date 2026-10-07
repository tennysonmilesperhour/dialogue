import DialogueKit
import DeviceActivity
import ManagedSettings
import SwiftUI

struct WeeklyReviewView: View {
    @ObservedObject var model: DialogueModel
    @Environment(\.dynamicTypeSize) private var textSize
    private var summary: LedgerInsights { LedgerInsights(state: model.state) }

    var body: some View {
        NavigationStack {
            LedgerPage {
                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {
                        DialogueHeader(kicker: "Seven days, a little clearer", title: "Your week\nin intentions.")
                        Text(summary.sessions.isEmpty ? "A pattern starts with a single visit." : "\(summary.reflectionCount) reflections. A little more to work with.")
                            .font(.system(.title3, design: .serif)).lineSpacing(3)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), alignment: .leading), count: textSize.isAccessibilitySize ? 1 : 2), spacing: 12) {
                            metric("Visits", value: String(summary.sessions.count))
                            metric("Intention match", value: summary.match.map(IMS.displayString) ?? "Not yet")
                        }
                        activityChart
                        if let current = summary.match, let previous = summary.previousMatch {
                            let difference = Int(((current - previous) * 100).rounded())
                            Text(difference == 0 ? "Your match rate is unchanged from the previous seven days." : "Your match rate is \(abs(difference)) percentage points \(difference > 0 ? "higher" : "lower") than the previous seven days.")
                                .font(.system(.body, design: .serif))
                        }
                        reasonTable
                        if !model.isSample && model.hasScreenTimeAuthorization && !model.state.watchedApps.isEmpty { usageReport }
                        LedgerCard {
                            VStack(alignment: .leading, spacing: 14) {
                                SectionLabel(text: "Take one thought forward")
                                Text(summary.reasons.first.map { "“\($0.name)” came up \($0.visits) times. What would make the next visit worthwhile?" }
                                     ?? "Which app would you like to open a little more on purpose?")
                                    .font(.system(.title3, design: .serif)).lineSpacing(3)
                                Text("You do not need a perfect week to learn from it.")
                                    .font(.system(.footnote, design: .serif)).foregroundStyle(Color.ink.opacity(0.75))
                            }
                        }
                    }.padding(.vertical, 24)
                }
            }.toolbar(.hidden, for: .navigationBar)
        }
    }
    private func metric(_ label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(value).font(.system(.largeTitle, design: .serif)).monospacedDigit()
            Text(label.uppercased()).font(.system(.caption, design: .monospaced))
        }.frame(maxWidth: .infinity, alignment: .leading).padding(16)
            .overlay { Rectangle().stroke(Color.ink.opacity(0.45), lineWidth: 1) }
            .accessibilityElement(children: .ignore).accessibilityLabel("\(label), \(value)")
    }
    private var activityChart: some View {
        VStack(alignment: .leading, spacing: 18) {
            SectionLabel(text: "Room to reflect")
            HStack(alignment: .bottom, spacing: 10) {
                ForEach(summary.days) { day in
                    VStack(spacing: 10) {
                        Text("\(day.visits)").font(.system(.caption2, design: .monospaced))
                        ZStack(alignment: .bottom) {
                            Rectangle().fill(Color.ink.opacity(0.10))
                            Rectangle().fill(Color.ledgerGreen)
                                .frame(height: barHeight(day) * Double(day.reflections) / Double(max(1, day.visits)))
                        }.frame(height: barHeight(day))
                        Text(day.date, format: .dateTime.weekday(.narrow))
                            .font(.system(.caption, design: .monospaced))
                    }.frame(maxWidth: .infinity).accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(day.date.formatted(.dateTime.weekday(.wide))), \(day.visits) visits, \(day.reflections) reflections")
                }
            }.frame(height: 145, alignment: .bottom)
            Label("Filled bars show reflected visits", systemImage: "square.fill")
                .font(.system(.caption, design: .serif)).foregroundStyle(Color.ledgerGreen)
            Rule()
        }
    }
    private func barHeight(_ day: LedgerInsights.Day) -> Double {
        max(3, Double(day.visits) / Double(max(1, summary.days.map(\.visits).max() ?? 1)) * 95)
    }
    private var reasonTable: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionLabel(text: "What brought you here")
            if summary.reasons.isEmpty {
                Text("Your intentions will collect here as you use dialogue. No entry is needed for days you spend elsewhere.")
                    .font(.system(.body, design: .serif))
            }
            ForEach(summary.reasons) { reason in
                VStack(alignment: .leading, spacing: 8) {
                    Text(reason.name).font(.system(.title3, design: .serif))
                    Text("\(reason.visits) visits · \(reason.averageMinutes.map { "about \($0) min each" } ?? "still open")")
                        .font(.system(.caption, design: .monospaced)).foregroundStyle(Color.ink.opacity(0.75))
                    HStack {
                        Text("Intention match").font(.system(.footnote, design: .serif))
                        Spacer()
                        Text(reason.match.map(IMS.displayString) ?? "Not yet").font(.system(.body, design: .monospaced))
                    }
                    Rule()
                }
            }
            Text("Visit lengths are approximate elapsed time, including time away from the app. Only reflected visits count toward match.")
                .font(.system(.caption, design: .serif)).foregroundStyle(Color.ink.opacity(0.75))
        }
    }
    private var usageReport: some View {
        LedgerCard {
            VStack(alignment: .leading, spacing: 10) {
                SectionLabel(text: "From Screen Time")
                DeviceActivityReport(DeviceActivityReport.Context(rawValue: "Total activity"), filter: usageFilter)
                    .frame(minHeight: 80)
                Text("Apple's usage total may differ from elapsed visit lengths above.")
                    .font(.system(.caption, design: .serif))
            }
        }
    }
    private var usageFilter: DeviceActivityFilter {
        let start = Calendar.current.date(byAdding: .day, value: -6, to: Calendar.current.startOfDay(for: Date())) ?? Date()
        return DeviceActivityFilter(segment: .daily(during: DateInterval(start: start, end: Date())),
                                    applications: Set(model.state.watchedApps.compactMap { ScreenTimeTokenCodec.decode($0.applicationTokenData) }))
    }
}
