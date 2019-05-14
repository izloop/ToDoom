//
//  CategoryViewController.swift
//  ToDoom
//
//  Created by Izloop on 5/10/19.
//  Copyright © 2019 Peter Levi Hornig. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categoryArray = [Category]()
    
    var categoryContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        navigationController?.navigationBar.barTintColor = FlatPowderBlue()
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let entry = categoryArray[indexPath.row]
        
        cell.textLabel?.text = entry.name
        
        cell.backgroundColor = UIColor.flatPowderBlue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try categoryContext.save()
        } catch {
            print("Error saving the Category context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        let request: NSFetchRequest<Category> =
            Category.fetchRequest()
        
        do {
            categoryArray = try categoryContext.fetch(request)
        } catch {
            print("Error loading Categories \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        //update the data model
        
        categoryContext.delete(categoryArray[indexPath.row])
        self.categoryArray.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        
        saveCategories()
        
        self.tableView.reloadData()
        
    }
    
    //MARK: - Add new Categories
    
     @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Enter a new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCategory = Category(context: self.categoryContext)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            //save function impementation
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        saveCategories()
//
//        tableView.deselectRow(at: indexPath, animated: true)
//
//    }
    
   
}
