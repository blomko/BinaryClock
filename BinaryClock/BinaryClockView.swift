//
//  BinaryClockView.swift
//  BinaryClock
//
//  Created by Anders Blomqvist on 2020-10-12.
//

import ScreenSaver
import SwiftUI

class BinaryClockView: ScreenSaverView {
    
    private let HEIGHT = 4
    private let WIDTH = 6
    var RADIUS: CGFloat = 0
    var DIAMETER: CGFloat = 0
    var DISTANCE: CGFloat = 0
    var screenSize: NSSize = .zero
    var RATIO: CGFloat = 0.5
    
    // MARK: - Initialization
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        screenSize = bounds.size
        RADIUS = screenSize.width / 20 * RATIO
        DIAMETER = RADIUS * 2
        DISTANCE = RADIUS * 3
    }

    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func draw(_ rect: NSRect) {
        drawBackground(.black)
        drawClock()
        drawText()
    }

    override func animateOneFrame() {
        super.animateOneFrame()
        setNeedsDisplay(bounds)
    }
    
    private func drawBackground(_ color: NSColor) {
        let background = NSBezierPath(rect: bounds)
        color.setFill()
        background.fill()
    }
    
    private func drawClock() {
        let offset = getOffsetPoint(size: screenSize)
        var tempOffset = offset
        let hms = Calendar
            .current
            .dateComponents([.hour, .minute, .second], from: Date())
        
        for column in 0...WIDTH - 1 {
            let component = getComponent(components: hms, column)
            let byte = getByte(component, column)
            
            for bit in 0...HEIGHT - 1 {
                let enabled = isBitInByteEnabled(bit, byte)
                drawBit(offset: tempOffset, enabled: enabled)
                tempOffset.y = tempOffset.y + DISTANCE
            }
            tempOffset.y = offset.y
            tempOffset.x = tempOffset.x + DISTANCE
        }
    }
    
    private func isBitInByteEnabled(_ bit: Int, _ byte: UInt8) -> Bool {
        return (byte & (1 << bit)) != 0
    }
    
    func getByte(_ component: Int, _ column: Int) -> UInt8 {
        if(column % 2 == 0) {
            return (UInt8) (component / 10)
        } else {
            return (UInt8) (component % 10)
        }
    }
    
    private func getComponent(components: DateComponents, _ column: Int) -> Int {
        if(column < 2) {
            return components.hour!
        } else if(column < 4) {
            return components.minute!
        }
        return components.second!
    }
    
    private func drawBit(offset: NSPoint, enabled: Bool) {
        let rect = NSRect(x: offset.x,
                          y: offset.y,
                          width: DIAMETER,
                          height: DIAMETER)
        let point = NSBezierPath(roundedRect: rect,
                                xRadius: RADIUS,
                                yRadius: RADIUS)
        if(enabled) {
            NSColor.red.setFill()
        } else {
            NSColor.darkGray.setFill()
        }
        
        point.fill()
    }
    
    private func getOffsetPoint(size: NSSize) -> NSPoint {
        return NSMakePoint(RADIUS, RADIUS)
    }
    
    func drawText() {
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
        let h0 = getByte(getComponent(components: hms, 0), 0)
        let h1 = getByte(getComponent(components: hms, 1), 1)
        let m0 = getByte(getComponent(components: hms, 2), 2)
        let m1 = getByte(getComponent(components: hms, 3), 3)
        let s0 = getByte(getComponent(components: hms, 4), 4)
        let s1 = getByte(getComponent(components: hms, 5), 5)
        
        string += " \(h0) \(h1) \(m0) \(m1) \(s0) \(s1)"
        string.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, attributes: attrs as [NSAttributedString.Key : Any], context: nil)
    }
}
