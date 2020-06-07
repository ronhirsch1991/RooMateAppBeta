//
//  MainPageViewController.swift
//  RooMate
//
//  Created by Ron Hirsch on 28/04/2020.
//  Copyright © 2020 Ron Hirsch. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController
{
    
    @IBOutlet weak var helloUserName: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet var allMainOptions: [UIButton]!
    @IBOutlet weak var imageProfileActivityIndicator: UIActivityIndicatorView!
    
    private var helloName = "Hello "
    private var imageUtils: ImageUtils = ImageUtils()
    private var accessToUsersDB: AccessDataBase = AccessDataBase()
    public var userNameString = ""
    public var userProfilePicturePath: String? = ""
    public var createAccountProfileImage: UIImage? = nil
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        helloUserName.text = helloName + userNameString
        imageProfileActivityIndicator.isHidden = true
        if createAccountProfileImage != nil
        {
            userProfileImage.image = createAccountProfileImage
        }
        else
        {
            /*accessToUsersDB.downloadPhoto(withUserName: userNameString, andProfileImagePath: userProfilePicturePath, completionHandler: {[weak self]
                (imageResource) in
                guard let `self` = self else { return }
                self.setProfileImage(resource: imageResource!)
            })*/
            setProfileImage(resource: userProfilePicturePath!)
        }
    }
    
    /*func loadProfileImage()
    {
        let imageName = "NONE" // accessToUsersDB.getProfileImageName(userName: useNameString)
        if(imageName == nil || imageName == "NONE")
        {
            print("Error!! couldn't get the image of the user")
            let anonimusImage = UIImage(named: "Anonimus")
            let croppedImage = imageUtils.cropToBounds(image: anonimusImage!, width: 64, height: 64)
            userProfileImage.image = croppedImage
            return
        }
        let userProfileImagePath = Bundle.main.path(forResource: imageName, ofType: "jpeg")
        let loadedProfileImage = UIImage(contentsOfFile: userProfileImagePath!)
        let croppedImage = imageUtils.cropToBounds(image: loadedProfileImage!, width: 64, height: 64)
        userProfileImage.image = croppedImage
    }*/
    
    func setProfileImage(resource: String)
    {
        let url = URL(string: resource)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        userProfileImage.image = UIImage(data: data!)
        
        print("setImage")
    }
    
    
    @IBAction func optionsPressed(_ sender: UIButton)
    {
        allMainOptions.forEach { button in
            button.isHidden = !button.isHidden
        }
    }
    
    
    @IBAction func settinsTapped(_ sender: UIButton)
    {
        
    }
    
    @IBAction func myAccountTapped(_ sender: UIButton)
    {
        
    }
    
    @IBAction func privacyTapped(_ sender: UIButton)
    {
        
    }
    
    @IBAction func logOfTapped(_ sender: UIButton)
    {
        
    }
    
    
    @IBAction func exitTapped(_ sender: UIButton)
    {
        exit(0)
    }
    
    @IBAction func messagesTapped(_ sender: Any)
    {
        self.performSegue(withIdentifier: "goToMessages", sender: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let newVc = segue.destination as? MessagesViewController
        {
            newVc.userNameString += userNameString
        }
    }

}
