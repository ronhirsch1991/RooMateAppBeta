//
//  FirebaseMessages.swift
//  RooMateBeta
//
//  Created by Ron Hirsch on 07/06/2020.
//  Copyright © 2020 Ron Hirsch. All rights reserved.
//

import Foundation
import Firebase

class FireBaseMessages
{
    let logger = Logger()
    var messagesRef: DatabaseReference!
    
    init()
    {
        messagesRef = Database.database().reference().child("messages")
    }
    
    func a(txt: String)
    {
        let childRef = messagesRef.childByAutoId()
        let values = ["text": txt, "to": "test1"]
        childRef.updateChildValues(values)
    }
}
