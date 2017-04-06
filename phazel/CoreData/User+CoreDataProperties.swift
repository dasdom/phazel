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
    @NSManaged fileprivate(set) var followsYou: Bool
    @NSManaged fileprivate(set) var youBlocked: Bool
    @NSManaged fileprivate(set) var youCanFollow: Bool
    @NSManaged fileprivate(set) var youMuted: Bool
    @NSManaged fileprivate(set) var numberOfBookmarks: Int32
    @NSManaged fileprivate(set) var numberOfClients: Int32
    @NSManaged fileprivate(set) var numberOfFollowers: Int32
    @NSManaged fileprivate(set) var numberOfFollowing: Int32
    @NSManaged fileprivate(set) var numberOfPosts: Int32
    @NSManaged fileprivate(set) var numberOfUsers: Int32
    
    @NSManaged fileprivate(set) var content: Content?
    @NSManaged fileprivate(set) var post: Post?
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
        followsYou = dict[PnutKey.follows_you.rawValue] as? Bool ?? false
        youBlocked = dict[PnutKey.you_blocked.rawValue] as? Bool ?? false
        youCanFollow = dict[PnutKey.you_can_follow.rawValue] as? Bool ?? false
        youMuted = dict[PnutKey.you_muted.rawValue] as? Bool ?? false
        
        if let counts = dict[PnutKey.counts.rawValue] as? [String:Int] {
            numberOfBookmarks = Int32(counts[PnutKey.bookmarks.rawValue] ?? 0)
            numberOfClients = Int32(counts[PnutKey.clients.rawValue] ?? 0)
            numberOfFollowers = Int32(counts[PnutKey.followers.rawValue] ?? 0)
            numberOfFollowing = Int32(counts[PnutKey.following.rawValue] ?? 0)
            numberOfPosts = Int32(counts[PnutKey.posts.rawValue] ?? 0)
            numberOfUsers = Int32(counts[PnutKey.users.rawValue] ?? 0)
        }
        
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
        case follows_you
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
