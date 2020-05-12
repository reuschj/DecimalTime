# DecimalTime

Per Wikipedia, [Decimal time](https://en.wikipedia.org/wiki/Decimal_time) is the representation of the time of day using units which are decimally related.

This package allows you to create a  `DecimalTime`, which can be converted from a `Date` instance or a time interval since midnight of the current day.

## Basic Usage

The basic initializer is `init?(from: Date, using: Calendar)`. Both parameters have default values, so without parameters, you can create a new `DecimalTime` from the current time (using you current system `Calendar`):

```swift
let decimalTime = DecimalTime()
```
Note that all initializers are potentially fallible, but generally should not (behind the scenes, all conversions rely on successfully extracting `DateComponents`, which could fail). All initializers produce an optional `DecimalTime`, so while it's advised to handle as optional, it should _generally_ be safe to force unwrap.

If you have a specific `Date` instance or some calendar other than `Calendar.current`, pass them as a parameters:

```swift
let decimalTime01 = DecimalTime(from: tomorrow)
// or
let decimalTime02 = DecimalTime(using: anotherCalendar)
// or
let decimalTime03 = DecimalTime(from: tomorrow, using: anotherCalendar)
```
To initialize with a decimal time interval since midnight of the current day, use `init?(decimalTimeInterval: DecimalTimeInterval, using: Calendar)`.  `DecimalTimeInterval` is a type alias for `Double`. Like `TimeInterval` is represents a time interval in seconds. However, `DecimalTimeInterval` means that the time interval should be in decimal seconds (1 decimal second = 0.864 seconds).

```swift
let decimalTime = DecimalTime(decimalTimeInterval: 82_540.5)!
print(decimalTime) // Decimal Time: 08:25:40.500.000000
```
To initialize with a time interval (in standard seconds) since midnight of the current day, use `init?(timeInterval: TimeInterval, using: Calendar)`.

You can also specify a time interval in decimal hours using `init?(hourInterval: Double, using: Calendar)`.

```swift
let decimalTime = DecimalTime(hourInterval: 8.25405)!
print(decimalTime) // Decimal Time: 08:25:40.500.000000
```
Last, you can use `init?(hours: Int, minutes: Int, seconds: Int, milliseconds: Int, nanoseconds: Int, using: Calendar)`, which allows you to enter each component separately (enter only the full integer amount). Any omitted time component will be 0 (though you must _always_ specify hours, even if 0).

```swift
let decimalTime = DecimalTime(hours: 8, minutes: 25, seconds: 40, milliseconds: 500)!
print(decimalTime) // Decimal Time: 08:25:40.500.000000
```
If your `DecimalTime` instance is a variable, you can update the time at any time with the `setTime(from: Date)` method. Omit the date parameter to update with the current time.

## DecimalClock

The `DecimalClock` holds a `DecimalTime` that updates on a regular interval (if running).

Initialize a new `DecimalClock` with a `Date` instance, using  `init(from: Date, with: Calendar, start: Bool, updatedEvery: DecimalTimeInterval)`. Omit the `Date` parameter to use the current time.

```swift
let clock01 = DecimalClock()
// or
let clock02 = DecimalClock(from: date, run: true, updatedEvery: 0.1)
```

You can also initialize a new `DecimalClock` with a `DecimalTime` instance, using  `init(from: DecimalTime, with: Calendar, start: Bool, updatedEvery: DecimalTimeInterval)`.

```swift
let clock01 = DecimalClock(from: decimalTime, using: anotherCalendar, run: true)
```

The start parameter will start the clock running on initialization. The updatedEvery parameter specifies how often the `DecimalTime` is refreshed with the current time.  If run is `false` or omitted, the clock can always be started with the `start(updatedEvery: DecimalTimeInterval)` method. The updatedEvery parameter defaults to 1 decimal second (0.864 seconds) if omitted.

When running, the clock can always be stopped with the `stop()` method.
