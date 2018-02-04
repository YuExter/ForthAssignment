//
//  TwitterUser.swift
//  CoreDataExample
//
//  Created by Юля Пономарева on 21.01.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit
import CoreData
import TwitterKit

class TwitterUser: NSManagedObject {
    
    static func findOrCreateTwitterUser(matching twitterInfo: User, in context: NSManagedObjectContext) throws -> TwitterUser
    {
        let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        request.predicate = NSPredicate(format: "handle = %@", twitterInfo.screenName)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "TwitterUser.findOrCreateTwitterUser -- database inconsistency!")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let twitterUser = TwitterUser(context: context)
        twitterUser.handle = twitterInfo.screenName
        twitterUser.name = twitterInfo.name
        return twitterUser
    }
}

