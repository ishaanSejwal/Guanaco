import XCTest
import Quick

@testable import GuanacoTests

Quick.QCKMain([
    HaveFailedSpec.self,
    HaveSucceededSpec.self,
])
