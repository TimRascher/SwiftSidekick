//
//  Created by Timothy Rascher on 10/19/21.
//

import SwiftUI
#if os(macOS)
import AppKit
#endif
#if os(iOS)
import UIKit
#endif

public extension SFSymbols {
    var name: String { rawValue }
    @available(macOS 11, iOS 13, *)
    var image: Image {
        Image(systemName: name)
    }
    #if os(macOS)
    @available(macOS 11, *)
    var nsImage: NSImage? {
        NSImage(systemSymbolName: name, accessibilityDescription: nil)
    }
    @available(macOS 11, *)
    func nsImage(accessibilityDescription: String) -> NSImage? {
        NSImage(systemSymbolName: name, accessibilityDescription: accessibilityDescription)
    }
    #endif
    #if os(iOS)
    @available(iOS 13, *)
    var uiImage: UIImage? {
        UIImage(systemName: name)
    }
    @available(iOS 13, *)
    func uiImage(compatibleWith traitCollection: UITraitCollection) -> UIImage? {
        UIImage(systemName: name, compatibleWith: traitCollection)
    }
    @available(iOS 13, *)
    func uiImage(withConfiguration configuration: UIImage.Configuration) -> UIImage? {
        UIImage(systemName: name, withConfiguration: configuration)
    }
    #endif
}
@available(macOS 11, iOS 13, *)
public extension Image {
    init(_ sfSymbol: SFSymbols) {
        self = sfSymbol.image
    }
}
