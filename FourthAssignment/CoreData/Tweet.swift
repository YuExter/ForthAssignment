//
//  Tweet.swift
//  CoreDataExample
//
//  Created by Юля Пономарева on 21.01.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit
import CoreData
import TwitterKit

class Tweet: NSManagedObject {
    
    class func findOrCreateTweet(matching twitterInfo: TweetStruct, in context: NSManagedObjectContext) throws -> Tweet
    {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "TweetStruct.findOrCreateTweet -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let tweet = Tweet(context: context)
        tweet.identifier = twitterInfo.identifier
        tweet.text = twitterInfo.text
        tweet.created = twitterInfo.created
        tweet.tweeter = try? TwitterUser.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)
        return tweet
    }
}

