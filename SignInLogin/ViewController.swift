//
//  ViewController.swift
//  SignInLogin
//
//  Created by Neeraja Sarasan on 28/08/23.
//

import UIKit
import Firebase
import SVProgressHUD
import SideMenu
class ViewController: UIViewController {
    
    @IBOutlet weak var MenuTableView: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
class tableViewCell: UITableViewCell {
    
    @IBOutlet var descriptionLabel: UILabel!
    
}


