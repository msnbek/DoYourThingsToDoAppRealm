//
//  ViewController.swift
//  DoYourThingsToDoApp
//
//  Created by Mahmut Senbek on 26.12.2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    var itemArray = ["Play RDR2","Pay Bills","Do Homework"]

    var userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        print(itemArray)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        if let items =  userDefaults.array(forKey: "toDo") as? [String] {
            itemArray = items
        }
    }
    
    @objc func addButton() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Plan", message: "", preferredStyle: UIAlertController.Style.alert)
        let action =  UIAlertAction(title: "Add Plan", style: UIAlertAction.Style.default) { (action) in
            
            if textField.text == "" {
                let alert = UIAlertController(title: "Error", message: "Please Write Your Plan.", preferredStyle: UIAlertController.Style.actionSheet)
                let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }else {
              //  print(textField.text)
                self.itemArray.append(textField.text!)
                
                self.userDefaults.set(self.itemArray, forKey: "toDo")
                // Yazılan planı Array'in icine ekler.
                self.tableView.reloadData()
            }
          

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
            print(alertTextField)
            
        }
            
        
        
        alert.addAction(action)
        self.present(alert, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // Checkmark kaldırma ve koyma
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        // Checkmark kaldırma ve koyma
        
        
        // Cell secildiginde saniyelik efekt koyma.
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }


}

