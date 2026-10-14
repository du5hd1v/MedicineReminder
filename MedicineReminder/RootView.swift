import SwiftUI

struct RootView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity.combined(with: .scale(scale: 1.04)))
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.45), value: showSplash)
        .task {
            NotificationManager.shared.requestPermission()
            try? await Task.sleep(nanoseconds: 1_700_000_000)
            showSplash = false
        }
    }
}

enum AppTab: Hashable {
    case today
    case add
    case history
}

struct MainTabView: View {
    @State private var selectedTab: AppTab = .today

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem { Label("Today", systemImage: "clock") }
                .tag(AppTab.today)

            AddMedicineView(selectedTab: $selectedTab)
                .tabItem { Label("Add", systemImage: "plus.circle") }
                .tag(AppTab.add)

            HistoryView()
                .tabItem { Label("History", systemImage: "calendar") }
                .tag(AppTab.history)
        }
        .tint(.teal)
    }
}
