#if canImport(SwiftUI)
import SwiftUI
import CoreMotion

@main
struct StepPointLiteApp: App {
    @StateObject private var homeVM = HomeViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem { Label("ホーム", systemImage: "figure.walk") }
                HistoryView()
                    .tabItem { Label("履歴", systemImage: "chart.bar") }
                SettingsView()
                    .tabItem { Label("設定", systemImage: "gear") }
            }
            .environmentObject(homeVM)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                homeVM.refresh()
            default:
                homeVM.stop()
            }
        }
    }
}
#endif
