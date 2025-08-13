#if canImport(SwiftUI)
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @AppStorage("dailyGoal") var dailyGoal: Int = 10_000
    @State private var showAlert = false
    @State private var tempGoal: String = ""

    var body: some View {
        Form {
            Section(header: Text("目標歩数")) {
                TextField("10000", text: $tempGoal)
                    .keyboardType(.numberPad)
                    .onAppear { tempGoal = String(dailyGoal) }
                    .onDisappear { if let val = Int(tempGoal) { dailyGoal = val } }
            }

            Section {
                Button("データをリセット") {
                    showAlert = true
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("設定")
        .alert("本当にリセットしますか？", isPresented: $showAlert) {
            Button("キャンセル", role: .cancel) {}
            Button("リセット", role: .destructive) {
                viewModel.resetData()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .environmentObject(HomeViewModel.preview)
        }
    }
}
#endif
