//
//  SmashMentionImageTableViewCell.swift
//  FourthAssignment
//
//  Created by Юля Пономарева on 29.01.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit
import TwitterKit

class SmashMentionImageTableViewCell: UITableViewCell {
    @IBOutlet fileprivate var tweetImageView: UIImageView!
    
    var url: URL? {
        didSet {
            guard
                let url = url,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.tweetImageView.image = image
            }
        }
    }
}
