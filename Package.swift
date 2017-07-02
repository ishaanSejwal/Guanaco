// swift-tools-version:3.1

import PackageDescription
import Foundation

var isSwiftPackagerManagerTest: Bool {
    return ProcessInfo.processInfo.environment["SWIFTPM_TEST"] == "YES"
}

let package = Package(
    name: "Guanaco",
    dependencies: {
        var deps: [Package.Dependency] = [
            .Package(url: "https://github.com/antitypical/Result.git", majorVersion: 3, minor: 1),
            .Package(url: "https://github.com/Quick/Nimble.git", majorVersion: 5, minor: 1),
            .Package(url: "https://github.com/Quick/Quick.git", majorVersion: 1, minor: 0),
        ]
        if isSwiftPackagerManagerTest {
            deps += [
                .Package(url: "https://github.com/Quick/Quick.git", majorVersion: 1, minor: 0)
            ]
        }
        return deps
    }(),
    swiftLanguageVersions: [3]
)
