#if canImport(CoreMotion)
import Foundation
import CoreMotion

public final class PedometerService {
    private let pedometer = CMPedometer()

    public init() {}

    public func startUpdates(handler: @escaping (Int?, Error?) -> Void) {
        let start = Calendar.current.startOfDay(for: Date())
        pedometer.startUpdates(from: start) { data, error in
            DispatchQueue.main.async {
                if let steps = data?.numberOfSteps.intValue {
                    handler(steps, nil)
                } else {
                    handler(nil, error)
                }
            }
        }
    }

    public func queryToday(handler: @escaping (Int?, Error?) -> Void) {
        let start = Calendar.current.startOfDay(for: Date())
        pedometer.queryPedometerData(from: start, to: Date()) { data, error in
            DispatchQueue.main.async {
                if let steps = data?.numberOfSteps.intValue {
                    handler(steps, nil)
                } else {
                    handler(nil, error)
                }
            }
        }
    }

    public func stopUpdates() {
        pedometer.stopUpdates()
    }
}
#endif
