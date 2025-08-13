import Foundation

public enum PointsCalculator {
    public static func points(for steps: Int) -> Int {
        let capped = min(steps, 10_000)
        return (capped / 1000) * 6
    }
}
