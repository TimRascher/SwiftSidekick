//
//  Created by Timothy Rascher on 10/19/21.
//

import SwiftUI

public extension SFSymbols {
    var name: String { rawValue }
    @available(macOS 11.0, *)
    var image: Image {
        Image(systemName: name)
    }
    @available(macOS 11.0, *)
    var nsImage: NSImage? {
        nsImage(accessibilityDescription: nil)
    }
    @available(macOS 11.0, *)
    func nsImage(accessibilityDescription: String?) -> NSImage? {
        NSImage(systemSymbolName: name, accessibilityDescription: accessibilityDescription)
    }
}
@available(macOS 11.0, *)
public extension Image {
    init(sfSymbol: SFSymbols) {
        self = sfSymbol.image
    }
}
