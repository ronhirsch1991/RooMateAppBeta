//
//  Users.swift
//  RooMateBeta
//
//  Created by Ron Hirsch on 08/06/2020.
//  Copyright © 2020 Ron Hirsch. All rights reserved.
//

import Foundation

class User
{
    private var userName: String
    private var profileImage: String
    
    init(userName_: String, userProfileImage: String)
    {
        userName = userName_
        profileImage = userProfileImage
    }
    
    func getUserName() -> String
    {
        return userName
    }
}
