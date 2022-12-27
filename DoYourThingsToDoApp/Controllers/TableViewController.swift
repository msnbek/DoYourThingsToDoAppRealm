//
//  ViewController.swift
//  DoYourThingsToDoApp
//
//  Created by Mahmut Senbek on 26.12.2022.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    

    
    var itemArray = [Plan]()
   // let dataFilePath = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first?.appendingPathComponent("Plan.plist")
  //  var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(itemArray)
        
        print(FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask))
     
       // print(dataFilePath)
     loadPlan()
      
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        
        
    // if let items =  userDefaults.array(forKey: "toDo") as? [Plan] {
      //   itemArray = items
     // }
    }
    
    //MARK: - Save Plan Function
    func savePlan() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            try context.save()
            print("saved")
        }catch {
          print("saving error")
        }
        self.tableView.reloadData()
        
    }
    
    func loadPlan() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request : NSFetchRequest<Plan> = Plan.fetchRequest()
        do {
           itemArray =  try context.fetch(request)
        }catch {
            print("load error \(error)")
        }
     
        
        
    }
    

    
    
    
    
  
    
//MARK: -
    
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
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
               let newPlan = Plan(context: context)
                newPlan.done = false
                newPlan.title = textField.text!
                self.itemArray.append(newPlan)
                self.savePlan()
            
                
                 
              	
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
  
}



    //MARK: - TableView
    extension TableViewController {
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemArray.count
            
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            let plan = itemArray[indexPath.row]
            cell.textLabel?.text = plan.title
            
            
            //Ternany operator
            // value = condition ? valueIfTrue : valueIfFalse
            // cell.accessoryType = plan.done ? .checkmark : .none Aşağıdaki if kontrolünün aynısını yapar.
            
            if plan.done == true {
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
            
            return cell
        }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            //  Asağıdaki if kontrolünü saglayan diger bir kod blok'u.
            // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
          
       savePlan()
            
            // Checkmark kaldırma ve koyma
            if itemArray[indexPath.row].done == false {
                itemArray[indexPath.row].done = true
            }else {
                itemArray[indexPath.row].done = false
            }
            // Checkmark kaldırma ve koyma
            tableView.reloadData()
            
            
            // Cell secildiginde saniyelik efekt koyma.
           
            
            
        }
        
    }
    




