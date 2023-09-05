//
//  loginViewController.swift
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didPressLogin(_ sender: UIButton) {
        SVProgressHUD.show()
        guard let emails = email.text else { return  }
        guard  let pass = password.text else { return }
        Auth.auth().signIn(withEmail: emails, password: pass) { AuthResult, error in
            SVProgressHUD.dismiss()
            if let error = error {
                let alert = UIAlertController(title: "SignIn Unsuccessfull", message: "Please Enter correct id", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "SignIn", message: "You are successfully logged in", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.performSegue(withIdentifier: "profile", sender:nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
                
                
                
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
