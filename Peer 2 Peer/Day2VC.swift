//
//  Day2VC.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 4/12/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

import UIKit
import Firebase

class Day2VC: UITableViewController, SendDataDelegate {
    
    var ClassB = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassF = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassH = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassD = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    
    var selectedClass = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var selectedBlock = ""
    
    // MARK: - SendDataDelegate
    func sendSomething(data: SpecificClass, selectedBlock: String) {
        selectedClass = data
        
        switch selectedBlock {
        case "ClassB":   ClassB = selectedClass
            
        case "ClassF":   ClassF = selectedClass
            
        case "ClassH":   ClassH = selectedClass
            
        case "ClassD":   ClassD = selectedClass
            
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
                    })
                }else{
                    databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("classes").child(ClassNameString).child("subject").setValue("none")
                    databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("classes").child(ClassNameString).child("title").setValue("none")
                }
            })
        }
        
        loadFirebaseIntoClasses(ClassName: ClassB, ClassNameString: "ClassB")
        loadFirebaseIntoClasses(ClassName: ClassF, ClassNameString: "ClassF")
        loadFirebaseIntoClasses(ClassName: ClassH, ClassNameString: "ClassH")
        loadFirebaseIntoClasses(ClassName: ClassD, ClassNameString: "ClassD")
        
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
            cell.ClassTitleLabel.text = ClassB.title
            cell.RoomNumberLabel.text = ClassB.roomnumber
            cell.TeacherNameLabel.text = ClassB.teacher
            cell.TimeLabel.text = "8:30 AM - 9:45 AM"
            cell.BlockLabel.text = "Block B"
        case 1:
            cell.ClassTitleLabel.text = ClassF.title
            cell.RoomNumberLabel.text = ClassF.roomnumber
            cell.TeacherNameLabel.text = ClassF.teacher
            cell.TimeLabel.text = "10:25 AM - 11:40 AM"
            cell.BlockLabel.text = "Block F"
        case 2:
            cell.ClassTitleLabel.text = ClassH.title
            cell.RoomNumberLabel.text = ClassH.roomnumber
            cell.TeacherNameLabel.text = ClassH.teacher
            cell.TimeLabel.text = "12:20 PM - 1:35 PM"
            cell.BlockLabel.text = "Block H"
        case 3:
            cell.ClassTitleLabel.text = ClassD.title
            cell.RoomNumberLabel.text = ClassD.roomnumber
            cell.TeacherNameLabel.text = ClassD.teacher
            cell.TimeLabel.text = "2:00 PM - 3:15 PM"
            cell.BlockLabel.text = "Block D"
        default: break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Day 2"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: selectedBlock = "ClassB"
        case 1: selectedBlock = "ClassF"
        case 2: selectedBlock = "ClassH"
        case 3: selectedBlock = "ClassD"
        default: break
        }
        performSegue(withIdentifier: "Day2ToSubjectSegue", sender: self)
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
        if segue.identifier == "Day2ToSubjectSegue"{
            let destination = segue.destination as! UINavigationController
            let nextViewController = destination.viewControllers[0] as! ChooseSubjectTableVC
            
            nextViewController.delegate = self
            
            print(selectedBlock)
            
            switch selectedBlock {
            case "ClassB": nextViewController.selectedBlock = "ClassB"
            case "ClassF": nextViewController.selectedBlock = "ClassF"
            case "ClassH": nextViewController.selectedBlock = "ClassH"
            case "ClassD": nextViewController.selectedBlock = "ClassD"
            default: break
            }
            
        }
    }
    
}
