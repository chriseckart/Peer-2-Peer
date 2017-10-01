//
//  Appointment.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 4/17/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

import Foundation
import Firebase

class Appointment {
    var classTitle: String?
    var appointmentDate: String?
    var blockLetter: String?
    var studentName: String?
    var tutorName: String?
    var appointmentDesc: String?
    
    let ref: FIRDatabaseReference?
    
    init(classTitle: String, appointmentDate: String, blockLetter: String, studentName: String, tutorName: String, appointmentDesc: String) {
        self.classTitle = classTitle
        self.appointmentDate = appointmentDate
        self.blockLetter = blockLetter
        self.studentName = studentName
        self.tutorName = tutorName
        self.appointmentDesc = appointmentDesc
        
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        classTitle = (snapshot.value! as AnyObject)["classTitle"] as? String
        blockLetter = (snapshot.value! as AnyObject)["blockLetter"] as? String
        appointmentDate = (snapshot.value! as AnyObject)["appointmentDate"] as? String
        studentName = (snapshot.value! as AnyObject)["studentName"] as? String
        tutorName = (snapshot.value! as AnyObject)["tutorName"] as? String
        appointmentDesc = (snapshot.value! as AnyObject)["appointmentDesc"] as? String
        
        ref = snapshot.ref
    }
}
