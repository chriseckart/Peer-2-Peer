//
//  SpecificClassCell.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 4/12/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

import UIKit

class SpecificClassCell: UITableViewCell {
    
    @IBOutlet weak var ClassTitleLabel: UILabel!
    @IBOutlet weak var RoomNumberLabel: UILabel!
    @IBOutlet weak var TeacherNameLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var BlockLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
