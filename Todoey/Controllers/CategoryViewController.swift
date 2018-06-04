//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jason Feibelman on 6/4/18.
//  Copyright © 2018 Feibel. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?

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
            let newCat = Category()
            newCat.name = textField.text!
            
            self.save(category: newCat)
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
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) //dequeue cell
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
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
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    //MARK: Data Manipulation Methods
    func save(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
                }
        } catch {
            print("Error Saving Context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self) //Fetches all data that are Categories
        tableView.reloadData()
    }
    
}
