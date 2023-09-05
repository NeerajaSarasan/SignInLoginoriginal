//
//  RegisterViewController.swift
//  SignInLogin
//
//  Created by Neeraja Sarasan on 28/08/23.
//

import UIKit
import Firebase
import SVProgressHUD
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var InvalidUser: UILabel!
    
    @IBOutlet weak var InvalidPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func didpressRegister(_ sender: UIButton) {
        SVProgressHUD.show()
        if let  emailAddress = userName.text, !emailAddress.isEmpty {
            if isValidEmail(emailAddress) {
                InvalidUser.text = ""
            } else {
                InvalidUser.text = "Invalid email address"
            }
        }
        else
        {
            InvalidUser.text = "email field cannot be empty"
        }
        if let passwords = password.text, !passwords.isEmpty{
            if isValidPassword(passwords) {
                InvalidPassword.text = ""
            } else {
                InvalidPassword.text = "At least 8 characters in length.At least one uppercase or lowercase letter.At least one digit.At least one special character"
            }
        }
        else
        {
            InvalidPassword.text = "Password field cannot be empty"
        }
        
        
        guard let emails = userName.text else { return }
        guard let pass = password.text else{ return }
        
        Auth.auth().createUser(withEmail: emails, password: pass) { authResult, error in
            SVProgressHUD.dismiss()
            if let error = error {
                print(error)
            } else {
                let alert = UIAlertController(title: "Signup", message: "You are successfully registered", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.performSegue(withIdentifier: "goToLogin", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
               
                
            }
        }
        
    }
    
    
    
}

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
}
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
}








