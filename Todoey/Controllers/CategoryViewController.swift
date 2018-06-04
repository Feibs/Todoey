//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jason Feibelman on 6/4/18.
//  Copyright © 2018 Feibel. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //Shared singleton object of current app

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    //MARK: Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what happens after clicking add category button
            let newCat = Category(context: self.context)
            newCat.name = textField.text!
            self.categoryArray.append(newCat)
            
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New Category"
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) //dequeue cell
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    //MARK: TableView Delegate Methods NOT YET
    // what happens when click on a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    
    //MARK: Data Manipulation Methods
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error Saving Context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error Fetching Data from context \(error)")
        }
    }
    
}
