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
    
    @IBAction func didpressRegister(_ sender: UIButton) {
        SVProgressHUD.show()
        let emailValid = validateEmail()
        let passwordValid = validatePassword()
        guard emailValid, passwordValid else {
            SVProgressHUD.dismiss()
            return
        }
        
        Auth.auth().createUser(withEmail: userName.text!, password: password.text!) { [weak self] authResult, error in
            SVProgressHUD.dismiss()
            if let error = error {
                print(error)
            } else {
                self?.showAlert(title: "Signup", message: "You are successfully registered", actionHandler: { _ in
                    self?.performSegue(withIdentifier: "goToLogin", sender: self)
                })
            }
        }
    }
    
    private func validateEmail() -> Bool {
        if let emailAddress = userName.text, !emailAddress.isEmpty && emailAddress.isValidEmail() {
            InvalidUser.text = ""
            return true
        } else {
            InvalidUser.text = "Invalid email address"
            return false
        }
    }
    
    private func validatePassword() -> Bool {
        if let passwords = password.text, !passwords.isEmpty && passwords.isValidPassword() {
            InvalidPassword.text = ""
            return true
        } else {
            InvalidPassword.text = "At least 8 characters in length. At least one uppercase or lowercase letter. At least one digit. At least one special character"
            return false
        }
    }
    
    private func showAlert(title: String, message: String, actionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: actionHandler))
        present(alert, animated: true, completion: nil)
    }
}
