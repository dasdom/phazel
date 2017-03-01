//  Created by dasdom on 06/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

struct Post: DictionaryCreatable {
    
    let text: String
    let id: String
    let source: Source
    let user: User
    
    init?(with dict: [String : Any]) {
        
        if let content = dict["content"] as? [String:Any], let unwrappedText = content["text"] as? String {
            text = unwrappedText
        } else {
            text = ""
        }
    
        if let unwrappedId = dict["id"] as? String {
            id = unwrappedId
        } else {
            id = ""
        }
        
        if let sourceDict = dict["source"] as? [String:String], let unwrappedSource = Source(with: sourceDict) {
            source = unwrappedSource
        } else {
            source = Source(with: [:])!
        }
        
        if let userDict = dict["user"] as? [String:Any], let unwrappedUser = User(with: userDict) {
            user = unwrappedUser
        } else {
            user = User(with: [:])!
        }
    }
}
