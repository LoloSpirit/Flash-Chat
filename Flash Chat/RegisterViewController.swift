//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class RegisterViewController: UIViewController {

    let util = Utilites()
    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        emailTextfield.endEditing(true)
        emailTextfield.isEnabled = false
        passwordTextfield.endEditing(true)
        passwordTextfield.isEnabled = false
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if let err = error {
                print(err.localizedDescription)
                if err.localizedDescription.contains("email") && (err.localizedDescription.contains("badly formatted") || err.localizedDescription.contains("already in use")) {
                    
                    SVProgressHUD.showError(withStatus: "This email adress is invalid or has already been taken")
                    self.emailTextfield.text = ""
                    
                    self.emailTextfield.isEnabled = true
                    
                    self.passwordTextfield.isEnabled = true
                    
                }
                if err.localizedDescription.contains("password") && err.localizedDescription.contains("characters long or more") {
                    
                    SVProgressHUD.showError(withStatus: "Your password must be at least 6 characters long")
                    self.passwordTextfield.text = ""
                    
                    self.emailTextfield.isEnabled = true
                    
                    self.passwordTextfield.isEnabled = true
                    
                }
            } else {
                SVProgressHUD.dismiss()
                print("Registration Successful!")
                self.emailTextfield.isEnabled = true
                
                self.passwordTextfield.isEnabled = true
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }

        
        
    }

    
    
}
