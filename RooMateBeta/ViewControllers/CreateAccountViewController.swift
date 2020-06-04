//
//  CreateAccountViewController.swift
//  RooMate
//
//  Created by Ron Hirsch on 28/04/2020.
//  Copyright © 2020 Ron Hirsch. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    let errorViewer: ErrorsViewController = ErrorsViewController()
    let imageUtils: ImageUtils = ImageUtils()
    let logger = Logger()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createAccountActivityIndicator.isHidden = true
        userNameTextFieldObject.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        failedCreateUserLabel.isHidden = true
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    private var accessToUsersDB: AccessDataBase = AccessDataBase()
    private var userName: String? = nil
    private var password: String? = nil
    private var repeatedPassword: String? = nil
    private var profileImageSelected = "NONE" // NONE is the default
    
    @IBOutlet weak var userNameTextFieldObject: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var userNameError: UIImageView!
    @IBOutlet weak var passwordError: UIImageView!
    @IBOutlet weak var repeatPasswordError: UIImageView!
    @IBOutlet weak var myUploadedImage: UIImageView!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var createAccountActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var failedCreateUserLabel: UILabel!
    
    
    var imagePicker: UIImagePickerController!
    
    @IBAction func takePhotoTapped(_ sender: UIButton)
    {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        imagePicker.dismiss(animated: true, completion: nil)
        myUploadedImage.image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
        let croppedImage = imageUtils.cropToBounds(image: myUploadedImage.image!, width: 128, height: 128)
        myUploadedImage.image = croppedImage
        myUploadedImage.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func userName(_ sender: UITextField?)
    {
        if sender != nil
        {
            let textString: String = (sender?.text!)!
            if textString != ""
            {
                userName = sender?.text!
                return
            }
        }
        userName = nil
    }
    
    
    @IBAction func password(_ sender: UITextField?)
    {
        if sender != nil
        {
            let textString: String = (sender?.text!)!
            if textString != ""
            {
                password = sender?.text!
                return
            }
        }
        password = nil
    }
    
    @IBAction func repeatPassword(_ sender: UITextField?)
    {
        if sender != nil
        {
            let textString: String = (sender?.text!)!
            if textString != ""
            {
                repeatedPassword = sender?.text!
                return
            }
        }
        repeatedPassword = nil
    }
    
    
    @IBAction func createNewAccount(_ sender: UIButton)
    {
        createAccountActivityIndicator.isHidden = false
        createAccountActivityIndicator.startAnimating()
        var isErrorOccured: Bool = false
        var errorMassage: String = "Missing: "
        if userName == nil
        {
            errorMassage += "User Name, "
            userNameError.isHidden = false
            isErrorOccured = true
        }
        else
        {
            userNameError.isHidden = true
        }
        
        if password == nil
        {
            errorMassage += "Password, "
            passwordError.isHidden = false
            isErrorOccured = true
        }
        else
        {
            passwordError.isHidden = true
        }
        
        if repeatedPassword == nil
        {
            errorMassage += "Repeat Password, "
            repeatPasswordError.isHidden = false
            isErrorOccured = true
        }
        else
        {
            repeatPasswordError.isHidden = true
        }
        
        if isErrorOccured == true
        {
            errorMassage.removeLast(2)
            let curAlert = errorViewer.showErrorView(errorMessage_: errorMassage)
            self.present(curAlert, animated: true, completion: nil)
            return
        }
        if password != repeatedPassword
        {
            let curAlert = errorViewer.showErrorView(errorMessage_: "passwords are not the same")
            self.present(curAlert, animated: true, completion: nil)
            print("password and repeat passwort are not the same")
            return
        }
        
        if myUploadedImage.image?.isSymbolImage == false // user uploaded an image
        {
            let userImageName = userName! + "ProfileImage"
            // imageUtils.saveImage(imageName: userImageName, image: myUploadedImage.image!, folderPath: "NONE") //pathToImagesFolder)
            profileImageSelected = userImageName
        }
        
        accessToUsersDB.fireBaseAddUser(userName: userName!, password: password!, profileImage: profileImageSelected, userImage: myUploadedImage.image, completionHandler: {[weak self]
            (userProfileImagePath, addUserSucceed) in
            guard let `self` = self else { return }
            if addUserSucceed == true
            {
                self.logger.debug(message: "created user successfully")
                self.performSegue(withIdentifier: "GoToMainPageFromNewAccount", sender: nil)
            }
            else
            {
                self.logger.debug(message: "failed to create a user")
                self.createAccountActivityIndicator.stopAnimating()
                self.createAccountActivityIndicator.isHidden = true
                self.failedCreateUserLabel.isHidden = false
            }
        })
    }
    
    
    @IBAction func uploadImageTapped(_ sender: UIButton)
    {
        let myPickedController: UIImagePickerController = UIImagePickerController()
        myPickedController.delegate = self
        myPickedController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(myPickedController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        myUploadedImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let croppedImage = imageUtils.cropToBounds(image: myUploadedImage.image!, width: 128, height: 128)
        myUploadedImage.image = croppedImage
        myUploadedImage.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage()
    {
        let imageData = myUploadedImage.image?.jpegData(compressionQuality: 1)
        if imageData == nil {return}
        self.uploadImageButton.isEnabled = false
    }

    /*func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        
    }*/
    
    // MARK: - UITextFieldDelegate functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        userNameTextFieldObject.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let newVc = segue.destination as? MainPageViewController
        {
            newVc.userNameString += userName!
            newVc.createAccountProfileImage = self.myUploadedImage.image
        }
    }
    

    
    

}
