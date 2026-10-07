import SwiftUI

/// Applies the state changes in `body` without animating them.
///
/// To skip a `fullScreenCover` animation, change a `@State` property here. On iOS 27,
/// changing a `@Published` property still animates the cover.
func withoutAnimation(_ body: () -> Void) {
    var transaction = Transaction()
    transaction.disablesAnimations = true
    withTransaction(transaction, body)
}
