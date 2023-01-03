//
//  CategoryViewController.swift
//  DoYourThingsToDoApp
//
//  Created by Mahmut Senbek on 27.12.2022.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: UITableViewController {
    
  
 
    let realm = try! Realm()
    
    var categories : Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.rowHeight = 82.00
        self.tableView.separatorColor = UIColor.clear // tableview separatör silme.

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonPressed))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller Doesn't Exist.")}
        
        navBar.backgroundColor = UIColor(.white)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(.black)]
    }
    
    //MARK: - AddButton Func
    
    @objc func addButtonPressed() {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title:"Add category" , style: UIAlertAction.Style.default) { (action) in
        
            if textField.text == "" {
                
                let alert = UIAlertController(title: "Error", message: "Please fill the blanks", preferredStyle: UIAlertController.Style.actionSheet)
                let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
                alert.addAction(button)
                self.present(alert, animated: true)
            }else {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat().hexValue()
   
         
                self.saveCategory(category: newCategory)
            }
            
        }
     
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
            
        }
        alert.addAction(button)
        self.present(alert, animated: true)
        
        
    }
    //MARK: - Save Func
    func saveCategory(category : Category) {
    
        do {
            try realm.write {
                realm.add(category)
            }
            print("saved")
        }catch {
            print("error \(error)")
        }
        self.tableView.reloadData()
        
    }
    
//MARK: - Load Func
    
    func loadCategory() {
       
         categories = realm.objects(Category.self)
    self.tableView.reloadData()
    }
}

//MARK: - TableView Methods

extension CategoryViewController{
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1  // nil degilse sayısını göster nil ise 1 göster.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        cell.delegate = self
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? ".white")
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: categories?[indexPath.row].color ?? ".white")!, returnFlat: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toSecondVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let deletingRow = categories?[indexPath.row] {
                
                do {
                    try realm.write {
                        realm.delete(deletingRow)
                    }
                }catch {
                    print("deleting  row error \(error)")
                }
                
            }
            self.tableView.reloadData()
        }
    }
     
*/
}

//MARK: - SwipeKit

extension CategoryViewController: SwipeTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let deletingRow = self.categories?[indexPath.row] {
                
                do {
                    try self.realm.write {
                        self.realm.delete(deletingRow)
                        print("deleted")
                    }
                }catch {
                    print("deleting  row error \(error)")
                }
                
            }
        //    self.tableView.reloadData()
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
        }
    
  
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
      
        return options
    }
    
    
}
