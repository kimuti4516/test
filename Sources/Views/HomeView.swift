#if canImport(SwiftUI)
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                progressView
                    .frame(width: 200, height: 200)
                    .padding(.top, 40)

                VStack(spacing: 8) {
                    Text("\(viewModel.today.steps)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .accessibilityLabel(Text("今日の歩数"))
                    Text("今日の歩数")
                }

                VStack(spacing: 8) {
                    Text("\(viewModel.today.points)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .accessibilityLabel(Text("今日のポイント"))
                    Text("今日のポイント")
                }

                Text("1000歩ごとに6ポイント、最大60ポイント")
                    .multilineTextAlignment(.center)
                    .padding()

                if let message = viewModel.errorMessage {
                    Text(message)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    var progressView: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 20)
            Circle()
                .trim(from: 0, to: min(Double(viewModel.today.steps) / Double(viewModel.dailyGoal), 1.0))
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: viewModel.today.steps)
            Text("\(min(viewModel.today.steps, viewModel.dailyGoal)) / \(viewModel.dailyGoal)")
                .font(.caption)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("進捗"))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel.preview)
    }
}
#endif
