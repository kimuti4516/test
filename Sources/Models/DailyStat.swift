import Foundation

public struct DailyStat: Identifiable, Codable {
    public let id: Date
    public var date: Date
    public var steps: Int
    public var points: Int

    public init(date: Date, steps: Int, points: Int) {
        self.id = date
        self.date = date
        self.steps = steps
        self.points = points
    }
}
