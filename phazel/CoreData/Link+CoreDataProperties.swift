//  Created by dasdom on 01/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

extension Link {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Link> {
        return NSFetchRequest<Link>(entityName: "Link");
    }

    @NSManaged fileprivate(set) var len: Int16
    @NSManaged fileprivate(set) var pos: Int16
    @NSManaged fileprivate(set) var link: String?
    @NSManaged fileprivate(set) var text: String?
    
    @NSManaged fileprivate(set) var content: Content?

}

extension Link {
    convenience init(dict: [String:Any], context moc: NSManagedObjectContext) {
                
        self.init(context: moc)
        
        len = Int16(dict[PnutKey.len.rawValue] as! Int)
        pos = Int16(dict[PnutKey.pos.rawValue] as! Int)
        link = dict[PnutKey.link.rawValue] as? String
        text = dict[PnutKey.text.rawValue] as? String
    }
    
    enum PnutKey: String {
        case len
        case pos
        case link
        case text
    }
}
