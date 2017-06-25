//  Created by dasdom on 19/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

public enum AppColors {
    
    public static let background = colorFrom(hex: "ffffff")
//    public static let background = colorFrom(hex: "306794")
//    public static let background = colorFrom(hex: "806340")
//    public static let background = colorFrom(hex: "807350")
    
//    public static let tint = colorFrom(hex: "50a0ff")
//    public static let tint = colorFrom(hex: "e59f40")
//    public static let tint = colorFrom(hex: "80d0ff")
    public static let tint = UIColor.brown
    
    public static let text = colorFrom(hex: "000022")
    
    public static let mention = UIColor.brown
    public static let link = UIColor.brown
    public static let tag = UIColor.brown
    
    public static let buttonBackground = colorFrom(hex: "406880")
    
//    public static let bar = colorFrom(hex: "806340")
    public static let bar = background
    
    public static let barText = text
    
    public static let textFieldBackground = background
    
    public static let clear = UIColor.clear
    
    public static let lightGray = UIColor.lightGray
    
    public static let gray = UIColor.gray
    
    public static let red = UIColor.red
    
    public static let white = UIColor.white
    
    public static let youFollow = UIColor.red
    
    public static let followsYou = UIColor.green
    
    private static func colorFrom(hex: String) -> UIColor {
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
