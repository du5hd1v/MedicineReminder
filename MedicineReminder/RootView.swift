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

struct MainTabView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "clock") }
            AddMedicineView()
                .tabItem { Label("Add", systemImage: "plus.circle") }
            HistoryView()
                .tabItem { Label("History", systemImage: "calendar") }
        }
        .tint(.teal)
    }
}
