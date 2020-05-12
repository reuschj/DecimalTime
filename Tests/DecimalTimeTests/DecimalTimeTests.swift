import XCTest
@testable import DecimalTime

let now = Date()
let calendar = Calendar.current
let nowComponents = now.dateComponents([.hour, .minute, .second, .nanosecond], from: calendar)
let timeIntervalSinceMidnight: TimeInterval = now.timeIntervalSinceMidnight(from: calendar)!
let decimalTimeIntervalSinceMidnight: DecimalTimeInterval = timeIntervalSinceMidnight.decimalTimeInterval
let decimalHours: Double = decimalTimeIntervalSinceMidnight.hours
let hours: Double = floor(decimalHours)
let minutesWithRemainder: Double = (hours == 0 ? decimalHours : decimalHours.truncatingRemainder(dividingBy: hours)) * 100
let minutes: Double = floor(minutesWithRemainder)
let secondsWithRemainder: Double = (minutes == 0 ? minutesWithRemainder : minutesWithRemainder.truncatingRemainder(dividingBy: minutes)) * 100
let seconds: Double = floor(secondsWithRemainder)
let millisecondsWithRemainder: Double = (seconds == 0 ? secondsWithRemainder : secondsWithRemainder.truncatingRemainder(dividingBy: seconds)) * 1_000
let milliseconds: Double = floor(millisecondsWithRemainder)
let nanosecondsWithRemainder: Double = (milliseconds == 0 ? millisecondsWithRemainder : millisecondsWithRemainder.truncatingRemainder(dividingBy: milliseconds)) * 1_000_000
let nanoseconds: Double = floor(nanosecondsWithRemainder)

final class DecimalTimeTests: XCTestCase {
    func testThatInitializersProduceConsistentResults() {
        var time01: DecimalTime?, time02: DecimalTime?, time03: DecimalTime?, time04: DecimalTime?, time05: DecimalTime? = nil
        measure {
            time01 = DecimalTime(from: now, using: calendar)!
            time02 = DecimalTime(decimalTimeInterval: decimalTimeIntervalSinceMidnight, using: calendar)!
            time03 = DecimalTime(timeInterval: timeIntervalSinceMidnight, using: calendar)!
            time04 = DecimalTime(hourInterval: decimalHours, using: calendar)!
            time05 = DecimalTime(hours: Int(hours), minutes: Int(minutes), seconds: Int(seconds), milliseconds: Int(milliseconds), nanoseconds: Int(nanoseconds), using: calendar)!
        }
        print(time01!)
        print(time02!)
        print(time03!)
        print(time04!)
        print(time05!)
        XCTAssertEqual(time01, time02)
        XCTAssertEqual(time02, time03)
        XCTAssertEqual(time03, time04)
        XCTAssertEqual(time04, time05)
    }
    
    func testThatComparisonWorks() {
        var time01: DecimalTime! = nil
        measure {
            time01 = DecimalTime()!
        }
        let time02 = DecimalTime()!
        let time03 = DecimalTime()!
        let time04 = DecimalTime()!
        XCTAssertTrue(time01 < time02)
        XCTAssertTrue(time04 > time03)
    }
    
    func testThatComputationWorks() {
        let time01 = DecimalTime(from: now, using: calendar)!
        let time02 = time01 + 100
        XCTAssertTrue((time01.minutes + 1 == time02.minutes) || (time02.minutes == 0))
        let time03 = time01 - 100
        XCTAssertTrue((time01.minutes - 1 == time03.minutes) || (time03.minutes == 99))
        let time04 = time01 + 10_000
        XCTAssertTrue((time01.hours + 1 == time04.hours) || (time04.hours == 0))
        let time05 = time01 - 10_000
        XCTAssertTrue((time01.hours - 1 == time05.hours) || (time05.hours == 9))
    }
    
    @available(OSX 10.12, *)
    func testThatClockWorks() {
        let expectation = XCTestExpectation()
        let max: Int = 10
        let clock = DecimalClock(from: Date(), with: Calendar.current, start: false, updatedEvery: 1)!
        XCTAssertEqual(clock.running, false)
        clock.start()
        XCTAssertEqual(clock.running, true)
        let initialSeconds = clock.decimalTime.seconds
        var counter = 0
        _ = Timer.scheduledTimer(withTimeInterval: DecimalTime.decimalSecond, repeats: true) { timer in
            counter += 1
            print(counter, clock.decimalTime)
            let actualSeconds = clock.decimalTime.seconds
            let withCounter = initialSeconds + counter
            let expectedSeconds: Int = withCounter < 100 ? withCounter : withCounter - 100
            XCTAssertEqual(actualSeconds, expectedSeconds)
            if counter == max {
                timer.invalidate()
                expectation.fulfill()
                clock.stop()
                XCTAssertEqual(clock.running, false)
            }
        }
        wait(for: [expectation], timeout: (Double(max) + 1).decimalTimeInterval)
    }

    static var allTests = [
        ("testThatInitializersProduceConsistentResults", testThatInitializersProduceConsistentResults),
        ("testThatComparisonWorks", testThatComparisonWorks),
        ("testThatComputationWorks", testThatComputationWorks),
    ]
}
