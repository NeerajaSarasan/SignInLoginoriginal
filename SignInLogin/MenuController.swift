//
//  menuController.swift
//  SignInLogin
//
//  Created by Neeraja Sarasan on 31/08/23.
import UIKit

class MenuController: UITableViewController {
    let items = ["Home", "Map","LogOut"]
    
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
        let selectedItem = items[indexPath.row]
        switch selectedItem {
        case "Map", "Home":
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: selectedItem.lowercased())
            navigationController?.pushViewController(viewController, animated: true)
        case "LogOut":
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: selectedItem.lowercased())
            navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}




