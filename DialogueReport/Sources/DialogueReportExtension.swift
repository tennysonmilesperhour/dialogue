import DeviceActivity
import DialogueKit
import SwiftUI

/// Usage figures, display only.
///
/// Apple renders this scene in its own sandboxed view. It cannot hand
/// numbers back to the app or write to shared storage, so nothing in the
/// session pipeline may depend on it. It shows figures; it never sources
/// them.
@main
struct DialogueReportExtension: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        TotalActivityReport { total in
            TotalActivityView(total: total)
        }
    }
}

struct TotalActivityReport: @preconcurrency DeviceActivityReportScene {
    let context: DeviceActivityReport.Context = .init(rawValue: "Total activity")
    let content: (String) -> TotalActivityView

    func makeConfiguration(
        representing data: DeviceActivityResults<DeviceActivityData>
    ) async -> String {
        var total: TimeInterval = 0
        for await result in data {
            for await segment in result.activitySegments {
                total += segment.totalActivityDuration
            }
        }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter.string(from: total) ?? "0m"
    }
}

struct TotalActivityView: View {
    let total: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Time in watched apps")
                .font(.system(.footnote, design: .monospaced))
            Text(total)
                .font(.system(.title, design: .monospaced))
                .monospacedDigit()
        }
        .foregroundStyle(Color.ink)
    }
}
