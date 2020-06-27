//
//  UsersTableViewCell.swift
//  RooMateBeta
//
//  Created by Ron Hirsch on 08/06/2020.
//  Copyright © 2020 Ron Hirsch. All rights reserved.
//

import Foundation
import UIKit

class UsersTableViewCell: UITableViewCell {

    var userNameString: String?
    
    var userNameView: UITextView = {
        var userNameTextView = UITextView()
        userNameTextView.translatesAutoresizingMaskIntoConstraints = false
        userNameTextView.isScrollEnabled = false // this will cause the cell to be bigger in order to present all the text content
        return userNameTextView
    }()
    
    var userProfilePicture: UIImage?
    
    var userProfileImageView: UIImageView = {
       var userProfileImageView = UIImageView()
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        return userProfileImageView
    }()
    
    var userNameTextView = UITextView()
    
    // init(userName: String)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(userProfileImageView)
        self.addSubview(userNameView)
        
        userProfileImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        userProfileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        userNameView.leftAnchor.constraint(equalTo: self.userProfileImageView.rightAnchor).isActive = true
        userNameView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        userNameView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        userNameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let userNameString = userNameString
        {
            userNameView.text = userNameString
        }
        if let userProfilePicture = userProfilePicture
        {
            userProfileImageView.image = userProfilePicture
        }
    }
}
