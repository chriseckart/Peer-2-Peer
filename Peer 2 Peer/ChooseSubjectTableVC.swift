//
//  ChooseSubjectTableVC.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 4/7/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

// this vc is for broad subject (e.g. "math")

import UIKit
import Firebase

class ChooseSubjectTableVC: UITableViewController {
    
    var selectedBlock = ""
    
    // MARK: ModalViewControllerDelegate protocol
    var delegate:SendDataDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        print("the selectedblock on choosesubjecttableVC is ", selectedBlock)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath)
            
        // Configure the cell...
        switch indexPath.row {
        case 0: cell.textLabel?.text = "Mathematics"
        case 1: cell.textLabel?.text = "Science"
        case 2: cell.textLabel?.text = "English"
        case 3: cell.textLabel?.text = "History"
        case 4: cell.textLabel?.text = "Language"
        case 5: cell.textLabel?.text = "Other"
        default: cell.textLabel?.text = "Error in loading subject cell"
        }

        return cell
    }
    
    var selectedClass = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var selectedSubject = ""
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)
        
//        if indexPath.section == 0 {
//            selectedClass.title = (currentCell?.textLabel?.text!)!
//            
//            let currentCell = tableView.cellForRow(at: indexPath)
//            selectedClass.title = (currentCell?.textLabel?.text)!
//            
//            if delegate != nil{
//                delegate?.sendSomething(data: selectedClass, selectedBlock: "")
//                dismiss(animated: true, completion: nil)
//            }
//            
//        }else{
            selectedSubject = (currentCell?.textLabel?.text)!
            performSegue(withIdentifier: "subjectToClassSegue", sender: self)
//        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "My classes"
//        }else{
            return "All classes"
//        }
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
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "subjectToClassSegue"{
            
            let TargetDestination = segue.destination as! ChooseClassTableVC
            
            //let DestViewController = segue.destination as! UINavigationController
            //let TargetDestination = DestViewController.topViewController as! ChooseClassTableVC
            
            TargetDestination.classList.removeAll()
            
            print(selectedSubject)
            
            // passing the delegate to chooseclass
            TargetDestination.delegate = self.delegate
            TargetDestination.presentingVCName = "ChooseSubjectTableVC"
            
            var databaseRef: FIRDatabaseReference!
            databaseRef = FIRDatabase.database().reference()
            
            var MathematicsClasses1 = [SpecificClass]()
            var ScienceClasses1 = [SpecificClass]()
            var EnglishClasses1 = [SpecificClass]()
            var HistoryClasses1 = [SpecificClass]()
            var LanguageClasses1 = [SpecificClass]()
            var OtherClasses1 = [SpecificClass]()
            
            
            // MARK: - refactored function that retrieves each class inside a subject in the database
            func appendClassToList(subject: String, subjectArray: Array<SpecificClass>){
                var subjectArray = subjectArray
                
                databaseRef.child("Curriculum").child(subject).observe(.value, with: { snapshot in
                    for child in snapshot.children {
                        let certainClass = SpecificClass(snapshot:child as! FIRDataSnapshot)
                        
                        subjectArray.append(certainClass)
                        
                        print(subjectArray)
                    }
                    TargetDestination.classList = subjectArray
                    TargetDestination.tableView.reloadData()
                    //pull data from firebase, put SpecificClass objects into subject array
                })
            }
            
            // MARK: Send data to ChooseClassTableVC
            switch selectedSubject {
            
            // MARK: append retrieved classes to ChooseClassTableVC's subjectArray, which changes based on the selected class from above
            case "Mathematics":
                appendClassToList(subject: "Mathematics", subjectArray: MathematicsClasses1)
                
            case "Science":
                appendClassToList(subject: "Science", subjectArray: ScienceClasses1)

            case "English":
                appendClassToList(subject: "English", subjectArray: EnglishClasses1)

            case "History":
                appendClassToList(subject: "History", subjectArray: HistoryClasses1)

            case "Language":
                appendClassToList(subject: "Language", subjectArray: LanguageClasses1)

            case "Other":
                appendClassToList(subject: "Other", subjectArray: OtherClasses1)

            default: TargetDestination.classList = []
                
            }
            
            TargetDestination.selectedSubject = selectedSubject
            TargetDestination.selectedBlock = selectedBlock
            print(TargetDestination.classList)
        }
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func dismissChooseClassTableVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
