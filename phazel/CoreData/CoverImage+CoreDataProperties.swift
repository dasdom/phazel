//  Created by dasdom on 14/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation
import CoreData

extension CoverImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoverImage> {
        return NSFetchRequest<CoverImage>(entityName: "CoverImage")
    }


}
