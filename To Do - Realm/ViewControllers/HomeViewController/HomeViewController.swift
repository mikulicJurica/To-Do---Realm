import UIKit
import SnapKit
import RealmSwift

class HomeViewController: UIViewController {
    
    private var topBarAddButton: UIBarButtonItem!
    private var tableView: UITableView!
    
    private var realm = try! Realm()
    
    private var itemsList = List<ToDoItem>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildTopBar()
        buildViews()
        styleViews()
        buildConstraints()
        
        //get data
        //deleteDatabase()
        getDataFromDatabase()
        
        
        
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
    
    private func refreshDataAndTable() {
        //refresh table with new data
    }
    
    @objc private func addTapped() {
        let alert = UIAlertController(title: "New TO DO Item", message: "Enter new task", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak alert] _ in
            guard let textFieldData = alert?.textFields?[0].text else {
                fatalError()
            }
        
            //create new item in database
            self.saveToDatabase(newText: textFieldData)
            
        }))
        present(alert, animated: true)
    }
    
    
    
    
    private func getDataFromDatabase() -> List<ToDoItem> {
        let items = realm.objects(ToDoItem.self)
        return items
    }
    
    private func saveToDatabase(newText: String) {
        let newToDo = ToDoItem()
        newToDo.textToDo = newText
        newToDo.createdAt = Date()
        
        try! realm.write {
            realm.add(newToDo)
        }
    }
    
    private func deleteDatabase() {
        self.realm.beginWrite()
        self.realm.delete(realm.objects(ToDoItem.self))
        try! self.realm.commitWrite()
    }
    
    private func updateDatabase() {
        
    }
    
    private func findByText(text: String) -> Results<ToDoItem> {
        let predicate = NSPredicate(format: "textToDo = %@", text)
        return realm.objects(ToDoItem.self).filter(predicate)
    }
    
    
    

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5 //get count number from database
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.reuseIdentifier) as? ToDoTableViewCell else {
            fatalError()
        }
        //cell.setCellData(toDoItem: itemsList[indexPath.row])
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
            //alert.textFields?.first?.text = self.itemsList[indexPath.row].name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak alert] _ in
//                guard let textFieldData = alert?.textFields?[0].text else {
//                    fatalError()
//                }
            
                //update item
                
            }))
            self.present(alert, animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
//            guard let item = self?.itemsList[indexPath.row] else {
//                fatalError()
//            }
            
            //delete item
            
            self?.refreshDataAndTable()
        }))
        
        present(sheet, animated: true)
    }
}



class ToDoItem: Object {
    @objc dynamic var textToDo: String = ""
    @objc dynamic var createdAt: Date = Date()
}
