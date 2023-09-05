//
//  DashBoardViewController.swift
//  SignInLogin
//
//  Created by Neeraja Sarasan on 28/08/23.
//
import UIKit
import Firebase
import SideMenu
import MapKit
 
class dashBoardViewController: UIViewController {
    
    @IBOutlet weak var locationField: UITextField!
    
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var phnoField: UITextField!
    
    @IBOutlet weak var dobTextField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    
    var menu : SideMenuNavigationController?
    var isEditingProfile = false
    let datePicker = UIDatePicker()
    let ref = Database.database().reference()
    let currentUser = Auth.auth().currentUser
    let genderOptions = ["Male", "Female", "Other"]
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProfileData()
        updateUI()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        dobTextField.inputView = datePicker
        
        let genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderField.inputView = genderPicker
        
        //sidemenu
        menu = SideMenuNavigationController(rootViewController: menuController())
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
 
    @IBAction func showUserLocationOnMap(_ sender: UIButton) {
        performSegue(withIdentifier: "showMap", sender: nil)
    }
    @IBAction func logout(_ sender: UIButton) {
        performSegue(withIdentifier: "log", sender: nil)
    }
    @IBAction func didTouchmenu(_ sender: UIBarButtonItem) {
        present(menu!,animated: true)
    }
    func fetchProfileData() {
        if let uid = currentUser?.uid {
            ref.child("users").child(uid).observeSingleEvent(of: .value) { snapshot,_ in
                if let userData = snapshot.value as? [String: Any] {
                    self.nameField.text = userData["name"] as? String
                    self.dobTextField.text = userData["dob"] as? String
                    self.locationField.text = userData["location"] as? String
                    self.genderField.text = userData["gender"] as? String
                    self.phnoField.text = userData["phone"] as? String
                }
            }
        }
    }
    
    func updateUI() {
        if isEditingProfile {
            nameField.isEnabled = true
            dobTextField.isEnabled = true
            locationField.isEnabled = true
            genderField.isEnabled = true
            phnoField.isEnabled = true
            editButton.setTitle("Save", for: .normal)
        } else {
            nameField.isEnabled = false
            dobTextField.isEnabled = false
            locationField.isEnabled = false
            genderField.isEnabled = false
            phnoField.isEnabled = false
            editButton.setTitle("Edit", for: .normal)
        }
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }

    
    
@IBAction func editButtonPress(_ sender: UIButton) {
        
        isEditingProfile.toggle()
        updateUI()
        
        if !isEditingProfile {
            updateProfileData()
        }
    }
    
    func updateProfileData() {
        guard let phoneNumber = phnoField.text, isValidPhoneNumber(phoneNumber) else {
               let errorAlert = UIAlertController(title: "Invalid Phone Number", message: "Please enter a valid 10-digit phone number.", preferredStyle: .alert)
               errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(errorAlert, animated: true, completion: nil)
               return
           }
        
        if let uid = currentUser?.uid {
            let userData = [
                "name": nameField.text,
                "dob": dobTextField.text,
                "location": locationField.text,
                "gender": genderField.text,
                "phone": phnoField.text
                
                
            ]
            ref.child("users").child(uid).setValue(userData) { error, _ in
                if let error = error {
                    print("Error updating profile: \(error.localizedDescription)")
                } else {
                    print("Profile updated successfully")
                    let successAlert = UIAlertController(title: "Profile Updated", message: "Profile Updated Successfully", preferredStyle: .alert)
                    successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(successAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
   
    @IBAction func datePickerValueChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" // Define your desired date format
        dobTextField.text = dateFormatter.string(from: datePicker.date)
    }
}
extension dashBoardViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = genderOptions[row]
    }

}


