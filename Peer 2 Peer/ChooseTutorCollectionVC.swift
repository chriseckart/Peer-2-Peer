//
//  ChooseTutorCollectionVC.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 4/10/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

import UIKit
import Firebase

// this vc will have the faces of each tutor that they can choose, retrieve from google

class ChooseTutorCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var finishButton: UIBarButtonItem!
    
    var chosenTutor = ""
    var chosenTutorID = ""
    
    var tutorsLoaded = false
    
    var tutorNamesList: [String] = []
    var tutorImagesList: [UIImage] = []
    var tutorIDsList: [String] = []
    
    var selectedSubject = ""
    var appointmentDetails = Appointment(classTitle: "", appointmentDate: "", blockLetter: "", studentName: "", tutorName: "", appointmentDesc: "")
    var selectedAppointmentSlot = ""
    
    var noTutors = false
    
    override func viewWillAppear(_ animated: Bool) {
        var databaseRef: FIRDatabaseReference!
        databaseRef = FIRDatabase.database().reference()

        databaseRef.child("Curriculum").child(selectedSubject).child(appointmentDetails.classTitle!).child("availableTutors").child("blockLetter").child(appointmentDetails.blockLetter!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists(){
                print("dwakjndakndwdnjkkjajajnajnjdwnjawnjkndwankjdaw")
                for child in snapshot.children{

                    let snap = child as! FIRDataSnapshot
                    
                    let specificTutorName = snap.childSnapshot(forPath: "tutorName").value
                    let specificTutorID = snap.childSnapshot(forPath: "studentID").value
                    
                    self.tutorNamesList.append(specificTutorName as! String)
                    self.tutorIDsList.append(specificTutorID as! String)
                    print(self.tutorNamesList)
                    print(self.tutorIDsList)
                    
                    self.tutorsLoaded = true
                    
                    self.collectionView?.reloadData()
                    
                }
            }else{
                // no tutors
                self.tutorNamesList = ["No available tutors!"]
                self.tutorImagesList = [#imageLiteral(resourceName: "defprof")]
                self.noTutors = true
                
                self.tutorsLoaded = true
                
                self.collectionView?.reloadData()
            }
            
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TutorCVCell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDataSource
    
//    var tutorList = [Tutor]()
    // create tutor class with name and image? take from firebase like we do with the classes
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorNamesList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorCVCell", for: indexPath as IndexPath) as! TutorCVCell
        
        // gotta subtract 1 because when the firebase appends each tutor to the lists, it keeps the initial value
        if tutorsLoaded == false {
            cell.tutorLabel.text = ""
            cell.tutorPicture.image = #imageLiteral(resourceName: "defprof")
        }else{
            cell.tutorLabel.text = tutorNamesList[indexPath.row]
            cell.tutorPicture.image = #imageLiteral(resourceName: "defprof")
//            cell.tutorPicture.image = tutorImagesList[indexPath.row]
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch noTutors{
        case false: return CGSize(width: collectionView.frame.size.width/2.5, height: collectionView.frame.size.width/2.5)
        case true: return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if noTutors == false {
            chosenTutor = tutorNamesList[indexPath.row]
            chosenTutorID = tutorIDsList[indexPath.row]
            print(chosenTutor)
        }else{
            //self.make button invisible
        }
    }

    
    
    // MARK: - Navigation
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        if chosenTutor != "" && chosenTutor != "No available tutors!"{
            
            var databaseRef: FIRDatabaseReference!
            databaseRef = FIRDatabase.database().reference()
            
            //upload to student's firebase
            
            let refStudentAppointment = databaseRef.child("Users").child(FIRAuth.auth()!.currentUser!.uid).child("appointments").child("being tutored").child(selectedAppointmentSlot)
            
            refStudentAppointment.child("classTitle").setValue(appointmentDetails.classTitle)
            refStudentAppointment.child("appointmentDate").setValue(appointmentDetails.appointmentDate)
            refStudentAppointment.child("blockLetter").setValue(appointmentDetails.blockLetter)
            refStudentAppointment.child("studentName").setValue(appointmentDetails.studentName)
            refStudentAppointment.child("tutorName").setValue(chosenTutor)
            refStudentAppointment.child("appointmentDesc").setValue(appointmentDetails.appointmentDesc)
            
            
            //upload to tutor's firebase (this right now just overrides the tutor's appointments, regardless of whether or not they wanted to accept it, but that can be changed in v2
            let refTutorAppointment = databaseRef.child("Users").child(chosenTutorID).child("appointments").child("tutoring").child(selectedAppointmentSlot)
            
            refTutorAppointment.child("classTitle").setValue(appointmentDetails.classTitle)
            refTutorAppointment.child("appointmentDate").setValue(appointmentDetails.appointmentDate)
            refTutorAppointment.child("blockLetter").setValue(appointmentDetails.blockLetter)
            refTutorAppointment.child("studentName").setValue(appointmentDetails.studentName)
            refTutorAppointment.child("tutorName").setValue(chosenTutor)
            refTutorAppointment.child("appointmentDesc").setValue(appointmentDetails.appointmentDesc)
            
            self.performSegue(withIdentifier: "signupToFinishSegue", sender: self)

        }else{
            let alert = UIAlertController(title: "Error", message: "Please select a tutor.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signupToFinishSegue"{
            let destination = segue.destination as! ThankYouTutorVC
            
            destination.thanksText = "Great! Appointment made."
            destination.chosenClassText = appointmentDetails.classTitle!
            destination.blockLetterText = appointmentDetails.blockLetter!
            destination.appointmentDateText = appointmentDetails.appointmentDate!
            destination.appointmentDescText = appointmentDetails.appointmentDesc!
            destination.tutorNameText = appointmentDetails.tutorName!
            
            destination.appointmentDateTitleText = "Appointment Date"
            destination.appointmentDescTitleText = "Appointment Description"
            destination.tutorNameTitleText = "Tutor Name"
            
            // UPLOAD APPOINTMENT TO FIREBASE
            
        }
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
    
}
