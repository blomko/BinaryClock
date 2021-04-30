//
//  Util.swift
//  BinaryClock
//
//  Created by Anders Blomqvist on 2020-12-07.
//

import Foundation
import SwiftUI

class Util {
    static func printText(_ string: String) {
        let font = NSFont(name: "Helvetica", size: 36)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attrs = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle,
                     NSAttributedString.Key.foregroundColor: NSColor.white]
        
        string.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, attributes: attrs as [NSAttributedString.Key : Any], context: nil)
    }
}

