//
//  AccessDB.swift
//  RooMate
//
//  Created by Ron Hirsch on 28/04/2020.
//  Copyright © 2020 Ron Hirsch. All rights reserved.
//

import Foundation
import SQLite3
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseDatabase
import Kingfisher
import FirebaseStorage

let NO_ERROR            =   0
let USER_NAME_EXISTS    =   (-1)
let COULDNT_OPEN_DB     =   (-2)
let UNEXPECTED_ERROR    =   (-3)
let ERROR               =   "ERROR"

class AccessDataBase
{
    var fireBaseDB: Firestore!
    var fireBaseRef: DatabaseReference!
    let logger = Logger()
    
    init()
    {
        // Google FireBase
        Firestore.firestore().settings = FirestoreSettings()
        fireBaseDB = Firestore.firestore()
        fireBaseRef = Database.database().reference()
    }
    
    /*private func openDatabase() -> OpaquePointer?
    {
        var db: OpaquePointer?
        if sqlite3_open(self.dbPath!, &db) == SQLITE_OK
        {
            return db
        }
        print("couldn't open db")
        return nil
    }*/
    
    /*private func isUserNameExist (userName: String) -> Bool
    {
        let db = openDatabase()
        if db != nil
        {
            var queryStatement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, "SELECT * FROM Users WHERE UserName='\(userName)'", -1, &queryStatement, nil) == SQLITE_OK
            {
                if sqlite3_step(queryStatement) == SQLITE_ROW
                {
                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db);
                    return true
                }
            }
            sqlite3_finalize(queryStatement)
            sqlite3_close(db);
            return false
        }
        print("couldnt open DB")
        return false
    }*/
    
    /*public func checkUserName (userName: String, password: String) -> Bool?
    {
        if let db = openDatabase()
        {
            var queryStatement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, "SELECT * FROM Users WHERE UserName='\(userName)'", -1, &queryStatement, nil) == SQLITE_OK
            {
                if sqlite3_step(queryStatement) == SQLITE_ROW
                {
                    guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                    else
                    {
                        print("Query result is nil")
                        return nil
                    }
                    let correctPass = String(cString: queryResultCol1)
                    print("correctPass = \(correctPass)")
                    if(correctPass == password)
                    {
                        return true // matching passwords
                    }
                }
                else
                {
                    print("\nQuery returned no results.")
                    return nil
                }
            }
            else
            {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nQuery is not prepared \(errorMessage)")
                return nil
            }
            sqlite3_finalize(queryStatement)
        }
        return nil
    }*/
    
    /*public func getProfileImageName (userName: String) -> String?
    {
        if let db = openDatabase()
        {
            var queryStatement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, "SELECT * FROM Users WHERE UserName='\(userName)'", -1, &queryStatement, nil) == SQLITE_OK
            {
                if sqlite3_step(queryStatement) == SQLITE_ROW
                {
                    guard let queryResultCol1 = sqlite3_column_text(queryStatement, 2) // image path
                    else
                    {
                        print("Query result is nil")
                        return nil
                    }
                    let imageName = String(cString: queryResultCol1)
                    print("correctPass = \(imageName)")
                    sqlite3_finalize(queryStatement)
                    return imageName
                }
                else
                {
                    print("Query returned no results.\n")
                    sqlite3_finalize(queryStatement)
                    return nil
                }
            }
            else
            {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nQuery is not prepared \(errorMessage)")
                sqlite3_finalize(queryStatement)
                return nil
            }
        }
        return nil
    }*/
    
    /*public func addUser(userName: String, password: String, profPicSTR: String) -> Int
    {
        if isUserNameExist(userName: userName) == true
        {
            return USER_NAME_EXISTS
        }
        
        if let db = openDatabase()
        {
            
            var insertStatement: OpaquePointer?
            let insertstatment = "INSERT INTO Users (UserName, Password, ProfileImagePath) VALUES (?, ?, ?) "
            if sqlite3_prepare_v2(db, insertstatment, -1, &insertStatement, nil) == SQLITE_OK
            {
                let b1 = sqlite3_bind_text(insertStatement, 1, userName, -1, nil)
                let b2 = sqlite3_bind_text(insertStatement, 2, password, -1, nil)
                let b3 = sqlite3_bind_text(insertStatement, 3, profPicSTR, -1, nil)
                
                let res = sqlite3_step(insertStatement)
                if  res == SQLITE_DONE
                {
                    sqlite3_finalize(insertStatement)
                    sqlite3_close(db)
                    return 0 // success!
                }
                else
                {
                    let errMsg = sqlite3_errmsg(insertStatement)
                    print("Could not insert row \(String(describing: errMsg))")
                }
            }
            else
            {
                print("INSERT statement is not prepared.\n")
            }
            sqlite3_finalize(insertStatement)
            sqlite3_close(db)
            return UNEXPECTED_ERROR
        }
        print("couldn't open the DB")
        return COULDNT_OPEN_DB
    }*/
    
