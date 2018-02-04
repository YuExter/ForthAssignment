//
//  MentionTweetTableViewController.swift
//  FourthAssignment
//
//  Created by Юля Пономарева on 04.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit
import TwitterKit

class MentionTweetTableViewController: UITableViewController
{
    // MARK: Model
    fileprivate var tweets = [Array<TweetStruct>]()
    
    var searchText: String? {
        didSet {
            self.tweets.removeAll()
            self.tableView.reloadData()
            self.searchForTweets()
            self.title = searchText
        }
    }
    
    func insertTweets(_ newTweets: [TweetStruct]) {
        self.tweets.insert(newTweets, at:0)
        self.tableView.insertSections([0], with: .fade)
    }
    
    
    // MARK: Updating the Table
    fileprivate func twitterRequest() -> Request? {
        if let query = searchText, !query.isEmpty {
            return Request(search: "\(query) -filter:safe -filter:retweets", count: 100)
        }
        return nil
    }
    
    fileprivate func searchForTweets() {
        if let request = twitterRequest() {
            request.fetchTweets { [weak self] newTweets in
                guard let `self` = self else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.insertTweets(newTweets)
                }
            }
        }
    }
    
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath) as? TweetTableViewCell else { return UITableViewCell() }
        let tweet: TweetStruct = self.tweets[indexPath.section][indexPath.row]
        cell.tweet = tweet
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.tweets.count - section)"
    }
}
