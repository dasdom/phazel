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
        }
    }
    
    enum PnutKey: String {
        case text
        case entities
        case links
        case mentions
    }
}
