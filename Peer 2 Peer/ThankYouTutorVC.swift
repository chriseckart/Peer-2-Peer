//
//  ThankYouTutorVC.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 4/21/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

import UIKit

class ThankYouTutorVC: UIViewController {
    
    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var chosenClassLabel: UILabel!
    @IBOutlet weak var blockLetterLabel: UILabel!
    
    var thanksText = ""
    var chosenClassText = ""
    var blockLetterText = ""
    
    // only used if scheduling appointment
    @IBOutlet weak var appointmentDateTitleLabel: UILabel!
    @IBOutlet weak var appointmentDescTitleLabel: UILabel!
    @IBOutlet weak var tutorNameTitleLabel: UILabel!
    
    var appointmentDateTitleText = ""
    var appointmentDescTitleText = ""
    var tutorNameTitleText = ""
    
    @IBOutlet weak var appointmentDateLabel: UILabel!
    @IBOutlet weak var appointmentDescLabel: UITextView!
    @IBOutlet weak var tutorNameLabel: UILabel!
    
    var appointmentDateText = ""
    var appointmentDescText = ""
    var tutorNameText = ""
    
    override func viewWillAppear(_ animated: Bool) {
    
        thanksLabel.text = thanksText
        chosenClassLabel.text = chosenClassText
        blockLetterLabel.text = blockLetterText
        
        appointmentDateLabel.text = appointmentDateText
        appointmentDescLabel.text = appointmentDescText
        tutorNameLabel.text = tutorNameText
        
        appointmentDateTitleLabel.text = appointmentDateTitleText
        appointmentDescTitleLabel.text = appointmentDescTitleText
        tutorNameTitleLabel.text = tutorNameTitleText
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
