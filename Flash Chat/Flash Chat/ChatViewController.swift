//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var msgArray : [Message] = [Message]()
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet weak var ss: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
        
        messageTableView.delegate = self
        messageTableView.dataSource = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
        
        messageTableView.separatorStyle = .none
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.senderUsername.text = msgArray[indexPath.row].sender
        cell.messageBody.text = msgArray[indexPath.row].body
        cell.imageView?.image = UIImage(named: "egg")
        if(Auth.auth().currentUser?.email == msgArray[indexPath.row].sender) {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        return cell
    }
    
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    // When the user pressed the field we expand the high to prevent the text field to be convered by the keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
  
    // When the user finish typing we restore the original size
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    ///////////////////////////////////////////
    
    //MARK: - Send & Recieve from Firebase
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        let msgDB = Database.database().reference().child("Messages")
        let msg = ["Sender": Auth.auth().currentUser?.email, "Body": messageTextField.text!]
        msgDB.childByAutoId().setValue(msg) { (error, reference) in
            if(error != nil) {
                print(error!.localizedDescription)
            } else {
                self.messageTextField.text = ""
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
            }
        }
    }
    
    func retrieveMessages() {
        let msgDB = Database.database().reference().child("Messages")
        msgDB.observe(.childAdded) { snapshot in
            let snapshotVal = snapshot.value as! Dictionary<String, String>
            let msg = Message()
            msg.sender = snapshotVal["Sender"]!
            msg.body = snapshotVal["Body"]!
            self.msgArray.append(msg)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error logging out!")
        }
    }
}
