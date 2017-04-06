//  Created by dasdom on 03/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
import CoreData

extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag");
    }

    @NSManaged fileprivate(set) var len: Int16
    @NSManaged fileprivate(set) var pos: Int16
    @NSManaged fileprivate(set) var text: String?
    
    @NSManaged fileprivate(set) var content: Content?

}

extension Tag {
    convenience init(dict: [String:Any], context moc: NSManagedObjectContext) {
        
        self.init(context: moc)
        
        len = Int16(dict[PnutKey.len.rawValue] as! Int)
        pos = Int16(dict[PnutKey.pos.rawValue] as! Int)
        text = dict[PnutKey.text.rawValue] as? String
    }
    
    enum PnutKey: String {
        case len
        case pos
        case text
    }
}
