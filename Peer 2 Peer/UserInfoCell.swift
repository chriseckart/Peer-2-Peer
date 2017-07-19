//
//  UserInfoCell.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 4/3/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
