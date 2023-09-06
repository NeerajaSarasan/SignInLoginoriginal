//
//  LoginViewController.swift
//  SignInLogin
//
//  Created by Neeraja Sarasan on 28/08/23.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func didPressLogin(_ sender: UIButton) {
        guard let emailText = email.text, let passwordText = password.text else {
            return
        }
        
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText) { [weak self] authResult, error in
            SVProgressHUD.dismiss()
            if let error = error {
                self?.showAlert(title: "Login-In Unsuccessful", message: "Please enter correct credentials")
            } else {
                self?.showAlert(title: "Login-In Successful", message: "You are successfully logged in", actionHandler: { _ in
                    self?.performSegue(withIdentifier: "profile", sender: nil)
                })
            }
        }
    }
    
    private func showAlert(title: String, message: String, actionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: actionHandler))
        present(alert, animated: true, completion: nil)
    }
}