    func downloadPhoto()
    {
        guard let uid = UserDefaults.standard.value(forKey: "ID") else {
            print("ERROR line 195")
            return
        }
        
        if let stam = uid as? String
        {
            print (stam)
        }
        
        let query = Firestore.firestore().collection("images").whereField("ID", isEqualTo: "KDOdc2VsDUNN9Ei3n7eZ")
        
        
        query.getDocuments(completion: { (snapshot, error) in
                if let error = error
                {
                    print("ERROR")
                    return
                }
                guard let snapshot = snapshot else{
                    print("error")
                    return
                }
            
            let data = snapshot.documents.first?.data()
            if let urlString = data?["iMAGE_url"] as? String
            {
                let url = URL(fileURLWithPath: urlString)
                let resource = ImageResource(downloadURL: url)
                print("success!!!")
            }
            
        })
    }
    
    func uploadImage(imgName: String, myImage: UIImage?, completionHandler:@escaping(_ urlString: String?) -> Void)
    {
        var urlString = ERROR
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async{
        
        
            guard let image = myImage, let data = image.jpegData(compressionQuality: 1.0) else{
                self.logger.error(message: "couldn't get data from myImage")
                completionHandler(urlString)
                return
            }
            let imageName = "\(imgName).jpeg"
            
            let imageReference = Storage.storage().reference().child("images").child(imageName)
            
            imageReference.putData(data, metadata: nil){ (metadata, error) in
                if let error = error
                {
                    self.logger.error(message: "something went wrong with uploading the image \(error)")
                    completionHandler(urlString)
                }
                imageReference.downloadURL(completion: {(url, error) in
                    if let error = error
                    {
                        self.logger.error(message: "something went wrong with uploading the image \(error)")
                        completionHandler(urlString)
                        return
                    }
                    guard let url = url else {
                        self.logger.error(message: "something went wrong with the url")
                        completionHandler(urlString)
                        return
                    }
                    /*
                     saving a ref also in the DB
                     can be removed.
                     */
                    let dataReference = Firestore.firestore().collection("images").document()
                    let documentID = dataReference.documentID
                    urlString = url.absoluteString
                    let data = [
                        "ID": documentID,
                        "ImageURL": urlString
                    ]
                    
                    dataReference.setData(data, completion: {
                        (error) in
                        if let error = error
                        {
                            self.logger.error(message: "something went wrong with saving image path to images DB \(error)")
                            completionHandler(urlString)
                        }
                        
                        //UserDefaults.standard.set(documentID, forKey: "ID") // the app can remember the last activity she did. can be ignore for now.
                        self.logger.debug(message: "uploaded image successfully")
                        completionHandler(urlString)
                        
                    })
                })
            }
        }
    }
    
    func dummy()
    {
        // var ref = Database.database().reference()
        var curRef: DocumentReference? = nil
        
        
        fireBaseDB.collection("Users").document("adi2").setData(
            [
                "UserName": "adi",
                "Password": "123",
                "ProfilePicture": "NONE"
            ]) { (err) in
            if let err = err {
                print("Error adding document: \(err)")
                self.logger.error(message: "Error adding document: \(err)")
            } else {
                // let id = curRef!.documentID
                // print(id) //now you can work with the ride and know it's ID
                self.logger.debug(message: "seccuess")
            }
        }
    }
    
