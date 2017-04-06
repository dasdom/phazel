//  Created by dasdom on 01/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
import CoreData

extension Content {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        return NSFetchRequest<Content>(entityName: "Content");
    }

    @NSManaged fileprivate(set) var text: String?
    
    @NSManaged fileprivate(set) var user: User?
    @NSManaged fileprivate(set) var links: Set<Link>?
    @NSManaged fileprivate(set) var mentions: Set<Mention>?
    @NSManaged fileprivate(set) var tags: Set<Tag>?
    @NSManaged fileprivate(set) var post: Post?
    @NSManaged fileprivate(set) var avatarImage: Image?
    @NSManaged fileprivate(set) var coverImage: Image?
}

extension Content {
    convenience init(dict: [String:Any], context moc: NSManagedObjectContext) {

        self.init(context: moc)

        text = dict[PnutKey.text.rawValue] as? String
        
        if let entities = dict[PnutKey.entities.rawValue] as? [String:[Any]] {
            
            if let rawLinks = entities[PnutKey.links.rawValue] as? [[String:Any]] {
                links = Set(rawLinks.map { Link(dict: $0, context: moc) })
            }
            
            if let rawMentions = entities[PnutKey.mentions.rawValue] as? [[String:Any]] {
                mentions = Set(rawMentions.map { Mention(dict: $0, context: moc) })
            }
            
            if let rawTags = entities[PnutKey.tags.rawValue] as? [[String:Any]] {
                tags = Set(rawTags.map { Tag(dict: $0, context: moc) })
            }
        }
        
        if let avatar = dict[PnutKey.avatar_image.rawValue] as? [String:Any] {
            avatarImage = Image(dict: avatar, context: moc)
        }
        
        if let cover = dict[PnutKey.cover_image.rawValue] as? [String:Any] {
            coverImage = Image(dict: cover, context: moc)
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
