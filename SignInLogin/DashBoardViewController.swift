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

class DashBoardViewController: UIViewController {
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    var menu: SideMenuNavigationController?
    var isEditingProfile = false
    let datePicker = UIDatePicker()
    let references = Database.database().reference()
    let currentUser = Auth.auth().currentUser
    let genderOptions = ["Male", "Female", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPickers()
        setupSideMenu()
        fetchProfileData()
    }
    
    func setupUI() {
        nameField.isEnabled = !isEditingProfile
        dateOfBirthField.isEnabled = !isEditingProfile
        locationField.isEnabled = !isEditingProfile
        genderField.isEnabled = !isEditingProfile
        phoneNumberField.isEnabled = !isEditingProfile
        updateEditButtonTitle()
    }
    
    func setupPickers() {
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        dateOfBirthField.inputView = datePicker
        let genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderField.inputView = genderPicker
    }
    
    func setupSideMenu() {
        menu = SideMenuNavigationController(rootViewController: MenuController())
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
    
//    func fetchProfileData() {
//        if let userId = currentUser?.uid {
//            references.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot , _ )  in
//                if let userData = snapshot.value as? [String: String],
//                   let data = UserProfileDataModel(data: userData) {
//                    self.nameField.text = data.name
//                    self.dateOfBirthField.text = data.dateOfBirth
//                    self.locationField.text = data.location
//                    self.genderField.text = data.gender
//                    self.phoneNumberField.text = data.phone
//                }
//            }
//        }
//    }
    func fetchProfileData() {
        if let userId = currentUser?.uid {
            references.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot , _ )  in
                if let userData = snapshot.value as? [String: String] {
                    let data = UserProfileDataModel(data: userData)
                    self.nameField.text = data.name
                    self.dateOfBirthField.text = data.dateOfBirth
                    self.locationField.text = data.location
                    self.genderField.text = data.gender
                    self.phoneNumberField.text = data.phone
                }
            }
        }
    }

    
//    func fetchProfileData() {
//        if let userId = currentUser?.uid {
//            references.child("users").child(userId).observeSingleEvent(of: .value) { snapshot in
//                if let userData = snapshot.value as? [String: String],
//                   let data = UserProfileDataModel(data: userData){
//                    self.nameField.text = data.nameField
//                    self.dateOfBirthField.text = data.dateOfBirthField
//                    self.locationField.text = data.locationField
//                    self.genderField.text = data.genderField
//                    self.phoneNumberField.text = data.phoneNumberField
//
//                }
//            }
//        }
//    }
    
    //    func populateFields(with userData: [String: Any]) {
    //        nameField.text = userData["name"] as? String
    //        dateOfBirthField.text = userData["dateOfBirth"] as? String
    //        locationField.text = userData["location"] as? String
    //        genderField.text = userData["gender"] as? String
    //        phoneNumberField.text = userData["phone"] as? String
    //    }
    
    func updateEditButtonTitle() {
        let title = isEditingProfile ? "Save" : "Edit"
        editButton.setTitle(title, for: .normal)
    }
    
    @IBAction func editButtonPress(_ sender: UIButton) {
        isEditingProfile.toggle()
        setupUI()
        if !isEditingProfile {
            updateProfileData()
        }
    }
    
    func updateProfileData() {
        guard let phoneNumber = phoneNumberField.text, isValidPhoneNumber(phoneNumber) else {
            showAlert(title: "Invalid Phone Number", message: "Please enter a valid 10-digit phone number.")
            return
        }
        if let userId = currentUser?.uid {
            let userData = [
                "name": nameField.text,
                "dob": dateOfBirthField.text,
                "location": locationField.text,
                "gender": genderField.text,
                "phone": phoneNumberField.text
            ]
            references.child("users").child(userId).setValue(userData) { [weak self] error, _ in
                if let error = error {
                    print("Error updating profile: \(error.localizedDescription)")
                } else {
                    print("Profile updated successfully")
                    self?.showAlert(title: "Profile Updated", message: "Profile Updated Successfully")
                }
            }
        }
    }
    
    @IBAction func datePickerValueChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateOfBirthField.text = dateFormatter.string(from: datePicker.date)
    }
}


extension DashBoardViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

