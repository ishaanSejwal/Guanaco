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
            .Package(url: "https://github.com/antitypical/Result.git", Version(3,2,3)),
            .Package(url: "https://github.com/Quick/Nimble.git", Version(7,0,1)),
        ]
        if isSwiftPackagerManagerTest {
            deps += [
                .Package(url: "https://github.com/Quick/Quick.git", Version(1,1,0))
            ]
        }
        return deps
    }(),
    swiftLanguageVersions: [3]
)
