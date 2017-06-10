//  Created by dasdom on 06/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

final class Image: NSObject {

    fileprivate(set) var link: String?
    fileprivate(set) var width: Int
    fileprivate(set) var height: Int
    var image: UIImage?
    
    var content: Content?

    init(dict: [String:Any]) {
        
        link = dict[PnutKey.link.rawValue] as? String
        width = dict[PnutKey.width.rawValue] as? Int ?? 0
        height = dict[PnutKey.height.rawValue] as? Int ?? 0

        super.init()
    }
    
    enum PnutKey: String {
        case link
        case width
        case height
    }
}

extension Image: NSCoding {
    convenience init?(coder aDecoder: NSCoder) {
        
        var dict: [String:Any] = [:]

        let intKeys: [PnutKey] = [.width, .height]
        for key in intKeys {
            let keyString = key.rawValue
            dict[keyString] = aDecoder.decodeObject(of: NSNumber.self, forKey: keyString)
        }
        
        let keyString = PnutKey.link.rawValue
        dict[keyString] = aDecoder.decodeObject(of: NSString.self, forKey: keyString)
        
        self.init(dict: dict)
    }
    
    func encode(with aCoder: NSCoder) {
        
        let ints: [PnutKey:Int] = [.width: width, .height: height]
        for (key, value) in ints {
            let intNumber = NSNumber(integerLiteral: value)
            aCoder.encode(intNumber, forKey: key.rawValue)
        }
        
        aCoder.encode(link, forKey: PnutKey.link.rawValue)
    }
}
