//  Created by dasdom on 03/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

final class Tag: NSObject {

    fileprivate(set) var len: Int
    fileprivate(set) var pos: Int
    fileprivate(set) var text: String?
    
    fileprivate(set) var content: Content?

    init(dict: [String:Any]) {
        
        len = dict[PnutKey.len.rawValue] as? Int ?? 0
        pos = dict[PnutKey.pos.rawValue] as? Int ?? 0
        text = dict[PnutKey.text.rawValue] as? String

        super.init()
        
    }
    
    enum PnutKey: String {
        case len
        case pos
        case text
    }
}

extension Tag: NSCoding {
    convenience init?(coder aDecoder: NSCoder) {

        var dict: [String:Any] = [:]

        let keys: [PnutKey] = [.len, .pos]
        for key in keys {
            let keyString = key.rawValue
            dict[keyString] = aDecoder.decodeObject(of: NSNumber.self, forKey: keyString)
        }
        
        let keyString = PnutKey.text.rawValue
        dict[keyString] = aDecoder.decodeObject(of: NSString.self, forKey: keyString)
        
        self.init(dict: dict)
    }
    
    func encode(with aCoder: NSCoder) {
        
        let ints: [PnutKey:Int] = [.len: len, .pos: pos]
        for (key, value) in ints {
            let intNumber = NSNumber(integerLiteral: value)
            aCoder.encode(intNumber, forKey: key.rawValue)
        }
        
        aCoder.encode(text, forKey: PnutKey.text.rawValue)
    }
}
