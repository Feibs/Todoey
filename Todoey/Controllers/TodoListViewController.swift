//
//  ViewController.swift
//  Todoey
//
//  Created by Jason Feibelman on 6/3/18.
//  Copyright © 2018 Feibel. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet { //everything here gets triggered when selectedCategory is set with an item
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //Shared singleton object of current app
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    //MARK: Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) //dequeue cell
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done == true ? .checkmark : .none
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        itemArray[indexPath.row].setValue("Completed", forKey: String) Updating data in Core DB (crUd)
        
//        context.delete(itemArray[indexPath.row]) // (cruD) deltes data from storage
//        itemArray.remove(at: indexPath.row) // (cruD) deletes item from item array
        //need context.save() for all except read (CrUD)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens after clicking add item button
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New Item"
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Model Manipulation Methods
    func saveItems() { // (Crud)
        
        do {
            try context.save()
        } catch {
            print("Error Saving Context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){ // (cRud)
        
        let categoryPred = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPred, additionalPredicate])
        } else {
            request.predicate = categoryPred
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error Fetching Data from context \(error)")
        }
    }
    
    
}

//MARK: SearchBar Methods
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // arr of sort descriptors
        
        loadItems(with: request, predicate: predicate)
        
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error Fetching Data from context \(error)")
//        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 { // when clear text -> revert to original list
            loadItems()
            
            DispatchQueue.main.async { // Get rid of cursor in searchbar and keyboard after clear text
                searchBar.resignFirstResponder()
            }
        }
    }
}

