//
//  SearchTableViewCell.swift
//  KaraokeApp
//
//  Created by Kishore Baskar on 7/25/17.
//  Copyright © 2017 Kishore Baskar. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var length: UILabel!
    @IBOutlet var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
