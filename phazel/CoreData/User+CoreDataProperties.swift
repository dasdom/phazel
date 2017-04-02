//  Created by dasdom on 01/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged fileprivate(set) var id: String?
    @NSManaged fileprivate(set) var creationDate: Date?
    @NSManaged fileprivate(set) var locale: String?
    @NSManaged fileprivate(set) var timezone: String?
    @NSManaged fileprivate(set) var type: String?
    @NSManaged fileprivate(set) var username: String?
    @NSManaged fileprivate(set) var name: String?
    
    @NSManaged fileprivate(set) var content: Content?
}

extension User {
    convenience init(dict: [String:Any], context moc: NSManagedObjectContext) {
        
        self.init(context: moc)
        
        id = dict[PnutKey.id.rawValue] as? String
        locale = dict[PnutKey.locale.rawValue] as? String
        timezone = dict[PnutKey.timezone.rawValue] as? String
        type = dict[PnutKey.type.rawValue] as? String
        username = dict[PnutKey.username.rawValue] as? String
        name = dict[PnutKey.name.rawValue] as? String
        
        if let dateString = dict[PnutKey.created_at.rawValue] as? String {
            let dateFormatter = ISO8601DateFormatter()
            creationDate = dateFormatter.date(from: dateString)
        }
        
        if let contentDict = dict[PnutKey.content.rawValue] as? [String:Any] {
            content = Content(dict: contentDict, context: moc)
        }
    }
    
    enum PnutKey: String {
        case id
        case created_at
        case locale
        case timezone
        case type
        case username
        case name
        case content
    }
}
