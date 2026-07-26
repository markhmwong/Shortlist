import WidgetKit
import SwiftUI

@main
struct ShortlistWidgetBundle: WidgetBundle {
    var body: some Widget {
        ShortlistSmallWidget()
        ShortlistMediumWidget()
        ShortlistLockScreenWidget()
    }
}
