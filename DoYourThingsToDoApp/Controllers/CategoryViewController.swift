//
//  CategoryViewController.swift
//  DoYourThingsToDoApp
//
//  Created by Mahmut Senbek on 27.12.2022.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonPressed))
    }
    
    @objc func addButtonPressed() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title:"Add category" , style: UIAlertAction.Style.default) { (action) in
        
            if textField.text == "" {
                
                let alert = UIAlertController(title: "Error", message: "Please fill the blanks", preferredStyle: UIAlertController.Style.actionSheet)
                let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
                alert.addAction(button)
                self.present(alert, animated: true)
            }else {
                let newCategory = Category(context: context)
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)
                self.saveCategory()
            }
            
        }
     
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
            
        }
        alert.addAction(button)
        self.present(alert, animated: true)
        
        
    }
    
    func saveCategory() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
           try context.save()
            print("saved")
        }catch {
            print("error \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadCategory() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        }catch {
            print("error \(error)")
        }
        self.tableView.reloadData()
    }
    
   
    
   
}

//MARK: - TableView Methods

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
