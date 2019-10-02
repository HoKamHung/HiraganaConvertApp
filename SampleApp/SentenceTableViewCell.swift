//
//  SentenceTableViewCell.swift
//  SampleApp
//
//  Created by Ho Kam Hung on 2/10/2019.
//  Copyright © 2019 Ho Kam Hung. All rights reserved.
//

import UIKit

class SentenceTableViewCell: UITableViewCell {

    @IBOutlet weak var InputLabel: UILabel!
    @IBOutlet weak var ResultLabel: UILabel!
    @IBOutlet weak var LoadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
