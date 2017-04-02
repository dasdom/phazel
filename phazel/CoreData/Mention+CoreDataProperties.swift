//  Created by dasdom on 02/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

extension Mention {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mention> {
        return NSFetchRequest<Mention>(entityName: "Mention");
    }

    @NSManaged fileprivate(set) var len: Int16
    @NSManaged fileprivate(set) var pos: Int16
    @NSManaged fileprivate(set) var id: String?
    @NSManaged fileprivate(set) var text: String?
    
    @NSManaged fileprivate(set) var content: Content?

}

extension Mention {
    convenience init(dict: [String:Any], context moc: NSManagedObjectContext) {
        
        self.init(context: moc)
        
        len = Int16(dict[PnutKey.len.rawValue] as! Int)
        pos = Int16(dict[PnutKey.pos.rawValue] as! Int)
        id = dict[PnutKey.id.rawValue] as? String
        text = dict[PnutKey.text.rawValue] as? String
    }
    
    enum PnutKey: String {
        case len
        case pos
        case id
        case text
    }
}
