#if canImport(SwiftUI) && canImport(CoreMotion)
import SwiftUI
import CoreMotion
import Combine

public final class HomeViewModel: ObservableObject {
    @Published public var today: DailyStat
    @Published public var history: [DailyStat]
    @Published public var authorizationStatus: CMAuthorizationStatus = .notDetermined
    @Published public var errorMessage: String?

    @AppStorage("dailyGoal") public var dailyGoal: Int = 10_000

    private let pedometerService: PedometerService
    private let storage: StorageService
    private let dateService: DateService

    public init(pedometerService: PedometerService = PedometerService(),
                storage: StorageService = .shared,
                dateService: DateService = DateService(),
                isPreview: Bool = false) {
        self.pedometerService = pedometerService
        self.storage = storage
        self.dateService = dateService

        self.today = storage.loadCurrent() ?? DailyStat(date: Date(), steps: 0, points: 0)
        self.history = storage.loadHistory()

        if dateService.needsRollover(from: today.date) {
            dateService.rollOverIfNeeded(current: &today, history: &history)
        }

        storage.saveCurrent(today)
        storage.saveHistory(history)

        if !isPreview {
            start()
        }
    }

    public func start() {
        checkAuthorization()
        pedometerService.startUpdates { [weak self] steps, error in
            guard let self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            guard let steps = steps else { return }
            self.today.steps = steps
            self.today.points = PointsCalculator.points(for: steps)
            self.dateService.rollOverIfNeeded(current: &self.today, history: &self.history)
            self.storage.saveCurrent(self.today)
            self.storage.saveHistory(self.history)
        }
    }

    public func refresh() {
        checkAuthorization()
        pedometerService.queryToday { [weak self] steps, error in
            guard let self else { return }
            if let steps = steps {
                self.today.steps = steps
                self.today.points = PointsCalculator.points(for: steps)
            }
            if let error = error {
                self.errorMessage = error.localizedDescription
            }
            self.dateService.rollOverIfNeeded(current: &self.today, history: &self.history)
            self.storage.saveCurrent(self.today)
            self.storage.saveHistory(self.history)
        }
    }

    public func stop() {
        pedometerService.stopUpdates()
    }

    public func resetData() {
        today = DailyStat(date: Date(), steps: 0, points: 0)
        history = []
        storage.clearAll()
    }

    private func checkAuthorization() {
        authorizationStatus = CMPedometer.authorizationStatus()
        if authorizationStatus == .denied {
            errorMessage = NSLocalizedString("PedometerDenied", comment: "")
        } else {
            errorMessage = nil
        }
    }

    public var weeklyStats: [DailyStat] {
        var stats = history
        stats.append(today)
        if stats.count > 7 {
            stats = Array(stats.suffix(7))
        }
        return stats
    }
}
#endif

#if canImport(SwiftUI)
extension HomeViewModel {
    public static var preview: HomeViewModel {
        let vm = HomeViewModel(isPreview: true)
        vm.today = DailyStat(date: Date(), steps: 5_000, points: PointsCalculator.points(for: 5_000))
        vm.history = (1...6).map { offset in
            let date = Calendar.current.date(byAdding: .day, value: -offset, to: Date())!
            let steps = offset * 1_000
            return DailyStat(date: date, steps: steps, points: PointsCalculator.points(for: steps))
        }.reversed()
        return vm
    }
}
#endif
