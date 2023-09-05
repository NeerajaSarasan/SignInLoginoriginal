//
//  menuController.swift
//  SignInLogin
//
//  Created by Neeraja Sarasan on 31/08/23.
//

import UIKit
import SideMenu
class menuController: UITableViewController {
    var items = ["Home","Map","Log Out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedItem = items[indexPath.row]
        if selectedItem == "Map" {
            let viewController1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "map")
            navigationController?.pushViewController(viewController1, animated: true)
        }
        if selectedItem == "Home" {
            let viewController1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home")
            navigationController?.pushViewController(viewController1, animated: true)
        }
    }
    
}

    


