//  Created by dasdom on 06/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
import CoreData

extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image");
    }

    @NSManaged fileprivate(set) var link: String?
    @NSManaged fileprivate(set) var width: Int16
    @NSManaged fileprivate(set) var height: Int16
    
    @NSManaged fileprivate(set) var content: Content?

}

extension Image {
    convenience init(dict: [String:Any], context moc: NSManagedObjectContext) {
        
        self.init(context: moc)
        
        link = dict[PnutKey.link.rawValue] as? String
        width = Int16(dict[PnutKey.width.rawValue] as? Int ?? 0)
        height = Int16(dict[PnutKey.height.rawValue] as? Int ?? 0)
    }
    
    enum PnutKey: String {
        case link
        case width
        case height
    }
}
