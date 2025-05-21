# Swift Storage

If you are using `Coadble` protocol from Swift 4 and needs an easy way to store and retrieve your objects, You are in the right place. Swift Storage is a simple extension to store/retrieve your `Coadble` objects.

## Features

- [x] Store Codable objects
- [x] Retrieve stored Coadble objects
- [ ] Store Locations
- [x] Cache
- [x] Documents
- [x] User Default
- [ ] CloudKit
- [x] NSUbiquitousKeyValueStore
- [ ] Name Spaced Stores
- [x] Comprehensive Unit and Integration Test Coverage
- [ ] Complete Documentation

## Usage

Considering you have a Coadble `Job` struct like below

```swift
struct Job: Codable {
    let company: String
    let position: String
    let description: String
    let url: String
}
```

To save or retrieve array of `Job`

```swift
// Create a instance of `Storage` with a type and file name
let storage: Storage<[Job]> = Storage(storageType: .document, filename: "remote-jobs.json")

// To Save array of `Job`
storage.save([job1, job2])

// To retrieve stored values of jobs
let jobs = storage.storedValue
```
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

 - Xcode 9.0+
 - Swift 4

## Installation

#### Swift Package Manager
The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

To integrate Swift Storage into your Xcode project using Swift Package Manager, add the following as a dependency to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/rizwankce/Storage.git", from: "0.1.0")
]
```

Then, add `SwiftStorage` as a dependency of your target:

```swift
.target(
    name: "YourTargetName",
    dependencies: ["SwiftStorage"]),
```

## Contributing

If you like to contribute to this project, feel free to send PR or raise issues.

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its [terms](https://www.contributor-covenant.org/version/1/3/0/code-of-conduct.html).

## Credits

The idea of Swift Storage is orginally came from Ben Scheirman from [NSScreenCast](http://nsscreencast.com/) and most of the code is inspired from one of his series and extended a little with more options.

## License

Storage is available under the MIT license. See the LICENSE file for more info.
