//
//  MentionImageTableViewCell.swift
//  FourthAssignment
//
//  Created by Юля Пономарева on 29.01.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit
import CoreData

class SmashTweetersTableViewController: FetchedResultsTableViewController
{
    
    var mention: String? { didSet { updateUI() } }
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
        didSet
        {
            self.updateUI()
            
        }
        
    }
    
    var fetchedResultsController: NSFetchedResultsController<TwitterUser>?
    
    fileprivate func updateUI() {
        if let context = self.container?.viewContext, self.mention != nil {
            let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(
                key: "handle",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@", mention!)
            fetchedResultsController = NSFetchedResultsController<TwitterUser>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            self.fetchedResultsController?.delegate = self
            try? fetchedResultsController?.performFetch()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUser Cell", for: indexPath)
        
        if let twitterUser = self.fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = twitterUser.handle
            let tweetCount = tweetCountWithMentionBy(twitterUser)
            cell.detailTextLabel?.text = "\(tweetCount) tweet\((tweetCount == 1) ? "" : "s")"
        }
        
        return cell
    }
    
    fileprivate func tweetCountWithMentionBy(_ twitterUser: TwitterUser) -> Int {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "text contains[c] %@ and tweeter = %@", mention!, twitterUser)
        return (try? twitterUser.managedObjectContext!.count(for: request)) ?? 0
    }
}


