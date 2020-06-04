//
//  SigninViewController.swift
//  RooMate
//
//  Created by Ron Hirsch on 24/04/2020.
//  Copyright © 2020 Ron Hirsch. All rights reserved.
//

import UIKit
import SQLite3
import Kingfisher

class SigninViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate
{
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Signin storyboard")
        
        userNameTextField.delegate = self // for making the keyboard disapear
        passwordTextField.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        self.authenticationUIActivityIndicatorView.isHidden = true
        
    }
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authenticationUIActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var display: UILabel?
    
    private var signInAuthentication: Bool = false
    private var accessToUsersDB: AccessDataBase = AccessDataBase()
    private var currentUserName: String? = nil
    private var currentPassword: String? = nil
    private var userProfileImage: String? = nil
    
    @IBAction func userNameEdited(_ sender: UITextField?)
    {
        if sender != nil
        {
            let textString: String = (sender?.text!)!
            if textString != ""
            {
                currentUserName = sender?.text!
                return
            }
        }
        currentUserName = nil
    }
    
    
    @IBAction func passwordTextFieldEdited(_ sender: UITextField?)
    {
        if sender != nil
        {
            let textString: String = (sender?.text!)!
            if textString != ""
            {
                currentPassword = sender?.text!
                return
            }
        }
        currentPassword = nil
    }
    
    @IBAction func enter(_ sender: UIButton)
    {
        if currentUserName != nil && currentPassword != nil
        {
            self.authenticationUIActivityIndicatorView.isHidden = false
            self.authenticationUIActivityIndicatorView.startAnimating()
            
            
            accessToUsersDB.userAuthentication(userName: currentUserName!, password: currentPassword!, completionHandler: {[weak self]
                (userProfileImagePath, authenticationsStatus) in
                guard let `self` = self else { return }
                if authenticationsStatus == true
                {
                    self.userProfileImage = userProfileImagePath
                    self.authenticationPassed()
                }
                else
                {
                    self.authenticationFailed()
                }
            })
        }
        else
        {
            display?.isHidden = false
            display?.text = "please write user name and password"
        }
    }
    
    func authenticationFailed()
    {
        display?.isHidden = false
        display?.text = "wrong user name or password"
        self.authenticationUIActivityIndicatorView.stopAnimating()
        self.authenticationUIActivityIndicatorView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destinationViewController = segue.destination as? MainPageViewController
        {
            destinationViewController.userNameString = currentUserName!
            destinationViewController.userProfilePicturePath = self.userProfileImage
        }
    }
    
    // MARK: - UITextFieldDelegate functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    func authenticationPassed()
    {
        performSegue(withIdentifier: "GoToMainPage", sender: nil)
        self.authenticationUIActivityIndicatorView.stopAnimating()
        self.authenticationUIActivityIndicatorView.isHidden = true
    }

}


