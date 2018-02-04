//
//  MentionTableViewController.swift
//  FourthAssignment
//
//  Created by Юля Пономарева on 28.01.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit
import TwitterKit
import CoreData

class SmashTweetTableViewController: TweetTableViewController {
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [TweetStruct]) {
        super.insertTweets(newTweets)
        self.updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [TweetStruct]) {
        print("starting database load")
        self.container?.performBackgroundTask { [weak self] context in
            guard let `self` = self else { return }
            for twitterInfo in tweets {
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            print("done loading database")
            self.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = self.container?.viewContext {
            context.perform {
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
                if let tweeterCount = try? context.count(for: TwitterUser.fetchRequest()) {
                    print("\(tweeterCount) Twitter users")
                }
            }
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIds.showTweetersMentioningSearchTerm {
            guard let vc = segue.destination as? SmashTweetersTableViewController else {
                assertionFailure()
                return
            }
            vc.mention = self.searchText
            vc.container = self.container
        } else if segue.identifier == SegueIds.showTweetDetailed {
            guard let vc = segue.destination as? MentionsTableViewController,
            let tweet = sender as? TweetStruct else {
                assertionFailure()
                return
            }
            vc.tweet = tweet
        }
    }
}

extension SmashTweetTableViewController {
    fileprivate struct SegueIds {
        static let showTweetersMentioningSearchTerm = "showTweetersMentioningSearchTerm"
        static let showTweetDetailed = "showTweetDetailed"
    }
}

