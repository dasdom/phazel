//  Created by dasdom on 26/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

protocol KeychainManagerProtocol {
    func set(token: String, for username: String)
    func token(for username: String) -> String?
}
