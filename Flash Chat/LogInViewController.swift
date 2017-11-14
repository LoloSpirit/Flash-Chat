//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import FirebaseAuth
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    var util = Utilites()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        SVProgressHUD.show()
        emailTextfield.endEditing(true)
        emailTextfield.isEnabled = false
        passwordTextfield.endEditing(true)
        passwordTextfield.isEnabled = false
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if let err = error {
                print(err.localizedDescription)
                if err.localizedDescription.contains("password is invalid") || err.localizedDescription.contains("badly formatted") || err.localizedDescription.contains("no user record corresponding to this identifier") {
                    self.passwordTextfield.text = ""
                    SVProgressHUD.showError(withStatus: "Invalid password or email adress")
                    
                    self.emailTextfield.isEnabled = true
                    
                    self.passwordTextfield.isEnabled = true
                 
                }
            } else {
                print("LogIn Successful!")
                SVProgressHUD.dismiss()
                self.emailTextfield.isEnabled = true
                
                self.passwordTextfield.isEnabled = true
                self.performSegue(withIdentifier: "goToChat", sender: self)
                
            }
        
        }
    }
    


    
}  
