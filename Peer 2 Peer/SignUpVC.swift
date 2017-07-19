//
//  SignUpVC.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 3/30/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, SendDataDelegate {
    
    
    var ClassA = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassB = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassC = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassD = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassE = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassF = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassG = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    var ClassH = SpecificClass(title: "", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")

    
    @IBOutlet weak var tutorTableView: UITableView!
    
    var selectedClass = SpecificClass(title: "none", teacher: "", roomnumber: "", prerequisites: "", description: "", subject: "")
    
    var selectedAppointmentSlot = ""

    // MARK: - ModalViewControllerDelegate protocol
    func sendSomething(data: SpecificClass, selectedBlock: String) {
        selectedClass = data
        print(selectedClass)
        selectClassButton.setTitle(selectedClass.title!, for: UIControlState.normal)
    }
    
    
    @IBOutlet weak var selectClassButton: UIButton!
    
    @IBOutlet weak var appointmentSlotPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tutorTableView.delegate = self
        self.tutorTableView.dataSource = self
        
        self.appointmentSlotPicker.delegate = self
        self.appointmentSlotPicker.dataSource = self
        
        // check if authenticated!
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user == nil {
                // No User is signed in. Show user the login screen
//                present(LoginVC, animated: true, completion: nil)
            }
        }
        
        descriptionTextView!.layer.borderWidth = 1
        descriptionTextView!.layer.borderColor = UIColor.black.cgColor
        
//        let tapRecognizer = UITapGestureRecognizer()
//        tapRecognizer.addTarget(self, action: #selector(SignUpVC.didTapView))
//        self.view.addGestureRecognizer(tapRecognizer)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        descriptionTextView.delegate = self
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
    
    // MARK: UIDatePicker
    @IBOutlet weak var datePicker: UIDatePicker!
    var chosenDate = Date()
    var chosenDateString = ""
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        chosenDate = datePicker.date
//        print(chosenDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        chosenDateString = dateFormatter.string(from: chosenDate)
        print(chosenDateString)
        
    }
    
    // MARK: UITextView
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var tutorDescription = ""
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        // Hide the keyboard
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        if textView.text.length > 400 {
//            disable further typing
//        }
        tutorDescription = textView.text
        print(tutorDescription)
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
        
       cell.selectionStyle = .none
        
        func checkIfFree(blockString: String, blockVar: SpecificClass){
            
            cell.textLabel?.text = blockString
            cell.detailTextLabel?.text = blockVar.title
            
            if blockVar.title == "Free"{
                cell.textLabel?.textColor = UIColor.green
                cell.detailTextLabel?.textColor = UIColor.green
            }else{
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
    var selectedBlock = ""
    
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
    
    
    // MARK: - UIPickerView delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row{
        case 0: return "Appointment Slot 1"
        case 1: return "Appointment Slot 2"
        case 2: return "Appointment Slot 3"
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row{
        case 0: selectedAppointmentSlot = "Appointment Slot 1"
        case 1: selectedAppointmentSlot = "Appointment Slot 2"
        case 2: selectedAppointmentSlot = "Appointment Slot 3"
        default: break
        }
        print(selectedAppointmentSlot)
    }
    
    // MARK: - Navigation
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if (selectedClass.title != "none") && (selectedBlock != "") && (selectedClassTable.title != "") && (tutorDescription != ""){
            
            performSegue(withIdentifier: "signupToTutorSegue", sender: self)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please select a class and describe what you need help with.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signupToSubjectSegue"{
            let destination = segue.destination as! UINavigationController
            let nextViewController = destination.viewControllers[0] as! ChooseSubjectTableVC

            nextViewController.delegate = self
            
        }else if segue.identifier == "signupToTutorSegue"{
            let destination = segue.destination as! UINavigationController
            let nextViewController = destination.viewControllers[0] as! ChooseTutorCollectionVC
            
            let studentName = FIRAuth.auth()?.currentUser?.displayName
            
            print("class need help with is ", selectedClass.title!)
            print("appointment date is ", chosenDateString)
            print("appointment block is ", selectedBlock)
            print("studentname is ", studentName!)
            print("tutorname is ")
            print("tutordescription is ", tutorDescription)
            print("selectedappointmentslot is ", selectedAppointmentSlot)
            
            let appointmentRequest = Appointment(classTitle: selectedClass.title!, appointmentDate: chosenDateString, blockLetter: selectedBlock, studentName: studentName!, tutorName: "", appointmentDesc: tutorDescription)
            
            
            nextViewController.appointmentDetails = appointmentRequest
            nextViewController.selectedAppointmentSlot = selectedAppointmentSlot
            nextViewController.selectedSubject = selectedClass.subject!
            
        }
    }

}
