//
//  StationListTableViewCell.swift
//  ttc-subway-times
//
//  Created by Alfred Choi on 2017-04-24.
//  Copyright © 2017 Alfred Choi. All rights reserved.
//

import UIKit

class StationListTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var stationName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
