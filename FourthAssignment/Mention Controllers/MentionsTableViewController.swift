//
//  MentionsTableViewController.swift
//  FourthAssignment
//
//  Created by Юля Пономарева on 04.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit
import TwitterKit
import SafariServices

fileprivate struct Mentions: CustomStringConvertible {
    var title: String
    var data: [MentionItem]
    var description: String { return "\(data)" }
}

fileprivate enum MentionItem {
    case keyword(String)
    case image(URL, Double)
}

fileprivate enum Titles: String {
    case images = "Images"
    case hashtags = "Hashtags"
    case users = "Users"
    case urls = "Urls"
}

class MentionsTableViewController: UITableViewController {
    var tweet: TweetStruct! {
        didSet {
            if !tweet.media.isEmpty {
                self.mentions.append(Mentions(title: Titles.images.rawValue, data: tweet.media.map {
                    .image($0.url, $0.aspectRatio)
                }))
            }
            if !tweet.hashtags.isEmpty {
                mentions.append(Mentions(title: Titles.hashtags.rawValue, data: tweet.hashtags.map {
                    .keyword($0.keyword)
                }))
            }
            if !tweet.userMentions.isEmpty {
                mentions.append(Mentions(title: Titles.users.rawValue, data: tweet.userMentions.map {
                    .keyword($0.keyword)
                }))
            }
            if !tweet.urls.isEmpty {
                mentions.append(Mentions(title: Titles.urls.rawValue, data: tweet.urls.map {
                    .keyword($0.keyword)
                }))
            }
        }
    }
    
    fileprivate var mentions: [Mentions] = []
    
    override func viewDidLoad() {
        assert(tweet != nil)
        
        super.viewDidLoad()
    }
    
    
    //MARK - Table view data source, delegate
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.mentions.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mentions[section].data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mention = self.mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .image(_, let aspectRatio):
            return tableView.bounds.size.width / CGFloat(aspectRatio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .keyword(let keyword):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as? SmashMentionKeyWordsTableViewCell else { return UITableViewCell() }
            cell.label = keyword
            return cell
        case .image(let (url, _)):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as? SmashMentionImageTableViewCell else { return UITableViewCell() }
            cell.url = url
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.mentions[section].title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = mentions[indexPath.section]
        let sectionTitle = section.title
        let mention = section.data[indexPath.row]
        
        switch sectionTitle {
        case Titles.images.rawValue:
            performSegue(withIdentifier: "showFullScreenImage", sender: indexPath)
        case Titles.hashtags.rawValue:
            performSegue(withIdentifier: "showKeywordsResult", sender: indexPath)
        case Titles.users.rawValue:
            performSegue(withIdentifier: "showKeywordsResult", sender: indexPath)
        case Titles.urls.rawValue:
            if case .keyword(let url) = mention {
                if let url = URL(string: url) {
                    let vc = SFSafariViewController(url: url)
                    self.present(vc, animated: true, completion: nil)
                }
            }
        default:
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? IndexPath else { return }
        let mention = self.mentions[indexPath.section].data[indexPath.row]
        if segue.identifier == SegueIds.showFullScreenImage {
            guard let vc = segue.destination as? MentionImageViewController else {
                assertionFailure()
                return
            }
            if case .image(let url, _) = mention {
                vc.url = url
            }
        } else if segue.identifier == SegueIds.showKeywordsResult {
            guard let vc = segue.destination as? MentionTweetTableViewController else {
                    assertionFailure()
                    return
            }
            if case .keyword(let keyword) = mention {
                vc.searchText = keyword
            }
        }
    }
}

extension MentionsTableViewController {
    fileprivate struct SegueIds {
        static let showFullScreenImage = "showFullScreenImage"
        static let showKeywordsResult = "showKeywordsResult"
    }
}
