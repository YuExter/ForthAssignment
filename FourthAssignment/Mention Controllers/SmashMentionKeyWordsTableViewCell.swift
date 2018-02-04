//
//  SmashMentionKeyWordsTableViewCell.swift
//  FourthAssignment
//
//  Created by Юля Пономарева on 29.01.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit

class SmashMentionKeyWordsTableViewCell: UITableViewCell {
    @IBOutlet fileprivate var keyWordLabel: UILabel!
    
    var label: String? {
        didSet {
            self.keyWordLabel.text = label
        }
    }
}
