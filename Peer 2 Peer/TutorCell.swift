//
//  TutorCell.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 3/30/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

import UIKit

class TutorCell: UITableViewCell {
    
    @IBOutlet weak var StudentNameLabel: UILabel!
    @IBOutlet weak var AppointmentDateTimeLabel: UILabel!
    @IBOutlet weak var SubjectLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
