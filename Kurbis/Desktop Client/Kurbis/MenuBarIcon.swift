import SwiftUI
import AppKit

final class MenuBarIcon {
    static func createIcon(isConnected:Bool) -> NSImage {
        let size = NSSize(width: 18, height: 18)
        let image = NSImage(size: size)
        image.lockFocus()
        
        // Draw the green circle
        if(isConnected) {
            NSColor(red:0.0, green: 0.9, blue:0.0, alpha:0.6).set();
        }
        else {
            NSColor(red:0.9, green: 0.9, blue:0.9, alpha:0.3).set();
        }
        
        let circleRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        let circlePath = NSBezierPath(ovalIn: circleRect)
        circlePath.fill()
        
        // Draw the "K"
        let string = "K" as NSString
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12),
            .foregroundColor: NSColor.white
        ]
        
        let stringSize = string.size(withAttributes: attributes)
        let stringRect = CGRect(x: (size.width - stringSize.width) / 2.0,
                                y: (size.height - stringSize.height) / 2.0,
                                width: stringSize.width,
                                height: stringSize.height)
        string.draw(in: stringRect, withAttributes: attributes)
        
        image.unlockFocus()
        return image
    }
}
