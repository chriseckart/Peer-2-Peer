//
//  AppointmentDetailsVC.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 4/18/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

import UIKit

class AppointmentDetailsVC: UIViewController {
    
    var appointmentDetails = Appointment(classTitle: "", appointmentDate: "", blockLetter: "", studentName: "", tutorName: "", appointmentDesc: "")
    
    @IBOutlet weak var StudentNameLabel: UILabel!
    @IBOutlet weak var TutorNameLabel: UILabel!
    @IBOutlet weak var ClassTitleLabel: UILabel!
    @IBOutlet weak var AppointmentDateLabel: UILabel!
    @IBOutlet weak var AppointmentBlockLabel: UILabel!
    @IBOutlet weak var AppointmentDescriptionTextView: UITextView!
    

    override func viewWillAppear(_ animated: Bool) {
        StudentNameLabel.text = appointmentDetails.studentName
        TutorNameLabel.text = appointmentDetails.tutorName
        ClassTitleLabel.text = appointmentDetails.classTitle
        AppointmentDateLabel.text = appointmentDetails.appointmentDate
        AppointmentBlockLabel.text = appointmentDetails.blockLetter
        AppointmentDescriptionTextView.text = appointmentDetails.appointmentDesc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
