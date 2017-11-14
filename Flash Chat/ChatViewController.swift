//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    var keyboard: CGFloat = 0 {
        didSet {
            animateTextfield()
        }
    }
    var messages: [Message] = [Message]()
    var messagesDB: DatabaseReference = Firebase.Database.database().reference().child("Messages")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        configureTableView()
        retriveMessages()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        messagesDB = Firebase.Database.database().reference().child("Messages")
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        messageTableView.separatorStyle = .none
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messages[indexPath.row].messageBody
        cell.senderUsername.text = messages[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if messages[indexPath.row].sender != Firebase.Auth.auth().currentUser?.email {
            cell.messageBackground.backgroundColor = UIColor.gray
        }
        
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped () {
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView () {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.heightConstraint.constant = 50 + self.keyboard
            self.view.layoutIfNeeded()
        
        })
    }
    
    func animateTextfield () {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            
            self.heightConstraint.constant = 50 + self.keyboard
            self.view.layoutIfNeeded()
            
        })
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        keyboard = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        
        //TODO: Send the message to Firebase and save it in our database
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let message = ["Sender": Firebase.Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text]
        
        messageTextfield.text = ""
        
        messagesDB.childByAutoId().setValue(message) {
            (error, reference) in
            if let err = error {
                print("error: " + err.localizedDescription)
            } else {
                print("Message saved")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
            }
        }
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retriveMessages () {
        
        messagesDB.observe(.childAdded) { (snapshot) in
            if let message = snapshot.value as? [String: String] {
                let newMessage = Message()
                newMessage.messageBody = message["MessageBody"]!
                newMessage.sender = message["Sender"]!
         
                self.messages.append(newMessage)
                
                self.configureTableView()
                self.messageTableView.reloadData()
            }
        }
    }

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        do {
            try Firebase.Auth.auth().signOut()
        } catch let error {
            print("Error signing out: \(error)")
        }
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("no vcs to pop off")
                return
        }
        
    }
    


}
