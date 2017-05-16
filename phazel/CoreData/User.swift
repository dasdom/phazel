//  Created by dasdom on 01/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import Foundation

final class User: NSObject {

    fileprivate(set) var id: String?
    fileprivate(set) var creationDate: Date?
    fileprivate(set) var locale: String?
    fileprivate(set) var timezone: String?
    fileprivate(set) var type: String?
    fileprivate(set) var username: String?
    fileprivate(set) var name: String?
    fileprivate(set) var followsYou: Bool
    fileprivate(set) var youFollow: Bool
    fileprivate(set) var youBlocked: Bool
    fileprivate(set) var youCanFollow: Bool
    fileprivate(set) var youMuted: Bool
    fileprivate(set) var numberOfBookmarks: Int
    fileprivate(set) var numberOfClients: Int
    fileprivate(set) var numberOfFollowers: Int
    fileprivate(set) var numberOfFollowing: Int
    fileprivate(set) var numberOfPosts: Int
    fileprivate(set) var numberOfUsers: Int
    
    fileprivate(set) var content: Content?
    var post: Post?

    init(dict: [String:Any]) {
        
        id = dict[PnutKey.id.rawValue] as? String
        locale = dict[PnutKey.locale.rawValue] as? String
        timezone = dict[PnutKey.timezone.rawValue] as? String
        type = dict[PnutKey.type.rawValue] as? String
        username = dict[PnutKey.username.rawValue] as? String
        name = dict[PnutKey.name.rawValue] as? String
        followsYou = dict[PnutKey.follows_you.rawValue] as? Bool ?? false
        youFollow = dict[PnutKey.you_follow.rawValue] as? Bool ?? false
        youBlocked = dict[PnutKey.you_blocked.rawValue] as? Bool ?? false
        youCanFollow = dict[PnutKey.you_can_follow.rawValue] as? Bool ?? false
        youMuted = dict[PnutKey.you_muted.rawValue] as? Bool ?? false
        
        if let counts = dict[PnutKey.counts.rawValue] as? [String:Int] {
            numberOfBookmarks = counts[PnutKey.bookmarks.rawValue] ?? 0
            numberOfClients = counts[PnutKey.clients.rawValue] ?? 0
            numberOfFollowers = counts[PnutKey.followers.rawValue] ?? 0
            numberOfFollowing = counts[PnutKey.following.rawValue] ?? 0
            numberOfPosts = counts[PnutKey.posts.rawValue] ?? 0
            numberOfUsers = counts[PnutKey.users.rawValue] ?? 0
        } else {
            numberOfBookmarks = 0
            numberOfClients = 0
            numberOfFollowers = 0
            numberOfFollowing = 0
            numberOfPosts = 0
            numberOfUsers = 0
        }
        
        if let dateString = dict[PnutKey.created_at.rawValue] as? String {
            let dateFormatter = ISO8601DateFormatter()
            creationDate = dateFormatter.date(from: dateString)
        }
        
        if let contentDict = dict[PnutKey.content.rawValue] as? [String:Any] {
            content = Content(dict: contentDict)
        }

        super.init()
        
        content?.user = self
    }
    
    fileprivate enum PnutKey: String {
        case id
        case created_at
        case locale
        case timezone
        case type
        case username
        case name
        case content
        case follows_you
        case you_follow
        case you_blocked
        case you_can_follow
        case you_muted
        case counts
        case bookmarks
        case clients
        case followers
        case following
        case posts
        case users
    }
}

extension User: NSCoding {
    convenience init?(coder aDecoder: NSCoder) {
        
        var dict: [String:Any] = [:]
        var keyString = PnutKey.id.rawValue
        dict[keyString] = aDecoder.decodeObject(of: NSString.self, forKey: keyString)
       
        keyString = PnutKey.created_at.rawValue
        if let createdAt = aDecoder.decodeObject(of: NSString.self, forKey: keyString) {
            dict[keyString] = createdAt
        }
        
        var keys: [PnutKey] = [.locale, .timezone, .type, .username, .name]
        for key in keys {
            keyString = key.rawValue
            dict[keyString] = aDecoder.decodeObject(of: NSString.self, forKey: keyString)
        }
        
        keys = [.follows_you, .you_follow, .you_blocked, .you_can_follow, .you_muted, .bookmarks]
        for key in keys {
            keyString = key.rawValue
            dict[keyString] = aDecoder.decodeObject(of: NSNumber.self, forKey: keyString)
        }
        
        var countDict: [String:NSNumber] = [:]
        keys = [.bookmarks, .clients, .followers, .following, .posts, .users]
        for key in keys {
            keyString = key.rawValue
            countDict[keyString] = aDecoder.decodeObject(of: NSNumber.self, forKey: keyString)
        }
        dict[PnutKey.counts.rawValue] = countDict
        
        self.init(dict: dict)
        
        content = aDecoder.decodeObject(of: Content.self, forKey: PnutKey.content.rawValue)
        content?.user = self
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PnutKey.id.rawValue)
        if let creationDate = creationDate {
            let dateFormatter = ISO8601DateFormatter()
            aCoder.encode(dateFormatter.string(from: creationDate), forKey: PnutKey.created_at.rawValue)
        }
        
        let keys: [PnutKey:String?] = [.locale: locale, .timezone: timezone, .type: type, .username: username, .name: name]
        for (key, value) in keys {
            aCoder.encode(value, forKey: key.rawValue)
        }
        
        let bools: [PnutKey:Bool] = [.follows_you: followsYou,
                                     .you_follow: youFollow,
                                     .you_blocked: youBlocked,
                                     .you_can_follow: youCanFollow,
                                     .you_muted: youMuted]
        for (key, value) in bools {
            let boolNumber = NSNumber(booleanLiteral: value)
            aCoder.encode(boolNumber, forKey: key.rawValue)
        }
        
        let ints: [PnutKey:Int] = [.bookmarks: numberOfBookmarks,
                                   .clients: numberOfClients,
                                   .followers: numberOfFollowers,
                                   .following: numberOfFollowing,
                                   .posts: numberOfPosts,
                                   .users: numberOfUsers]
        for (key, value) in ints {
            let intNumber = NSNumber(integerLiteral: value)
            aCoder.encode(intNumber, forKey: key.rawValue)
        }
        
        aCoder.encode(content, forKey: PnutKey.content.rawValue)
    }
}
