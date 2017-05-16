//  Created by dasdom on 01/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation

final class Link: NSObject {

    fileprivate(set) var len: Int
    fileprivate(set) var pos: Int
    fileprivate(set) var link: String?
    fileprivate(set) var text: String?
    
    fileprivate(set) var content: Content?

    init(dict: [String:Any]) {
        
        len = dict[PnutKey.len.rawValue] as? Int ?? 0
        pos = dict[PnutKey.pos.rawValue] as? Int ?? 0
        link = dict[PnutKey.link.rawValue] as? String
        text = dict[PnutKey.text.rawValue] as? String

        super.init()
    }
    
    enum PnutKey: String {
        case len
        case pos
        case link
        case text
    }
}

extension Link: NSCoding {
    convenience init?(coder aDecoder: NSCoder) {
        
        var dict: [String:Any] = [:]
        
        var keys: [PnutKey] = [.len, .pos]
        for key in keys {
            let keyString = key.rawValue
            dict[keyString] = aDecoder.decodeObject(of: NSNumber.self, forKey: keyString)
        }
        
        keys = [.link, .text]
        for key in keys {
            let keyString = key.rawValue
            dict[keyString] = aDecoder.decodeObject(of: NSString.self, forKey: keyString)
        }
        
        self.init(dict: dict)
    }
    
    func encode(with aCoder: NSCoder) {
        
        let ints: [PnutKey:Int] = [.len: len, .pos: pos]
        for (key, value) in ints {
            let intNumber = NSNumber(integerLiteral: value)
            aCoder.encode(intNumber, forKey: key.rawValue)
        }
        
        let strings: [PnutKey:String?] = [.link: link, .text: text]
        for (key, value) in strings {
            aCoder.encode(value, forKey: key.rawValue)
        }
    }
}
