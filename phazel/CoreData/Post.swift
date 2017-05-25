//  Created by dasdom on 05/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation

final class Post: NSObject {

    fileprivate(set) var id: String?
    fileprivate(set) var creationDate: Date?
    fileprivate(set) var replyTo: String?
    fileprivate(set) var threadId: String?
    fileprivate(set) var youBookmarked: Bool
    fileprivate(set) var youReposted: Bool
    fileprivate(set) var isDeleted: Bool
    fileprivate(set) var numberOfBookmarks: Int
    fileprivate(set) var numberOfReplies: Int
    fileprivate(set) var numberOfReposts: Int
    fileprivate(set) var numberOfThreads: Int
    fileprivate(set) var sourceLink: String?
    fileprivate(set) var sourceName: String?

    fileprivate(set) var content: Content?
    fileprivate(set) var user: User?

    init(dict: [String:Any]) {
        
        id = dict[PnutKey.id.rawValue] as? String
        replyTo = dict[PnutKey.reply_to.rawValue] as? String
        threadId = dict[PnutKey.thread_id.rawValue] as? String
        youBookmarked = dict[PnutKey.you_bookmarked.rawValue] as? Bool ?? false
        youReposted = dict[PnutKey.you_reposted.rawValue] as? Bool ?? false
        isDeleted = dict[PnutKey.is_deleted.rawValue] as? Bool ?? false
        
        if let counts = dict[PnutKey.counts.rawValue] as? [String:Int] {
            numberOfBookmarks = counts[PnutKey.bookmarks.rawValue] ?? 0
            numberOfReplies = counts[PnutKey.replies.rawValue] ?? 0
            numberOfReposts = counts[PnutKey.reposts.rawValue] ?? 0
            numberOfThreads = counts[PnutKey.threads.rawValue] ?? 0
        } else {
            numberOfBookmarks = 0
            numberOfReplies = 0
            numberOfReposts = 0
            numberOfThreads = 0
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
            content = Content(dict: contentDict)
        }
        
        if let userDict = dict[PnutKey.user.rawValue] as? [String:Any] {
            user = User(dict: userDict)
        }
        
        super.init()

        content?.post = self
        user?.post = self
    }
    
    enum PnutKey: String {
        case id
        case created_at
        case reply_to
        case thread_id
        case you_bookmarked
        case you_reposted
        case is_deleted
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

extension Post: NSCoding {
    convenience init?(coder aDecoder: NSCoder) {
        
        var dict: [String:Any] = [:]
       
        let stringKeys: [PnutKey] = [.id, .reply_to, .thread_id]
        for key in stringKeys {
            let keyString = key.rawValue
            dict[keyString] = aDecoder.decodeObject(of: NSString.self, forKey: keyString)
        }
        
        let keyString = PnutKey.created_at.rawValue
        if let createdAt = aDecoder.decodeObject(of: NSString.self, forKey: keyString) {
            dict[keyString] = createdAt
        }
        
        let boolKeys: [PnutKey] = [.you_bookmarked, .you_reposted, .is_deleted]
        for key in boolKeys {
            let keyString = key.rawValue
            dict[keyString] = aDecoder.decodeObject(of: NSNumber.self, forKey: keyString)
        }
        
        var countDict: [String:NSNumber] = [:]
        let intKeys: [PnutKey] = [.bookmarks, .replies, .reposts, .threads]
        for key in intKeys {
            let keyString = key.rawValue
            countDict[keyString] = aDecoder.decodeObject(of: NSNumber.self, forKey: keyString)
        }
        dict[PnutKey.counts.rawValue] = countDict
        
        var sourceDict: [String:NSString] = [:]
        let sourceKeys: [PnutKey] = [.link, .name]
        for key in sourceKeys {
            let keyString = key.rawValue
            sourceDict[keyString] = aDecoder.decodeObject(of: NSString.self, forKey: keyString)
        }
        dict[PnutKey.source.rawValue] = sourceDict
        
        self.init(dict: dict)
        
        content = aDecoder.decodeObject(of: Content.self, forKey: PnutKey.content.rawValue)
        content?.post = self
        
        user = aDecoder.decodeObject(of: User.self, forKey: PnutKey.user.rawValue)
        user?.post = self
    }
    
    func encode(with aCoder: NSCoder) {
        
        let strings: [PnutKey:String?] = [.id: id,
                                          .reply_to: replyTo,
                                          .thread_id: threadId]
        for (key, value) in strings {
            aCoder.encode(value, forKey: key.rawValue)
        }

        if let creationDate = creationDate {
            let dateFormatter = ISO8601DateFormatter()
            aCoder.encode(dateFormatter.string(from: creationDate), forKey: PnutKey.created_at.rawValue)
        }
        
        let bools: [PnutKey:Bool] = [.you_bookmarked: youBookmarked,
                                     .you_reposted: youReposted,
                                     .is_deleted: isDeleted]
        for (key, value) in bools {
            let boolNumber = NSNumber(booleanLiteral: value)
            aCoder.encode(boolNumber, forKey: key.rawValue)
        }
        
        let ints: [PnutKey:Int] = [.bookmarks: numberOfBookmarks,
                                   .replies: numberOfReplies,
                                   .reposts: numberOfReposts,
                                   .threads: numberOfThreads]
        for (key, value) in ints {
            let intNumber = NSNumber(integerLiteral: value)
            aCoder.encode(intNumber, forKey: key.rawValue)
        }
        
        let sourceStuff: [PnutKey:String?] = [.link: sourceLink,
                                              .name: sourceName]
        for (key, value) in sourceStuff {
            aCoder.encode(value, forKey: key.rawValue)
        }
        
        aCoder.encode(content, forKey: PnutKey.content.rawValue)
        aCoder.encode(user, forKey: PnutKey.user.rawValue)
    }
}
