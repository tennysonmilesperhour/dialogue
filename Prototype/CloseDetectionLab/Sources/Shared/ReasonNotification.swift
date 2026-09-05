import Foundation
import UserNotifications

/// The reason chips as notification actions. Questions 1 and 2 both ride on
/// this notification: its body tap is the "hop into the app" variant, its
/// action buttons are the "no app switch" variant.
enum ReasonNotification {
    static let categoryID = "REASON_GATE"
    static let chipActionPrefix = "chip."
    static let pendingReasonPickerKey = "lab.pendingReasonPicker"
    static let chips = ["Reply", "Look up", "Bored", "Avoiding something"]

    static func registerCategory() {
        let actions = chips.map { chip in
            UNNotificationAction(
                identifier: chipActionPrefix + chip,
                title: chip,
                options: []
            )
        }
        let category = UNNotificationCategory(
            identifier: categoryID,
            actions: actions,
            intentIdentifiers: [],
            options: []
        )
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    static func post() {
        let content = UNMutableNotificationContent()
        content.title = "Why are you opening it?"
        content.body = "Pick a reason, or long press for the chips."
        content.categoryIdentifier = categoryID
        content.sound = nil
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                LabLog.append(source: "shieldaction", name: "notification_post_error",
                              detail: String(describing: error))
            } else {
                LabLog.append(source: "shieldaction", name: "notification_posted")
            }
        }
    }
}
