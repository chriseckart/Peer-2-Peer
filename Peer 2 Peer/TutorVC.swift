//
//  TutorVC.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 4/12/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

import UIKit
import Firebase

class TutorVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, SendDataDelegate {
    
    @IBOutlet weak var selectClassButton: UIButton!
    
    @IBOutlet weak var tutorTableView: UITableView!
    
    @IBOutlet weak var appointmentSlotPicker: UIPickerView!
    
    var selectedTutorSlot = ""
    
    
    var ClassA = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassB = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassC = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassD = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassE = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassF = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassG = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassH = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    
    
    var selectedClass = SpecificClass(title: "none", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    
    var selectedBlock = ""
    
    // MARK: - ModalViewControllerDelegate protocol
    func sendSomething(data: SpecificClass, selectedBlock: String) {
        selectedClass = data
        print(selectedClass)
        selectClassButton.setTitle(selectedClass.title!, for: UIControlState.normal)
        self.tutorTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appointmentSlotPicker.delegate = self
        appointmentSlotPicker.dataSource = self
        
        tutorTableView.delegate = self
        tutorTableView.dataSource = self
        
//        let tapRecognizer = UITapGestureRecognizer()
//        tapRecognizer.addTarget(self, action: #selector(SignUpVC.didTapView))
//        self.view.addGestureRecognizer(tapRecognizer)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    
                        
                        let blockVars = [self.ClassA,self.ClassB,self.ClassC,self.ClassD,self.ClassE,self.ClassF,self.ClassG,self.ClassH]
                        
                        for blockVar in blockVars{
                            if blockVar.title == "Free"{
                                self.FreesArray.append(blockVar)
                            }
                        }
                        
                        self.tutorTableView.reloadData()

                    })}else{
                    databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("classes").child(ClassNameString).child("subject").setValue("none")
                    databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("classes").child(ClassNameString).child("title").setValue("none")
                }
            })
        }
        
        loadFirebaseIntoClasses(ClassName: ClassA, ClassNameString: "ClassA")
        loadFirebaseIntoClasses(ClassName: ClassB, ClassNameString: "ClassB")
        loadFirebaseIntoClasses(ClassName: ClassC, ClassNameString: "ClassC")
        loadFirebaseIntoClasses(ClassName: ClassD, ClassNameString: "ClassD")
        loadFirebaseIntoClasses(ClassName: ClassE, ClassNameString: "ClassE")
        loadFirebaseIntoClasses(ClassName: ClassF, ClassNameString: "ClassF")
        loadFirebaseIntoClasses(ClassName: ClassG, ClassNameString: "ClassG")
        loadFirebaseIntoClasses(ClassName: ClassH, ClassNameString: "ClassH")
        
    }
    
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    // MARK: - TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    var FreesArray = [SpecificClass]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 8
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "blockCell", for: indexPath)
        
        // Configure the cell...
        
        func checkIfFree(blockString: String, blockVar: SpecificClass){
            
            cell.textLabel?.text = blockString
            cell.detailTextLabel?.text = blockVar.title

            if blockVar.title == "Free"{
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.textLabel?.textColor = UIColor.green
                cell.detailTextLabel?.textColor = UIColor.green
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.textLabel?.textColor = UIColor.red
                cell.detailTextLabel?.textColor = UIColor.red
            }
            
        }
        
        switch indexPath.row{
        case 0: checkIfFree(blockString: "Block A", blockVar: ClassA)
        case 1: checkIfFree(blockString: "Block B", blockVar: ClassB)
        case 2: checkIfFree(blockString: "Block C", blockVar: ClassC)
        case 3: checkIfFree(blockString: "Block D", blockVar: ClassD)
        case 4: checkIfFree(blockString: "Block E", blockVar: ClassE)
        case 5: checkIfFree(blockString: "Block F", blockVar: ClassF)
        case 6: checkIfFree(blockString: "Block G", blockVar: ClassG)
        case 7: checkIfFree(blockString: "Block H", blockVar: ClassH)
        default: break
        }
        return cell
    }
    
    var selectedClassTable = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        func checkIfChecked(blockLetterString: String) {
            if cell?.detailTextLabel?.text == "Free"{
                cell?.accessoryType = .checkmark
                selectedBlock = blockLetterString
            }
            print(selectedBlock)
        }
        
        switch indexPath.row {
        case 0:
            selectedClassTable = ClassA
            checkIfChecked(blockLetterString: "A")
        case 1:
            selectedClassTable = ClassB
            checkIfChecked(blockLetterString: "B")
        case 2:
            selectedClassTable = ClassC
            checkIfChecked(blockLetterString: "C")
        case 3:
            selectedClassTable = ClassD
            checkIfChecked(blockLetterString: "D")
        case 4:
            selectedClassTable = ClassE
            checkIfChecked(blockLetterString: "E")
        case 5:
            selectedClassTable = ClassF
            checkIfChecked(blockLetterString: "F")
        case 6:
            selectedClassTable = ClassG
            checkIfChecked(blockLetterString: "G")
        case 7:
            selectedClassTable = ClassH
            checkIfChecked(blockLetterString: "H")
        default: break
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        switch indexPath.row {
        case 0:
            cell?.accessoryType = .none
        case 1:
            cell?.accessoryType = .none
        case 2:
            cell?.accessoryType = .none
        case 3:
            cell?.accessoryType = .none
        case 4:
            cell?.accessoryType = .none
        case 5:
            cell?.accessoryType = .none
        case 6:
            cell?.accessoryType = .none
        case 7:
            cell?.accessoryType = .none
        default: break
        }
        
    }
    
    // MARK: - Clear fields
    
