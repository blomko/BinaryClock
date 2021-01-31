//
//  Util.swift
//  BinaryClock
//
//  Created by Anders Blomqvist on 2020-12-07.
//

import Foundation
import SwiftUI

class Util {
    class func drawText() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let font = NSFont(name: "Helvetica", size: 36)
        let attrs = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle,
                     NSAttributedString.Key.foregroundColor: NSColor.white]
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        var string = dateFormatter.string(from: date)
        let hms = Calendar
            .current
            .dateComponents([.hour, .minute, .second], from: date)
        let h0 = getByte(BinaryClockView.getComponent(components: hms, 0), 0)
        let h1 = getByte(getComponent(components: hms, 1), 1)
        let m0 = getByte(getComponent(components: hms, 2), 2)
        let m1 = getByte(getComponent(components: hms, 3), 3)
        let s0 = getByte(getComponent(components: hms, 4), 4)
        let s1 = getByte(getComponent(components: hms, 5), 5)
        
        string += " \(h0) \(h1) \(m0) \(m1) \(s0) \(s1)"
        string.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, attributes: attrs as [NSAttributedString.Key : Any], context: nil)
    }
}