    func isUserNameAlreadyExists (userName: String, isUserExistCompletionHandler:@escaping (_ isUserExist: Bool) -> Void)
    {
        var res = false
        let curRef = fireBaseDB.collection("Users").document(userName)
        
        curRef.getDocument { (document, error) in
            if let document = document, document.exists
            {
                res = true // user is already exists
                isUserExistCompletionHandler(true)
            }
            else{
                isUserExistCompletionHandler(false)
            }
        }
        
    }
    
    func fireBaseAddUser(userName: String, password: String, profileImage: String, userImage: UIImage?, completionHandler:@escaping (_ userProfileImagePath: String?, _ addUserSucceed: Bool)-> Void)
    {
        isUserNameAlreadyExists(userName: userName, isUserExistCompletionHandler: {[weak self]
            (isUserExist) in
            guard let `self` = self else { return }
            if isUserExist == true
            {
                completionHandler("user already exists", false)
            }
            else
            {
                if profileImage != "NONE"
                {
                    self.uploadImage(imgName: profileImage, myImage: userImage, completionHandler: {[weak self]
                        (urlString) in
                        guard let `self` = self else { return }
                        if urlString == ERROR
                        {
                            completionHandler(urlString, false)
                        }
                        else
                        {
                            var curRef: DocumentReference? = nil
                            
                            
                            self.fireBaseDB.collection("Users").document(userName).setData(
                                [
                                    "UserName": userName,
                                    "Password": password,
                                    "ProfilePicture": urlString
                                ]) { (err) in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                    self.logger.error(message: "Error adding document: \(err)")
                                } else {
                                    // let id = curRef!.documentID
                                    // print(id) //now you can work with the ride and know it's ID
                                    self.logger.debug(message: "seccuess")
                                    completionHandler(urlString, true)
                                }
                            }
                        }
                    })
                }
            }
        })
    }
    
    /*public func readFromFirebase()
    {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let username = value?["username"] as? String ?? ""
          let user = User(username: username)

          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
    }*/
    
    func userAuthentication(userName: String, password: String, completionHandler:@escaping (_ userProfileImagePath: String?, _ authenticationsStatus: Bool)-> Void)
    {
        var curRef: DocumentReference? = nil
        curRef = self.fireBaseDB.collection("Users").document(userName)
        curRef!.getDocument { (document, error) in
            if let document = document, document.exists
            {
                if let tmp = document.data() as NSDictionary?
                {
                    if let correctPassword = tmp.object(forKey: "Password") as? String
                    {
                        if correctPassword == password
                        {
                            self.logger.debug(message: "authentication successed")
                            if let profileImagePath = tmp.object(forKey: "ProfilePicture") as? String
                            {
                                self.logger.debug(message: "sent profileImagePath")
                                completionHandler(profileImagePath, true)
                            }
                            else
                            {
                                self.logger.error(message: "couldn't get the profileImagePath")
                                completionHandler("", false)
                            }
                        }
                        else
                        {
                            self.logger.debug(message: "authentication failed")
                            completionHandler("", false)
                        }
                    }
                }
                else
                {
                    self.logger.error(message: "couldn't access to DB")
                    completionHandler("", false)
                }
            }
            else
            {
                self.logger.debug(message: "user doesn't exists")
                completionHandler("", false)
            }
        }
    }
    
    
    
    func loadData()
    {
        var curRef: DocumentReference? = nil
        curRef = fireBaseDB.collection("Users").document("cooper")
        
        curRef!.getDocument { (document, error) in
            if let document = document, document.exists
            {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            }
            else
            {
                print("Document does not exist")
            }
        }
    }
    
    
    func downloadPhoto(withUserName: String, andProfileImagePath: String?, completionHandler:@escaping (_ imageResource: String?)-> Void)
    {
        let query = Firestore.firestore().collection("images").whereField("ID", isEqualTo: withUserName)
        
        query.getDocuments(completion: { (snapshot, error) in
                if let error = error
                {
                    self.logger.error(message: "query had issue \(error)")
                    return
                }
                guard let snapshot = snapshot else{
                    self.logger.error(message: "query had issue")
                    return
                }
            
            let data = snapshot.documents.first?.data()
            if let urlString = data?["ImageURL"] as? String
            {
                // let url = URL(fileURLWithPath: urlString)
                // let resource = ImageResource(downloadURL: url) // for Kingfisher
                self.logger.debug(message: "reciverd url path succesfully")
                completionHandler(urlString)
            }
            
        })
    }
    
}

