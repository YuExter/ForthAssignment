//
//  TweetTableViewCell.swift
//  CoreDataExample
//
//  Created by Юля Пономарева on 21.01.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit
import TwitterKit

class TweetTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: TweetStruct? { didSet { updateUI() } }
    
    private func updateUI() {
        self.tweetTextLabel?.text = tweet?.text
        self.tweetUserLabel?.text = tweet?.user.description
        
        if let profileImageURL = self.tweet?.user.profileImageURL {
            DispatchQueue.main.async {
                if let imageData = try? Data(contentsOf: profileImageURL) {
                    self.tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
        } else {
            self.tweetProfileImageView?.image = nil
        }
        
        if let created = self.tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            self.tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            self.tweetCreatedLabel?.text = nil
        }
    }
    
    fileprivate func getColorForTextIn(tweet: TweetStruct) -> NSAttributedString
    {
        let text = NSMutableAttributedString(string: tweet.text)
        text.setColorFor(mentions: tweet.hashtags, color: .green)
        text.setColorFor(mentions: tweet.userMentions, color: .orange)
        text.setColorFor(mentions: tweet.urls, color: .blue)
        return text
    }
}


fileprivate extension NSMutableAttributedString {
    func setColorFor(mentions: [Mention], color: UIColor) {
        for mention in mentions {
            self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: mention.nsrange)
        }
    }
}

