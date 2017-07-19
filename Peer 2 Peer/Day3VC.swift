//
//  Day3VC.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 4/12/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

import UIKit
import Firebase

class Day3VC: UITableViewController, SendDataDelegate {
    
    var ClassC = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassG = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassE = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassA = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    
    var selectedClass = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var selectedBlock = ""
    
    // MARK: - SendDataDelegate
    func sendSomething(data: SpecificClass, selectedBlock: String) {
        //        ClassA.teacher = ClassList.init().MathematicsClasses[
        // could pull from the firebase or have it all local or smttthhh
        selectedClass = data
        
        switch selectedBlock {
        case "ClassC":   ClassC = selectedClass
            
        case "ClassG":   ClassG = selectedClass
            
        case "ClassE":   ClassE = selectedClass
            
        case "ClassA":   ClassA = selectedClass
            
        default: break
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var databaseRef: FIRDatabaseReference!
        databaseRef = FIRDatabase.database().reference()
        
        var subject: String!
        var classTitle: String!
        
        func loadFirebaseIntoClasses(ClassName: SpecificClass, ClassNameString: String){
            
            databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("classes").child(ClassNameString).observeSingleEvent(of: .value, with: { (snapshot ) in
                
                if snapshot.exists() {
                    
                    //retrieve subject
                    subject = snapshot.childSnapshot(forPath: "subject").value as! String
//                    print("current subject is ", subject)
                    //retrieve class title
                    classTitle = snapshot.childSnapshot(forPath: "title").value as! String
//                    print("current classTitle is ", classTitle)
                    
                    
                    databaseRef.child("Curriculum").child(subject).child(classTitle).observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.exists(){
                            ClassName.title = snapshot.childSnapshot(forPath: "title").value as! String
                            ClassName.teacher = snapshot.childSnapshot(forPath: "teacher").value as! String
                            ClassName.roomnumber = snapshot.childSnapshot(forPath: "roomnumber").value as! String
                        }
                        
                        self.tableView.reloadData()
                    })}else{
                    databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("classes").child(ClassNameString).child("subject").setValue("none")
                    databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("classes").child(ClassNameString).child("title").setValue("none")
                }
            })
        }
        
        loadFirebaseIntoClasses(ClassName: ClassC, ClassNameString: "ClassC")
        loadFirebaseIntoClasses(ClassName: ClassG, ClassNameString: "ClassG")
        loadFirebaseIntoClasses(ClassName: ClassE, ClassNameString: "ClassE")
        loadFirebaseIntoClasses(ClassName: ClassA, ClassNameString: "ClassA")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenSize = UIScreen.main.bounds
        return screenSize.height / 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SpecificClassCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SpecificClassCell  else {
            fatalError("The dequeued cell is not an instance of SpecificClassCell.")
        }
        // Configure the cell...
        
        switch indexPath.row {
        case 0:
            cell.ClassTitleLabel.text = ClassC.title
            cell.RoomNumberLabel.text = ClassC.roomnumber
            cell.TeacherNameLabel.text = ClassC.teacher
            cell.TimeLabel.text = "8:30 AM - 9:45 AM"
            cell.BlockLabel.text = "Block C"
        case 1:
            cell.ClassTitleLabel.text = ClassG.title
            cell.RoomNumberLabel.text = ClassG.roomnumber
            cell.TeacherNameLabel.text = ClassG.teacher
            cell.TimeLabel.text = "10:25 AM - 11:40 AM"
            cell.BlockLabel.text = "Block G"
        case 2:
            cell.ClassTitleLabel.text = ClassE.title
            cell.RoomNumberLabel.text = ClassE.roomnumber
            cell.TeacherNameLabel.text = ClassE.teacher
            cell.TimeLabel.text = "12:20 PM - 1:35 PM"
            cell.BlockLabel.text = "Block E"
        case 3:
            cell.ClassTitleLabel.text = ClassA.title
            cell.RoomNumberLabel.text = ClassA.roomnumber
            cell.TeacherNameLabel.text = ClassA.teacher
            cell.TimeLabel.text = "2:00 PM - 3:15 PM"
            cell.BlockLabel.text = "Block A"
        default: break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Day 3"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: selectedBlock = "ClassC"
        case 1: selectedBlock = "ClassG"
        case 2: selectedBlock = "ClassE"
        case 3: selectedBlock = "ClassA"
        default: break
        }
        performSegue(withIdentifier: "Day3ToSubjectSegue", sender: self)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Day3ToSubjectSegue"{
            let destination = segue.destination as! UINavigationController
            let nextViewController = destination.viewControllers[0] as! ChooseSubjectTableVC
            
            nextViewController.delegate = self
            
            switch selectedBlock {
            case "ClassC": nextViewController.selectedBlock = "ClassC"
            case "ClassG": nextViewController.selectedBlock = "ClassG"
            case "ClassE": nextViewController.selectedBlock = "ClassE"
            case "ClassA": nextViewController.selectedBlock = "ClassA"
            default: break
            }
            
        }
    }
    
}
