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
public func beAnError(domain: NonNilMatcherFunc<String>? = nil, code: NonNilMatcherFunc<Int>? = nil, localizedDescription: NonNilMatcherFunc<String>? = nil) -> NonNilMatcherFunc<NSError> {
  return beAnErrorMatcherFunc(
    domain: MatcherClosure { try domain?.matches($0, failureMessage: $1) },
    code: MatcherClosure { try code?.matches($0, failureMessage: $1) },
    localizedDescription: MatcherClosure { try localizedDescription?.matches($0, failureMessage: $1) }
  )
}

public func beAnError(domain: Predicate<String>? = nil, code: Predicate<Int>? = nil, localizedDescription: Predicate<String>? = nil) -> Predicate<NSError> {
    return Predicate.define(matcher: { actualNSErrorExpression in
        var message = ExpectationMessage.expectedTo("be an error")
        if domain == nil && code == nil && localizedDescription == nil {
            return PredicateResult(status: .matches, message: message.appended(message: ", got <nil>"))
        }
        guard let actualNSError = try actualNSErrorExpression.evaluate() else {
            return PredicateResult(status: .fail, message: .expectedActualValueTo("be an error"))
        }
        var allEqualityChecksAreTrue = true
        if let domain = domain {
            let result = try domain.satisfies(Expression(expression: {( actualNSError.domain )} , location: actualNSErrorExpression.location))
            allEqualityChecksAreTrue = allEqualityChecksAreTrue && result.toBoolean(expectation: .toMatch)
            if !result.toBoolean(expectation: .toMatch) {
                message = message.appended(message: " in domain \(result.message.expectedMessage), got <\(actualNSError.domain)>")
            }
        }
        if let code = code {
            let result = try code.satisfies(Expression(expression: {( actualNSError.code )} , location: actualNSErrorExpression.location))
            allEqualityChecksAreTrue = allEqualityChecksAreTrue && result.toBoolean(expectation: .toMatch)
            if !result.toBoolean(expectation: .toMatch) {
                message = message.appended(message: " in code \(result.message.expectedMessage), got <\(actualNSError.code)>")
            }

        }
        if let localizedDescription = localizedDescription {
            let result = try localizedDescription.satisfies(Expression(expression: {( actualNSError.localizedDescription )} , location: actualNSErrorExpression.location))
            allEqualityChecksAreTrue = allEqualityChecksAreTrue && result.toBoolean(expectation: .toMatch)
            if !result.toBoolean(expectation: .toMatch) {
                message = message.appended(message: " localizedDescription \(result.message.expectedMessage), got <\(actualNSError.localizedDescription)>")
            }

        }
        return allEqualityChecksAreTrue ?
        PredicateResult(status: .matches, message: message.appended(message: ", got <nil>").appendedBeNilHint()) :
        PredicateResult(status: .doesNotMatch, message: message)
    })
}

// MARK: Private

private func beAnErrorMatcherFunc(domain: MatcherClosure<String>? = nil, code: MatcherClosure<Int>? = nil, localizedDescription: MatcherClosure<String>? = nil) -> NonNilMatcherFunc<NSError> {
  return NonNilMatcherFunc { actualExpression, failureMessage in
    
    guard let error = try actualExpression.evaluate() else {
        return false
    }
    
    var allEqualityChecksAreTrue = true
    if let domainMatcherClosure = domain {
        let domainExpression = Expression(expression: { error.domain }, location: actualExpression.location)
        if let match = try domainMatcherClosure.closure(domainExpression, failureMessage) {
            allEqualityChecksAreTrue = allEqualityChecksAreTrue && match
        }
    }
    if let codeMatcherClosure = code {
        let codeExpression = Expression(expression: { error.code }, location: actualExpression.location)
        if let match = try codeMatcherClosure.closure(codeExpression, failureMessage) {
            allEqualityChecksAreTrue = allEqualityChecksAreTrue && match
        }
    }
    if let descriptionMatcherClosure = localizedDescription {
        let descriptionExpression = Expression(expression: { error.localizedDescription }, location: actualExpression.location)
        if let match = try descriptionMatcherClosure.closure(descriptionExpression, failureMessage) {
            allEqualityChecksAreTrue = allEqualityChecksAreTrue && match
        }
    }
    return allEqualityChecksAreTrue

    }
}
