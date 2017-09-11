//
//  ClassList.swift
//  Peer 2 Peer
//
//  Created by Christopher Eckart on 4/8/17.
//  Copyright © 2017 Christopher Eckart. All rights reserved.
//

import Firebase

class SpecificClass: AnyObject{
    var title: String?
    var teacher: String?
    var roomnumber: String?
    var prerequisites: String?
    var description: String?
    var subject: String?
    
    let ref: FIRDatabaseReference?
    
    // title: "Honors Pre Calculus"
    // subtitle: "Mrs. Garcia"
    // description: "this class is designed for blah blach lfandjwkmd"
    
    init(title: String, teacher: String, roomnumber: String, prerequisites: String, description: String, subject: String) {
        self.title = title
        self.teacher = teacher
        self.roomnumber = roomnumber
        self.prerequisites = prerequisites
        self.description = description
        self.subject = subject
        
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        title = (snapshot.value! as AnyObject)["title"] as? String
        teacher = (snapshot.value! as AnyObject)["teacher"] as? String
        roomnumber = (snapshot.value! as AnyObject)["roomnumber"] as? String
        prerequisites = (snapshot.value! as AnyObject)["prerequisites"] as? String
        description = (snapshot.value! as AnyObject)["description"] as? String
        subject = (snapshot.value! as AnyObject)["subject"] as? String
        
        ref = snapshot.ref
        
    }
}


// working copy un factored
//for child in snapshot.children {
//    let MathClass = SpecificClass(snapshot:child as! FIRDataSnapshot)
//    
//    print(MathClass.title)
//    print(MathClass.teacher)
//    print(MathClass.roomnumber)
//    print(MathClass.prerequisites)
//    print(MathClass.description)
//    
//    MathematicsClasses1.append(MathClass)
//}
//print("the math classes are as follows:", MathematicsClasses1)
//TargetDestination.classList = MathematicsClasses1
//TargetDestination.tableView.reloadData()
////pull data from, put SpecificClass objects into array
