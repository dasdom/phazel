//  Created by dasdom on 05/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post");
    }
    
    @nonobjc public class func sortedFetchRequest(batchSize: Int? = 20) -> NSFetchRequest<Post> {
        let request = NSFetchRequest<Post>(entityName: "Post");
        request.fetchBatchSize = batchSize ?? 0
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return request
    }

    @NSManaged fileprivate(set) var id: String?
    @NSManaged fileprivate(set) var creationDate: Date?
    @NSManaged fileprivate(set) var replyTo: String?
    @NSManaged fileprivate(set) var threadId: String?
    @NSManaged fileprivate(set) var youBookmarked: Bool
    @NSManaged fileprivate(set) var youReposted: Bool
    @NSManaged fileprivate(set) var numberOfBookmarks: Int32
    @NSManaged fileprivate(set) var numberOfReplies: Int32
    @NSManaged fileprivate(set) var numberOfReposts: Int32
    @NSManaged fileprivate(set) var numberOfThreads: Int32
    @NSManaged fileprivate(set) var sourceLink: String?
    @NSManaged fileprivate(set) var sourceName: String?

    @NSManaged fileprivate(set) var content: Content?
    @NSManaged fileprivate(set) var user: User?
}

extension Post {
    convenience init(dict: [String:Any], context moc: NSManagedObjectContext) {
        
        self.init(context: moc)
        
        id = dict[PnutKey.id.rawValue] as? String
        replyTo = dict[PnutKey.reply_to.rawValue] as? String
        threadId = dict[PnutKey.thread_id.rawValue] as? String
        youBookmarked = dict[PnutKey.you_bookmarked.rawValue] as? Bool ?? false
        youReposted = dict[PnutKey.you_reposted.rawValue] as? Bool ?? false
        
        if let counts = dict[PnutKey.counts.rawValue] as? [String:Int] {
            numberOfBookmarks = Int32(counts[PnutKey.bookmarks.rawValue] ?? 0)
            numberOfReplies = Int32(counts[PnutKey.replies.rawValue] ?? 0)
            numberOfReposts = Int32(counts[PnutKey.reposts.rawValue] ?? 0)
            numberOfThreads = Int32(counts[PnutKey.threads.rawValue] ?? 0)
        }
        
        if let source = dict[PnutKey.source.rawValue] as? [String:String] {
            sourceLink = source[PnutKey.link.rawValue]
            sourceName = source[PnutKey.name.rawValue]
        }
        
        if let dateString = dict[PnutKey.created_at.rawValue] as? String {
            let dateFormatter = ISO8601DateFormatter()
            creationDate = dateFormatter.date(from: dateString)
        }
        
        if let contentDict = dict[PnutKey.content.rawValue] as? [String:Any] {
            content = Content(dict: contentDict, context: moc)
        }
        
        if let userDict = dict[PnutKey.user.rawValue] as? [String:Any] {
            user = User(dict: userDict, context: moc)
        }
    }
    
    enum PnutKey: String {
        case id
        case created_at
        case reply_to
        case thread_id
        case you_bookmarked
        case you_reposted
        case content
        case counts
        case bookmarks
        case replies
        case reposts
        case threads
        case source
        case link
        case name
        case user
    }
}
