//
//  ViewController.swift
//  RooMate
//
//  Created by Ron Hirsch on 24/04/2020.
//  Copyright © 2020 Ron Hirsch. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController
{
    // MARK: Model
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("HomePage")
    }

    
    // MARK: View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let idenfitier = segue.identifier // wants to check the the identifier isn't nil
        {
            if idenfitier == "GoToSignin"
            {
                print ("GoToSignin")
            }
            else
            {
                print("GoToSignin segue didn't work")
            }
        }
    }
    
    
    
    
}

