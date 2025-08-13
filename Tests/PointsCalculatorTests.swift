import XCTest
@testable import StepPointLite

final class PointsCalculatorTests: XCTestCase {
    func testPointsCalculation() {
        XCTAssertEqual(PointsCalculator.points(for: 0), 0)
        XCTAssertEqual(PointsCalculator.points(for: 999), 0)
        XCTAssertEqual(PointsCalculator.points(for: 1_000), 6)
        XCTAssertEqual(PointsCalculator.points(for: 1_999), 6)
        XCTAssertEqual(PointsCalculator.points(for: 10_000), 60)
        XCTAssertEqual(PointsCalculator.points(for: 20_000), 60)
    }
}
