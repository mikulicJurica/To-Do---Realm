import UIKit
import SnapKit
import RealmSwift

class ToDoTableViewCell: UITableViewCell {

    static let reuseIdentifier = String(describing: ToDoTableViewCell.self)
    
    private var cellView: UIView!
    private var toDoText: UILabel!
    private var toDoDate: UILabel!
    
    private var cellItem: ToDoItem!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildAndConfigCell()
        buildConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildAndConfigCell() {
        cellView = UIView()
        cellView.backgroundColor = .systemBlue
        cellView.layer.cornerRadius = 20
        addSubview(cellView)
        
        toDoText = UILabel()
        toDoText.textColor = .white
        toDoText.numberOfLines = 0
        toDoText.font = UIFont.boldSystemFont(ofSize: 25)
        toDoText.textAlignment = .left
        cellView.addSubview(toDoText)
        
        toDoDate = UILabel()
        toDoText.font = UIFont.systemFont(ofSize: 20)
        toDoDate.textColor = .white
        toDoDate.textAlignment = .right
        cellView.addSubview(toDoDate)
    }
    
    private func buildConstraints() {
        cellView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(10)
        })
        
        toDoDate.snp.makeConstraints({
            $0.bottom.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        })
        
        toDoText.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(toDoDate.snp.top).offset(-10)
        })
    }
    
    func setCellData(toDoItem: ToDoItem) {
        cellItem = toDoItem
        toDoText.text = cellItem.textToDo

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        toDoDate.text = dateFormatter.string(from: cellItem.createdAt)
    }
    
}
