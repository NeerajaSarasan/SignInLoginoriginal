//
//  menuViewController.swift
//  SignInLogin
//
//  Created by Neeraja Sarasan on 31/08/23.
//

import UIKit
import SideMenu
class menuViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            
           // let sideMenuViewController = sideMenuViewController()
            let menu = SideMenuNavigationController(rootViewController: sideMenuViewController())
            SideMenuManager.default.leftMenuNavigationController = menu
        }
        
        @IBAction func openSideMenu(_ sender: UIBarButtonItem) {
            present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
            
        }
    }

class sideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let menuItems = ["Item 1", "Item 2", "Item 3"] // Your menu items
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        
    }
    
}


