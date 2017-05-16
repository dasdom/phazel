//  Created by dasdom on 01/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

final class Content: NSObject {

    fileprivate(set) var text: String?
    
    var user: User?
    fileprivate(set) var links: [Link]?
    fileprivate(set) var mentions: [Mention]?
    fileprivate(set) var tags: [Tag]?
    var post: Post?
    fileprivate(set) var avatarImage: Image?
    fileprivate(set) var coverImage: Image?

    init(dict: [String:Any]) {

        super.init()
        
        text = dict[PnutKey.text.rawValue] as? String
        
        if let entities = dict[PnutKey.entities.rawValue] as? [String:[Any]] {
            
            if let rawLinks = entities[PnutKey.links.rawValue] as? [[String:Any]] {
                links = rawLinks.map { Link(dict: $0) }
            }
            
            if let rawMentions = entities[PnutKey.mentions.rawValue] as? [[String:Any]] {
                mentions = rawMentions.map { Mention(dict: $0) }
            }
            
            if let rawTags = entities[PnutKey.tags.rawValue] as? [[String:Any]] {
                tags = rawTags.map { Tag(dict: $0) }
            }
        }
        
        if let avatar = dict[PnutKey.avatar_image.rawValue] as? [String:Any] {
            let image = Image(dict: avatar)
            image.content = self
            avatarImage = image
        }
        
        if let cover = dict[PnutKey.cover_image.rawValue] as? [String:Any] {
            let image = Image(dict: cover)
            image.content = self
            coverImage = image
        }
    }
    
    enum PnutKey: String {
        case text
        case entities
        case links
        case mentions
        case tags
        case avatar_image
        case cover_image
    }
    
}

extension Content: NSCoding {
    convenience init?(coder aDecoder: NSCoder) {

        var dict: [String:Any] = [:]
        
        dict[PnutKey.text.rawValue] = aDecoder.decodeObject(of: NSString.self, forKey: PnutKey.text.rawValue)
        
        self.init(dict: dict)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: PnutKey.text.rawValue)
    }
}
