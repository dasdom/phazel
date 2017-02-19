//  Created by dasdom on 19/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

extension UIColor {
    static var background: UIColor {
//        return colorFrom(hex: "306794")
        return colorFrom(hex: "806340")
    }
    
    static var buttonBackground: UIColor {
        return colorFrom(hex: "406880")
    }
    
    static var tint: UIColor {
//        return colorFrom(hex: "e59f40")
        return colorFrom(hex: "80d0ff")
    }
    
    static func colorFrom(hex: String) -> UIColor {
        let scanner = Scanner(string: hex)
        scanner.charactersToBeSkipped = CharacterSet.alphanumerics.inverted
        
        var value: UInt32 = 0
        scanner.scanHexInt32(&value)
        
        let r = Float((value & 0xff0000) >> 16) / Float(255)
        let g = Float((value & 0xff00) >> 8) / Float(255)
        let b = Float(value & 0xff) / Float(255)
        
//        print(r, g, b)
        
        return UIColor(colorLiteralRed: r, green: g, blue: b, alpha: 1.0)
    }
}
