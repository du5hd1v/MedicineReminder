import SwiftUI

@main
struct MedicineReminderApp: App {
    @StateObject private var store = MedicineStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}
