//
//  MessagesViewController.swift
//  RooMateBeta
//
//  Created by Ron Hirsch on 07/06/2020.
//  Copyright © 2020 Ron Hirsch. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var userNameString = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        userNameLabel.text = userNameString
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
