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
    @IBOutlet weak var usersTableView: UITableView!
    
    var userNameString = ""
    let fireBaseMessages = FireBaseMessages()
    let userA = User(userName_: "test1", userProfileImage: "NONE")
    let userB = User(userName_: "test2", userProfileImage: "NONE")
    var users = ["userA", "userB"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "test"
        // loadContactUsers()
        userNameLabel.text = userNameString
        usersTableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    @IBAction func sendTapped(_ sender: Any)
    {
        fireBaseMessages.a(txt: messageTextField.text!)
    }
    
    /*func loadContactUsers()
    {
        let userA = User(userName_: "test1", userProfileImage: "NONE")
        let userB = User(userName_: "test2", userProfileImage: "NONE")
        users = [userA, userB]
        let indexPath = IndexPath(row: users.count-1, section: 0)
        usersTableView.beginUpdates()
        usersTableView.insertRows(at: [indexPath], with: .automatic)
        usersTableView.endUpdates()
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MessagesViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // let userName = users[indexPath.row].getUserName()
        /* let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as! UITableViewCell
        cell.largeContentTitle = users[indexPath.row]
        cell.detailTextLabel?.text = users[indexPath.row]
        return cell */
        return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
    }
}
