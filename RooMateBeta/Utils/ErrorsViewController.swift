//
//  ErrorsViewController.swift
//  RooMate
//
//  Created by Ron Hirsch on 28/04/2020.
//  Copyright © 2020 Ron Hirsch. All rights reserved.
//

import UIKit

class ErrorsViewController
{
    public func showAlertView(title: String, message: String, buttonName: String)
    {
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButton(withTitle: buttonName)
        alert.show()
    }
    
    func showErrorView(errorMessage_: String) -> UIAlertController
    {
        let alert = UIAlertController(title: "ERROR", message: errorMessage_, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        return alert
    }
    
    func showMessageView(message_: String) -> UIAlertController
    {
        let alert = UIAlertController(title: "Message", message: message_, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        return alert
    }
}
