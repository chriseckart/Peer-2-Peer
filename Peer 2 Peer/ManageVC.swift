//
//  ManageVC.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 3/30/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ManageVC: UITableViewController {
    
    var profileImage = UIImage()
    var profileName = ""
    
    // NOT ACTUALLY APPOINTMENTS BUT THE OBJECT WORKS SO
    var signedUpTutorClass1 = Appointment(classTitle: "", appointmentDate: "", blockLetter: "", studentName: "", tutorName: "", appointmentDesc: "")
    var signedUpTutorClass2 = Appointment(classTitle: "", appointmentDate: "", blockLetter: "", studentName: "", tutorName: "", appointmentDesc: "")
    var signedUpTutorClass3 = Appointment(classTitle: "", appointmentDate: "", blockLetter: "", studentName: "", tutorName: "", appointmentDesc: "")
    
    var tutoringAppointment1 = Appointment(classTitle: "", appointmentDate: "", blockLetter: "", studentName: "", tutorName: "", appointmentDesc: "")
    var tutoringAppointment2 = Appointment(classTitle: "", appointmentDate: "", blockLetter: "", studentName: "", tutorName: "", appointmentDesc: "")
    var tutoringAppointment3 = Appointment(classTitle: "", appointmentDate: "", blockLetter: "", studentName: "", tutorName: "", appointmentDesc: "")
    
    var beingTutoredAppointment1 = Appointment(classTitle: "", appointmentDate: "", blockLetter: "", studentName: "", tutorName: "", appointmentDesc: "")
    var beingTutoredAppointment2 = Appointment(classTitle: "", appointmentDate: "", blockLetter: "", studentName: "", tutorName: "", appointmentDesc: "")
    var beingTutoredAppointment3 = Appointment(classTitle: "", appointmentDate: "", blockLetter: "", studentName: "", tutorName: "", appointmentDesc: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if FIRAuth.auth()!.currentUser == nil {
            attemptLogout()
        }
                
        var databaseRef: FIRDatabaseReference!
        databaseRef = FIRDatabase.database().reference()
        
        // receive signed up tutor classes
        databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value
            , with: { (snapshot) in
                
                
                func retrieveTutorClasses(tutorClassSlotVar: Appointment, tutorClassSlot: String){
                    
                    print("1) this far")
                
                    if snapshot.hasChild("signedUpTutorClasses"){
                        databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("signedUpTutorClasses").observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.hasChild(tutorClassSlot){
                                
                                print("2) this far")
                                databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("signedUpTutorClasses").child(tutorClassSlot).observeSingleEvent(of: .value, with: { (snapshot) in
                                    
                                    var localTutorSubject = ""
                                    var localTutorClassTitle = ""
                                    var localTutorClassID = ""
                                    var localTutorBlock = ""
                                    
                                    localTutorSubject = snapshot.childSnapshot(forPath: "subject").value as! String
                                    localTutorClassTitle = snapshot.childSnapshot(forPath: "title").value as! String
                                    localTutorClassID = snapshot.childSnapshot(forPath: "tutorID").value as! String
                                    localTutorBlock = snapshot.childSnapshot(forPath: "blockLetter").value as! String
                                    
                                    
                                    databaseRef.child("Curriculum").child(localTutorSubject).child(localTutorClassTitle).observeSingleEvent(of: .value, with: { (snapshot) in
                                        if snapshot.hasChild("availableTutors"){
                                            databaseRef.child("Curriculum").child(localTutorSubject).child(localTutorClassTitle).child("availableTutors").child("blockLetter").child(localTutorBlock).child(localTutorClassID).observeSingleEvent(of: .value, with: { (snapshot) in
                                                
                                                print("3) this far")
                                                
                                                tutorClassSlotVar.classTitle = localTutorClassTitle
                                                tutorClassSlotVar.blockLetter = localTutorBlock
                                                
                                                self.tableView.reloadData()
                                            })
                                        }
                                    })
                                })
                            }
                        })
                    }
                    
                }
                
                retrieveTutorClasses(tutorClassSlotVar: self.signedUpTutorClass1, tutorClassSlot: "Appointment Slot 1")
                retrieveTutorClasses(tutorClassSlotVar: self.signedUpTutorClass2, tutorClassSlot: "Appointment Slot 2")
                retrieveTutorClasses(tutorClassSlotVar: self.signedUpTutorClass3, tutorClassSlot: "Appointment Slot 3")
                
        })
        
        
        // receive appointments
        databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("name").observeSingleEvent(of: .value, with: { (snapshot ) in
            
            self.profileName = snapshot.value as! String
            
            
            func retrieveAppointment(appointmentType: String, appointmentName: String, appointmentVar: Appointment){
                
                databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild("appointments"){
                    
                        databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("appointments").child(appointmentType).observeSingleEvent(of: .value, with: { (snapshot ) in
                    
                            if snapshot.hasChild(appointmentName) {
                    
                                print(appointmentName)
                    
                                appointmentVar.classTitle = snapshot.childSnapshot(forPath: appointmentName).childSnapshot(forPath: "classTitle").value as? String
                                appointmentVar.appointmentDate = snapshot.childSnapshot(forPath: appointmentName).childSnapshot(forPath: "appointmentDate").value as? String
                                appointmentVar.blockLetter = snapshot.childSnapshot(forPath: appointmentName).childSnapshot(forPath: "blockLetter").value as? String
                                appointmentVar.studentName = snapshot.childSnapshot(forPath: appointmentName).childSnapshot(forPath: "studentName").value as? String
                                appointmentVar.tutorName = snapshot.childSnapshot(forPath: appointmentName).childSnapshot(forPath: "tutorName").value as? String
                                appointmentVar.appointmentDesc = snapshot.childSnapshot(forPath: appointmentName).childSnapshot(forPath: "appointmentDesc").value as? String
                    
                                self.tableView.reloadData()
                            }
                    
                        })

                    }
                })
                
            }
            
            retrieveAppointment(appointmentType: "tutoring", appointmentName: "Appointment Slot 1", appointmentVar: self.tutoringAppointment1)
            retrieveAppointment(appointmentType: "being tutored", appointmentName: "Appointment Slot 1", appointmentVar: self.beingTutoredAppointment1)
            
            retrieveAppointment(appointmentType: "tutoring", appointmentName: "Appointment Slot 2", appointmentVar: self.tutoringAppointment2)
            retrieveAppointment(appointmentType: "being tutored", appointmentName: "Appointment Slot 2", appointmentVar: self.beingTutoredAppointment2)
            
            retrieveAppointment(appointmentType: "tutoring", appointmentName: "Appointment Slot 3", appointmentVar: self.tutoringAppointment3)
            retrieveAppointment(appointmentType: "being tutored", appointmentName: "Appointment Slot 3", appointmentVar: self.beingTutoredAppointment3)
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1{
            return "Classes you are available to tutor in:"
        } else if section == 2{
            return "Tutoring:"
        }else {
            return "Being tutored by:"
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        } else if section == 1{
            return 3
            //return number of classes signed up to tutor in
        } else if section == 2{
            return 3
            //return number of tutoring appointments (rn just 5)
        } else {
            return 3
            //return number of how many you are tutored
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0 {
                return 85
            } else {
                return 44
            }
        } else if indexPath.section == 1{
            return 44
        } else {
            return 65
        }
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            
            if indexPath.row == 0 {
                // User Info cell
                
                // Table view cells are reused and should be dequeued using a cell identifier.
                let cellIdentifier1 = "UserInfoCell"
            
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier1, for: indexPath) as? UserInfoCell  else {
                    fatalError("The dequeued cell is not an instance of UserInfoCell.")
                }
                // Fetches the appropriate cell for the data source layout.

                let imageURL = FIRAuth.auth()?.currentUser?.photoURL
                let imageData = NSData(contentsOf:(imageURL)!)
                
                if imageData != nil {
                    cell.profileImage.image = UIImage(data: imageData! as Data)
                }
                
                cell.userName.text = profileName
                
                return cell
                
            } else {
                // Schedule cell
                
                // Table view cells are reused and should be dequeued using a cell identifier.
                let cellIdentifier2 = "ScheduleCell"
            
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier2, for: indexPath)
                // Fetches the appropriate cell for the data source layout.
                
                cell.textLabel?.text = "Schedule"
                
                return cell
                
            }
        } else if (indexPath.section == 1) {
            // what classes you are signed up to tutor in
            
            let cellIdentifier = "TutoringClassesCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

            switch indexPath.row {
            case 0:
                cell.textLabel?.text = signedUpTutorClass1.classTitle
                cell.detailTextLabel?.text = signedUpTutorClass1.blockLetter
            case 1:
                cell.textLabel?.text = signedUpTutorClass2.classTitle
                cell.detailTextLabel?.text = signedUpTutorClass2.blockLetter
            case 2:
                cell.textLabel?.text = signedUpTutorClass3.classTitle
                cell.detailTextLabel?.text = signedUpTutorClass3.blockLetter
            default: break
            }
            
            return cell
            
        } else if (indexPath.section == 2) {
            // Who you are tutoring
          
            // Table view cells are reused and should be dequeued using a cell identifier.
            let cellIdentifier = "TutorCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TutorCell  else {
                fatalError("The dequeued cell is not an instance of TutorCell.")
            }
            // Fetches the appropriate cell for the data source layout.
            
            switch indexPath.row{
            case 0:
                cell.StudentNameLabel.text = tutoringAppointment1.studentName
                cell.AppointmentDateTimeLabel.text = tutoringAppointment1.appointmentDate! + ", " + tutoringAppointment1.blockLetter! + " block"
                cell.SubjectLabel.text = tutoringAppointment1.classTitle
            case 1:
                cell.StudentNameLabel.text = tutoringAppointment2.studentName
                cell.AppointmentDateTimeLabel.text = tutoringAppointment2.appointmentDate! + ", " + tutoringAppointment2.blockLetter! + " block"
                cell.SubjectLabel.text = tutoringAppointment2.classTitle
            case 2:
                cell.StudentNameLabel.text = tutoringAppointment3.studentName
                cell.AppointmentDateTimeLabel.text = tutoringAppointment3.appointmentDate! + ", " + tutoringAppointment3.blockLetter! + " block"
                cell.SubjectLabel.text = tutoringAppointment3.classTitle
            default: break
            }
            
            return cell
            
        } else {
            // Who you are being tutored by
            
            // Table view cells are reused and should be dequeued using a cell identifier.
            let cellIdentifier = "TutorCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TutorCell  else {
                fatalError("The dequeued cell is not an instance of TutorCell.")
            }
            // Fetches the appropriate cell for the data source layout.
            
            switch indexPath.row{
            case 0:
                cell.StudentNameLabel.text = beingTutoredAppointment1.tutorName
                cell.AppointmentDateTimeLabel.text = beingTutoredAppointment1.appointmentDate! + ", " + beingTutoredAppointment1.blockLetter! + " block"
                cell.SubjectLabel.text = beingTutoredAppointment1.classTitle
            case 1:
                cell.StudentNameLabel.text = beingTutoredAppointment2.tutorName
                cell.AppointmentDateTimeLabel.text = beingTutoredAppointment2.appointmentDate! + ", " + beingTutoredAppointment2.blockLetter! + " block"
                cell.SubjectLabel.text = beingTutoredAppointment2.classTitle
            case 2:
                cell.StudentNameLabel.text = beingTutoredAppointment3.tutorName
                cell.AppointmentDateTimeLabel.text = beingTutoredAppointment3.appointmentDate! + ", " + beingTutoredAppointment3.blockLetter! + " block"
                cell.SubjectLabel.text = beingTutoredAppointment3.classTitle
            default: break
            }
            
            return cell

        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            performSegue(withIdentifier: "manageToScheduleSegue", sender: self)
        }
        if indexPath.section == 2 {
            switch indexPath.row{
            case 0: chosenAppointment = tutoringAppointment1
            case 1: chosenAppointment = tutoringAppointment2
            case 2: chosenAppointment = tutoringAppointment3
            default: break
            }
            
            performSegue(withIdentifier: "manageToAppointmentDetailsSegue", sender: self)
        }
        if indexPath.section == 3 {
            switch indexPath.row{
            case 0: chosenAppointment = beingTutoredAppointment1
            case 1: chosenAppointment = beingTutoredAppointment2
            case 2: chosenAppointment = beingTutoredAppointment3
            default: break
            }
            performSegue(withIdentifier: "manageToAppointmentDetailsSegue", sender: self)
        }
    }
    
    
//     Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
    

    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
    

    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
    

    
    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
    
    // MARK: Logout / deauthenticate
    @IBAction func logout(_ sender: Any) {
        attemptLogout()
    }
    
    func attemptLogout() {
        do {
            print("logout being attempted")
            try! FIRAuth.auth()?.signOut()
            try! GIDSignIn.sharedInstance().signOut()
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    // MARK: - Navigation
    
    var chosenAppointment = Appointment(classTitle: "", appointmentDate: "", blockLetter: "", studentName: "", tutorName: "", appointmentDesc: "")
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "manageToAppointmentDetailsSegue"{
            let destination = segue.destination as! AppointmentDetailsVC
            
            print(chosenAppointment.tutorName)
            print(chosenAppointment.appointmentDesc)
            
            destination.appointmentDetails = chosenAppointment
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
