//
//  BeAnErrorSpec.swift
//  Guanaco
//
//  Created by Ishaan Sejwal on 24/08/17.
//
//

import Foundation
import Guanaco
import Quick
import Nimble

class BeAnErrorSpec: QuickSpec {
    override func spec() {
        describe("Be an Error") {
            var actual: NSError!
            context("when actual value is nil") {
                it("fails") {
                    let message = assertionMessage {
                        expect(actual).to(beAnError())
                    }
                    expect(message).to(match("beNil()"))
                }
            }
            context("when actual value is not nil") {
                beforeEach {
                    actual = NSError(domain: "bikini.bottom", code: 89017, userInfo: [NSLocalizedDescriptionKey: "Address: 124, Conch Street, Bikini bottom. Loved by: Pattrick. Hated by: Squidward"])
                }
                it("passes for no information for test provided in BeAnError") {
                    expect(actual).to(beAnError())
                }
                it("passes for matching error code and domain") {
                    expect(actual).to(beAnError(domain: match("bikini"), code: beGreaterThan(89016)))
                }
                it("passes for matching error code, domain and description") {
                    expect(actual!).to(beAnError(domain: equal("bikini.bottom"), code: beLessThan(90000), localizedDescription: contain("Pattrick")))
                }
                it("fails for matching error domain, mismatching code and nil description") {
                    let message = assertionMessage {
                        expect(actual).to(beAnError(domain: contain("ini.bot"), code: beLessThan(89017)))
                    }
                    expect(message).to(match("expected to have error code be less than <89017>, got"))
                                    }
                it("fails for mismatching error domain, code and description") {
                    let message = assertionMessage {
                        expect(actual).to(beAnError(domain: match("beach"), code: beGreaterThan(89017), localizedDescription: contain("Krabby Patty")))
                    }
                    expect(message).to(match("expected to"))
                }
            }
        }
    }
}