//    @IBAction func clearButtonPressed(_ sender: Any) {
//        selectedClass = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
//        selectedBlock = ""
//        selectClassButton.setTitle(selectedClass.title!, for: UIControlState.normal)
//        self.tutorTableView.reloadData()
//    }
    
    
    
    // MARK: - UIPickerView delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row{
        case 0: return "Tutor Slot 1"
        case 1: return "Tutor Slot 2"
        case 2: return "Tutor Slot 3"
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row{
        case 0: selectedTutorSlot = "Appointment Slot 1"
        case 1: selectedTutorSlot = "Appointment Slot 2"
        case 2: selectedTutorSlot = "Appointment Slot 3"
        default: break
        }
        print(selectedTutorSlot)
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        print("!!!!!!!!!!!!!!!!!!!!!",selectedClass.title)
        print("?????????????????????",selectedBlock)

        if (selectedClass.title != "none") && (selectedBlock != "") && (selectedTutorSlot != ""){
            
            print("major success")
            
            var databaseRef: FIRDatabaseReference!
            databaseRef = FIRDatabase.database().reference()
            
            let userClassesRef = databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("signedUpTutorClasses").child(selectedTutorSlot)

            userClassesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                // update available tutors in specific class in firebase with tutorName and blockLetter
                let appointmentRef = databaseRef.child("Curriculum").child(self.selectedClass.subject!).child(self.selectedClass.title!).child("availableTutors").child("blockLetter").child(self.selectedBlock).childByAutoId()
                
                let autoID = appointmentRef.key
                
                print("ID IS!!!!!!!!!!",autoID)
                
                let specificAppointment = databaseRef.child("Curriculum").child(self.selectedClass.subject!).child(self.selectedClass.title!).child("availableTutors").child("blockLetter").child(self.selectedBlock).child(autoID)
                
                specificAppointment.child("tutorName").setValue(FIRAuth.auth()?.currentUser?.displayName)
                specificAppointment.child("studentID").setValue(FIRAuth.auth()?.currentUser?.uid)
                ///////////////////////////////////////////////////////////////////////////////////////
                
                
                // update user profile's signed up tutor classes with autoID
                let userRef = databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("signedUpTutorClasses").child(self.selectedTutorSlot)
                userRef.child("tutorID").setValue(autoID)
                userRef.child("subject").setValue(self.selectedClass.subject)
                userRef.child("title").setValue(self.selectedClass.title)
                userRef.child("blockLetter").setValue(self.selectedBlock)
                /////////////////////////////////////////////////////////////
                
                // remove id from prior class
                var localSubjectToRemove = ""
                var localClassToRemove = ""
                var localLetterToRemove = ""
                var localIDToRemove = ""
                
                if snapshot.exists(){
                    localSubjectToRemove = snapshot.childSnapshot(forPath: "subject").value as! String
                    localClassToRemove = snapshot.childSnapshot(forPath: "title").value as! String
                    localLetterToRemove = snapshot.childSnapshot(forPath: "blockLetter").value as! String
                    localIDToRemove = snapshot.childSnapshot(forPath: "tutorID").value as! String
                }
                
                if (localSubjectToRemove != "") && (localClassToRemove != "") && (localLetterToRemove != "") && (localIDToRemove != ""){
                    print("markkkkkk")
                    databaseRef.child("Curriculum").child(localSubjectToRemove).child(localClassToRemove).child("availableTutors").child("blockLetter").child(localLetterToRemove).child(localIDToRemove).removeValue()
                }
                /////////////////////////////

                
            })
            

            performSegue(withIdentifier: "tutorToFinishSegue", sender: self)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please select a class you can help with and choose an available block.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tutorToSubjectSegue"{
            let destination = segue.destination as! UINavigationController
            let nextViewController = destination.viewControllers[0] as! ChooseSubjectTableVC
            
            nextViewController.delegate = self
        }
        if segue.identifier == "tutorToFinishSegue"{
            let destination = segue.destination as! UINavigationController
            let nextViewController = destination.viewControllers[0] as! ThankYouTutorVC

            nextViewController.thanksText = "Thank you! You are now signed up as a tutor."
            nextViewController.chosenClassText = selectedClass.title!
            nextViewController.blockLetterText = selectedBlock
            
        }
    }
    
}
