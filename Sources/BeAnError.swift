import Foundation
import Nimble

// MARK: Public

/**
  A Nimble matcher that succeeds when the NSError matches all
  of the specified conditions.

  :param: domain An assertion to be made on the error domain.
                 If nil, no assertion is made.
  :param: code An assertion to be made on the error code.
                 If nil, no assertion is made.
  :param: localizedDescription An assertion to be made on the error's
                               localized description. If nil, no assertion
                               is made.
*/
//public func beAnError(domain: NonNilMatcherFunc<String>? = nil, code: NonNilMatcherFunc<Int>? = nil, localizedDescription: NonNilMatcherFunc<String>? = nil) -> NonNilMatcherFunc<NSError> {
//  return beAnErrorMatcherFunc(
//    domain: MatcherClosure { try domain?.matches($0, failureMessage: $1) },
//    code: MatcherClosure { try code?.matches($0, failureMessage: $1) },
//    localizedDescription: MatcherClosure { try localizedDescription?.matches($0, failureMessage: $1) }
//  )
//}

public func beAnError(domain: Predicate<String>? = nil, code: Predicate<Int>? = nil, localizedDescription: Predicate<String>? = nil) -> Predicate<NSError> {
    return Predicate.define("be an Error", matcher: { actualNSErrorExpression, msg in
        if domain == nil && code == nil && localizedDescription == nil {
            return PredicateResult(status: .matches, message: msg)
        }
        guard let actualNSError = try actualNSErrorExpression.evaluate() else {
            return PredicateResult(status: .fail, message: msg)
        }
        if let domain = domain {
            let result = try domain.satisfies(Expression(expression: {( actualNSError.domain )} , location: actualNSErrorExpression.location))
            if !result.toBoolean(expectation: .toMatch) {
                return PredicateResult(status: .doesNotMatch, message: .expectedActualValueTo("have error domain " + result.message.expectedMessage))
            }
        }
        if let code = code {
            let result = try code.satisfies(Expression(expression: {( actualNSError.code )} , location: actualNSErrorExpression.location))
            if !result.toBoolean(expectation: .toMatch) {
                return PredicateResult(status: .doesNotMatch, message: .expectedActualValueTo("have error code " + result.message.expectedMessage))
            }

        }
        if let localizedDescription = localizedDescription {
            let result = try localizedDescription.satisfies(Expression(expression: {( actualNSError.localizedDescription )} , location: actualNSErrorExpression.location))
            if !result.toBoolean(expectation: .toMatch) {
                return PredicateResult(status: .doesNotMatch, message: .expectedActualValueTo("have error localizedDescription " + result.message.expectedMessage))
            }

        }
        return PredicateResult(status: .matches, message: msg)
    })
}

// MARK: Private

//private func beAnErrorMatcherFunc(domain: MatcherClosure<String>? = nil, code: MatcherClosure<Int>? = nil, localizedDescription: MatcherClosure<String>? = nil) -> NonNilMatcherFunc<NSError> {
//  return NonNilMatcherFunc { actualExpression, failureMessage in
//    
//    guard let error = try actualExpression.evaluate() else {
//        return false
//    }
//    
//    var allEqualityChecksAreTrue = true
//    if let domainMatcherClosure = domain {
//        let domainExpression = Expression(expression: { error.domain }, location: actualExpression.location)
//        if let match = try domainMatcherClosure.closure(domainExpression, failureMessage) {
//            allEqualityChecksAreTrue = allEqualityChecksAreTrue && match
//        }
//    }
//    if let codeMatcherClosure = code {
//        let codeExpression = Expression(expression: { error.code }, location: actualExpression.location)
//        if let match = try codeMatcherClosure.closure(codeExpression, failureMessage) {
//            allEqualityChecksAreTrue = allEqualityChecksAreTrue && match
//        }
//    }
//    if let descriptionMatcherClosure = localizedDescription {
//        let descriptionExpression = Expression(expression: { error.localizedDescription }, location: actualExpression.location)
//        if let match = try descriptionMatcherClosure.closure(descriptionExpression, failureMessage) {
//            allEqualityChecksAreTrue = allEqualityChecksAreTrue && match
//        }
//    }
//    return allEqualityChecksAreTrue
//
//    }
//}
