//
//  ViewController.swift
//  DoYourThingsToDoApp
//
//  Created by Mahmut Senbek on 26.12.2022.
//

import UIKit
import RealmSwift
import ChameleonFramework
class TableViewController: UITableViewController {
    
    let realm = try! Realm()
     

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var toDoPlans : Results<Plan>?
    var selectedCategory : Category? {
        didSet{
            loadPlan()
        }
    }
   // let dataFilePath = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first?.appendingPathComponent("Plan.plist")
  //  var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
    
    
       // print(FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask))
       // print(dataFilePath)
    // if let items =  userDefaults.array(forKey: "toDo") as? [Plan] {
      //   toDoPlans = items
     // }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex =  selectedCategory?.color {
            
            if let nameTitle = selectedCategory?.name {
                title = nameTitle
            }
          
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller Doesn't Exist.")}
            navBar.backgroundColor = UIColor(hexString: colorHex)
            if let navBarColour = UIColor(hexString: colorHex) {
                navBar.barTintColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true) // constrat.
                searchBar.tintColor = navBarColour
             
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)] // NAV TİTLE DEGİSTİRİR.
            }
            
        }
        
    }
    
    func searchBarBackgroundColour() {
        
        if let colour = UIColor(hexString: selectedCategory!.color) {
            searchBar.backgroundImage = UIImage()
            searchBar.tintColor = colour
            searchBar.barTintColor = colour
        }
        
    }
    
    //MARK: - Save Plan Function
    func savePlan(plan : Plan) {
        
        
        
        do {
            try realm.write {
                realm.add(plan)
                
            }
            
            
        }catch {
            print("saving error")
            
            self.tableView.reloadData()
            
        }
    }
    
    func loadPlan() {
        
        toDoPlans = selectedCategory?.plans.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }

//MARK: - Add Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
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
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newPlan = Plan()
                            newPlan.title = textField.text!
                           
                            newPlan.dateCreated = Date()
                            currentCategory.plans.append(newPlan)
                        }
                    }catch {
                        print("saving error \(error)")
                    }
        
                }
            
                self.tableView.reloadData()
                
            //    newPlan.done = false   Plan.swift dosyası içinde zaten tanımlandı
        
            }
          
        
        }
        //Alert icinde textField olusturma.
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
            return toDoPlans?.count ?? 1
            
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            if  let plan = toDoPlans?[indexPath.row] {
                
                cell.textLabel?.text = plan.title
                let colour = UIColor(hexString: selectedCategory!.color)
                if let color = colour?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoPlans!.count)) {
                    
                    cell.backgroundColor = color
                    cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                }
                
                if plan.done == true {
                    cell.accessoryType = .checkmark
                }else {
                    cell.accessoryType = .none
                }
            }else {
                
                cell.textLabel?.text = "No Plan Added."
            }
           
            
            
            //Ternany operator
            // value = condition ? valueIfTrue : valueIfFalse
            // cell.accessoryType = plan.done ? .checkmark : .none Aşağıdaki if kontrolünün aynısını yapar.
            
          
            
            return cell
        }
        
        
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
           if let item = toDoPlans?[indexPath.row] {
               do {
                   try realm.write {
                       item.done = !item.done // checkmark koyma islemi.
                   }
               }catch {
                   print("checkmark error \(error)")
               }
           }
           tableView.reloadData()
           
           
          
           
           
            //  Asağıdaki if kontrolünü saglayan diger bir kod blok'u.
            // toDoPlans[indexPath.row].done = !toDoPlans[indexPath.row].done
      
     
            // Checkmark kaldırma ve koyma
           /*
            if toDoPlans?[indexPath.row].done == false {
                toDoPlans?[indexPath.row].done = true
            }else {
                toDoPlans?[indexPath.row].done = false
            }
            */
            // Checkmark kaldırma ve koyma
           
         
              tableView.deselectRow(at: indexPath, animated: true)   // Cell secildiginde saniyelik efekt koyma.
        
        }
         
         
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
            
                if let deletingRow = toDoPlans?[indexPath.row] {
                    do {
                        try realm.write {
                            realm.delete(deletingRow)
                        }
                        }catch {
                            print("deleting error \(error)")
                    }
                }
                self.tableView.reloadData()
               
            }
        }

        
    }
//MARK: - SearchBar Methods


extension TableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoPlans = toDoPlans?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
  
    
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadPlan()
            self.tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
    
}
    




