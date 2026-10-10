import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    func scheduleReminder(for medicine: Medicine) {
        let content = UNMutableNotificationContent()
        content.title = "Dose due: \(medicine.name)"
        content.body = "\(medicine.dosage) now. \(medicine.notes.isEmpty ? "Open DoseMate to mark it as taken." : medicine.notes)"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = medicine.hour
        dateComponents.minute = medicine.minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: medicine.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func cancelReminder(for medicine: Medicine) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [medicine.id.uuidString])
    }
}
