//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Mohamed Jaber on 08/12/2020.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Categories]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategorys()
        tableView.rowHeight=80.0
    }
    
    //MARK: -  TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text=categoryArray[indexPath.row].name
        return cell
    }
    //MARK: -  Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        let alert=UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory=Categories(context: self.context)
            newCategory.name=textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategory()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Create new Category"
            textField=alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    //MARK: -  Data Manipulation Methods
    func loadCategorys(with request: NSFetchRequest<Categories> = Categories.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }
        catch{
            print("Error in retrieving data \(error)")
        }
        tableView.reloadData()
    }
    func saveCategory(){
        do{
            try context.save()
        }catch{
            print("Error in Saving data \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: -  TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory=categoryArray[indexPath.row]
        }
    }
}
extension CategoryViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.context.delete(self.categoryArray[indexPath.row])
            self.categoryArray.remove(at: indexPath.row)
            self.saveCategory()        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }}
