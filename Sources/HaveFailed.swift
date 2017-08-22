import Nimble
import Result

// MARK: Public

/**
  A Nimble matcher that succeeds when the actual value
  is a failed result or an error is thrown of the same type that caused the failure
*/
//public func haveFailed<T, U>() -> MatcherFunc<Result<T, U>> {
//  return MatcherFunc { actualExpression, failureMessage in
//    failureMessage.actualValue = nil    
//    failureMessage.postfixMessage = "have failed"
//    do {
//      if let result = try actualExpression.evaluate(){
//        return result.analysis(
//          ifSuccess: { value in
//            return false
//          },
//          ifFailure: { error in
//            return true
//          }
//        )
//      } else {
//        return false
//      }
//    } catch let error where type(of: error) == U.self {
//      return true
//    } catch {
//      return false
//    }
//  }
//}

public func haveFailed<T, U>() -> Predicate<Result<T, U>> {
    return Predicate.define("have failed", matcher: { (actualResultExpression, msg) -> PredicateResult in
        guard let actualExpression = try actualResultExpression.evaluate() else {
            return PredicateResult(status: .fail, message: msg)
        }
        return actualExpression.analysis(ifSuccess: { _ in
            return PredicateResult(status: .doesNotMatch, message: msg)
        }, ifFailure: { _  in
            return PredicateResult(status: .matches, message: msg)
        })
    })
}

/**
  A Nimble matcher that succeeds when the actual value
  is a failed result, and the given matcher matches its failure value.

  :param: matcher The matcher to run against the failure value.
*/
//public func haveFailed<T, U>(_ matcher: MatcherFunc<U>) -> MatcherFunc<Result<T, U>> {
//  return haveFailedMatcherFunc(MatcherClosure { try matcher.matches($0, failureMessage: $1) })
//}

/**
  A Nimble matcher that succeeds when the actual value
  is a failed result, and the given matcher matches its failure value.

  :param: matcher The matcher to run against the failure value.
*/
//public func haveFailed<T, U>(_ matcher: NonNilMatcherFunc<U>) -> MatcherFunc<Result<T, U>> {
//  return haveFailedMatcherFunc(MatcherClosure { try matcher.matches($0, failureMessage: $1) })
//}

// MARK: Private

//private func haveFailedMatcherFunc<T, U>(_ matcherClosure: MatcherClosure<U>) -> MatcherFunc<Result<T, U>> {
//  return MatcherFunc { actualExpression, failureMessage in
//    failureMessage.postfixMessage = "have succeeded"
//    
//    let errorClosure: (_ error: U) -> Bool = { error in
//        do {
//          let failedExpression = Expression(expression: { error }, location: actualExpression.location)
//          let matched = try matcherClosure.closure(failedExpression, failureMessage)
//          failureMessage.to = "for"
//          failureMessage.postfixMessage = "failure value to \(failureMessage.postfixMessage)"
//          return matched!
//        } catch {
//          failureMessage.actualValue = nil
//          return false
//      }
//    }
//    
//    do {
//      if let result = try actualExpression.evaluate(){
//        return result.analysis(
//          ifSuccess: { value in
//            return false
//          },
//          ifFailure: errorClosure
//        )
//      }
//      return false
//    }
//    catch let error as U {
//      return errorClosure(error)
//    }
//  }
//}

public func haveFailed<T, U>(_ predicate: Predicate<U>) -> Predicate<Result<T,U>> {
    return Predicate.define("have failed", matcher: { (actualResultExpression, msg) -> PredicateResult in
        guard let actualResult = try actualResultExpression.evaluate() else {
            return PredicateResult(status: .fail, message: msg)
        }
        return actualResult.analysis(ifSuccess: { _ in
            return PredicateResult(status: .doesNotMatch, message: msg)
        }, ifFailure: { error in
            do {
                let actualExpression = Expression(expression: {( error )}, location: actualResultExpression.location)
                let result = try predicate.satisfies(actualExpression)
                if !result.toBoolean(expectation: .toMatch) {
                    return PredicateResult(status: result.status, message: .expectedActualValueTo("have failed with value \(result.message.expectedMessage)"))
                }
                return result
            } catch {
                return PredicateResult(status: .fail, message: msg)
            }
        })
    })
}
