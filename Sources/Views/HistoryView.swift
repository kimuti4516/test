#if canImport(SwiftUI)
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(viewModel.weeklyStats) { stat in
                        VStack {
                            Text("\(stat.steps)")
                                .font(.caption2)
                            Rectangle()
                                .fill(Color.green)
                                .frame(height: barHeight(for: stat, totalHeight: geo.size.height * 0.5))
                            Text(shortDate(stat.date))
                                .font(.caption2)
                            Text("\(stat.points)")
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                Spacer()
            }
            .padding()
        }
    }

    func barHeight(for stat: DailyStat, totalHeight: CGFloat) -> CGFloat {
        let ratio = min(CGFloat(stat.steps) / CGFloat(viewModel.dailyGoal), 1.0)
        return totalHeight * ratio
    }

    func shortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("Md")
        return formatter.string(from: date)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(HomeViewModel.preview)
    }
}
#endif
