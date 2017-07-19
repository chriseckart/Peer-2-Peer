//
//  ChooseClassTableVC.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 4/7/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

// this vc is for specific class (e.g. "ap calculus bc")

protocol SendDataDelegate
{
    func sendSomething(data: SpecificClass, selectedBlock: String)
}


import UIKit
import Firebase

class ChooseClassTableVC: UITableViewController {
    
    // MARK: ModalViewControllerDelegate protocol
    var delegate:SendDataDelegate?
    
    var selectedBlock = ""
    var classList = [SpecificClass]()
    var selectedSubject = ""
    var selectedClass = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    
    var presentingVCName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("selected block is on ChooseClassTableVC",selectedBlock)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        classList.removeAll()
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
        return classList.count
        // return number of classes in that subject
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = classList[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedClass = classList[indexPath.row]
        
        var databaseRef: FIRDatabaseReference!
        databaseRef = FIRDatabase.database().reference()
        
        if presentingVCName == "ChooseSubjectTableVC"{
            if selectedBlock != ""{
            databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("classes").child("\(selectedBlock)").child("title").setValue("\(selectedClass.title!)")
            databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("classes").child("\(selectedBlock)").child("subject").setValue("\(selectedClass.subject!)")
            }
        }
        
        print("delegate is !!!!!!!!!!!",delegate)
        
        if delegate != nil{
            delegate?.sendSomething(data: selectedClass, selectedBlock: selectedBlock)
            dismiss(animated: true, completion: nil)
        }
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
    }
}
