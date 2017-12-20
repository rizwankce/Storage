# Swift Storage

[![CI Status](http://img.shields.io/travis/rizwankce/Storage.svg?style=flat)](https://travis-ci.org/rizwankce/Storage)
[![Version](https://img.shields.io/cocoapods/v/SwiftStorage.svg?style=flat)](http://cocoapods.org/pods/SwiftStorage)
[![License](https://img.shields.io/cocoapods/l/SwiftStorage.svg?style=flat)](http://cocoapods.org/pods/SwiftStorage)
[![Platform](https://img.shields.io/cocoapods/p/SwiftStorage.svg?style=flat)](http://cocoapods.org/pods/SwiftStorage)

If you are using `Coadble` protocol from Swift 4 and needs an easy way to store and retrieve your objects, You are in the right place. Swift Storage is a simple extension to store/retrieve your `Coadble` objects.

## Features

 - [ ] Store Codable objects
 - [ ] Retrieve stored Coadble objects
 - [ ] Store Locations
  - [ ] Cache
  - [ ] Documents
  - [ ] User Default
  - [ ] CloudKit
  - [ ] NSUbiquitousKeyValueStore
 - [ ] Name Spaced Stores
 - [ ] Comprehensive Unit and Integration Test Coverage
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

#### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command in terminal:

```
$ gem install cocoapods
```

To integrate Swift Storage into your Xcode project using CocoaPods, simply add the following line to your Podfile:

```ruby
pod 'SwiftStorage'
```

## Contributing

If you like to contribute to this project, feel free to send PR or raise issues.

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its [terms](https://www.contributor-covenant.org/version/1/3/0/code-of-conduct.html).

## Credits

The idea of Swift Storage is orginally came from Ben Scheirman from [NSScreenCast](http://nsscreencast.com/) and most of the code is inspired from one of his series and extended a little with more options.

## License

Storage is available under the MIT license. See the LICENSE file for more info.
