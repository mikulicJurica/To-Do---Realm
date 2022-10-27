import UIKit
import SnapKit
import RealmSwift

class HomeViewController: UIViewController {
    
    private var topBarAddButton: UIBarButtonItem!
    private var tableView: UITableView!
    
    private var realm: Realm!
    
    private var itemsList: Results<ToDoItem>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        
        itemsList = getDataFromDatabase()
        
        buildTopBar()
        buildViews()
        styleViews()
        buildConstraints()
        
        //deleteDatabase()
        
    }
    
    private func buildTopBar() {
        topBarAddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = topBarAddButton
        
        navigationItem.title = "Realm TO DO List"
    }
    
    private func buildViews() {
        tableView = UITableView()
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func styleViews() {
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 120
    }
    
    private func buildConstraints() {
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    @objc private func addTapped() {
        let alert = UIAlertController(title: "New TO DO Item", message: "Enter new task", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak alert] _ in
            guard let textFieldData = alert?.textFields?[0].text else {
                fatalError()
            }
            
            self.saveToDatabase(newText: textFieldData)
            self.tableView.reloadData()
            
        }))
        present(alert, animated: true)
    }
    
    //MARK: - Realm functions
    
    private func getDataFromDatabase() -> Results<ToDoItem> {
        let items = realm.objects(ToDoItem.self)
        return items
    }
    
    private func saveToDatabase(newText: String) {
        let newToDo = ToDoItem()
        newToDo.textToDo = newText
        newToDo.createdAt = Date()
        
        do {
            try realm.write {
                realm.add(newToDo)
            }
        } catch {
            print("Error saving new instance in database, \(error)")
        }
    }
    
    private func deleteObjectInDatabase(objectToDelete: ToDoItem) {
        do {
            try realm.write {
                realm.delete(objectToDelete)
            }
        } catch {
            print("Error deleting object in database, \(error)")
        }
    }
    
    private func deleteDatabase() {
        do {
            try realm.write {
                realm.delete(realm.objects(ToDoItem.self))
            }
        } catch {
            print("Error deleting database, \(error)")
        }
    }
    
    private func updateDatabase(itemToUpdate: ToDoItem, newText: String) {
        do {
            try realm.write {
                itemToUpdate.textToDo = newText
            }
        } catch {
            print("Error updating, \(error)")
        }
    }
    
    private func searchInDatabase(searchText: String) -> Results<ToDoItem> {
        let predicate = NSPredicate(format: "textToDo CONTAINS[cd] %@", searchText)
        //let predicate = NSPredicate(format: "textToDo = %@", searchText) //find the same
        return realm.objects(ToDoItem.self).filter(predicate)
    }
    
    //MARK: - TableView

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.reuseIdentifier) as? ToDoTableViewCell else {
            fatalError()
        }
        
        guard let toDo = itemsList?[indexPath.row] else {
            fatalError()
        }
        
        cell.setCellData(toDoItem: toDo)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sheet = UIAlertController(title: "TO DO Item OPTIONS", message: "Edit or Delete", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        sheet.addAction(UIAlertAction(title: "Edit with new text", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit item", message: "Edit your item", preferredStyle: .alert)
            alert.addTextField()
            guard let toDo = self.itemsList?[indexPath.row] else {
                fatalError()
            }
            alert.textFields?.first?.text = toDo.textToDo
            
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak alert] _ in
                guard let textFieldData = alert?.textFields?[0].text else {
                    fatalError()
                }
            
                self.updateDatabase(itemToUpdate: toDo, newText: textFieldData)
                tableView.reloadData()
                
            }))
            self.present(alert, animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let toDo = self?.itemsList?[indexPath.row] else {
                fatalError()
            }
            
            self?.deleteObjectInDatabase(objectToDelete: toDo)
            
            self?.tableView.reloadData()
        }))
        
        present(sheet, animated: true)
    }
}
