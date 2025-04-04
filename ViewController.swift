import UIKit

class TaskManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasks: [String] = []
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add New Task", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openAddTaskScreen), for: .touchUpInside)
        return button
    }()
    
    let taskCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Tasks: 0"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let clearAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear All Tasks", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearAllTasks), for: .touchUpInside)
        return button
    }()
    
    let viewCompletedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Completed Tasks", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(viewCompletedTasks), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Task Manager"
        
        view.addSubview(tableView)
        view.addSubview(addTaskButton)
        view.addSubview(taskCountLabel)
        view.addSubview(clearAllButton)
        view.addSubview(viewCompletedButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "taskCell")
        
        loadTasks()
        setupConstraints()
        
        
        
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.rightBarButtonItem = settingsButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTasks), name: NSNotification.Name("TaskAdded"), object: nil)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: addTaskButton.topAnchor, constant: -20),
            
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            addTaskButton.widthAnchor.constraint(equalToConstant: 200),
            addTaskButton.heightAnchor.constraint(equalToConstant: 44),
            
            taskCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            taskCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            clearAllButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearAllButton.bottomAnchor.constraint(equalTo: addTaskButton.topAnchor, constant: -10),
            clearAllButton.widthAnchor.constraint(equalToConstant: 200),
            clearAllButton.heightAnchor.constraint(equalToConstant: 44),
            
            viewCompletedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewCompletedButton.bottomAnchor.constraint(equalTo: clearAllButton.topAnchor, constant: -10),
            viewCompletedButton.widthAnchor.constraint(equalToConstant: 200),
            viewCompletedButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func loadTasks() {
        tasks = UserDefaults.standard.stringArray(forKey: "tasks") ?? []
        taskCountLabel.text = "Total Tasks: \(tasks.count)"
        tableView.reloadData()
    }
    
    @objc func reloadTasks() {
        loadTasks()
    }
    
    @objc func openAddTaskScreen() {
        let addTaskVC = AddTaskViewController()
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    @objc func clearAllTasks() {
        let alert = UIAlertController(title: "Clear All Tasks", message: "Are you sure you want to delete all tasks?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
            UserDefaults.standard.removeObject(forKey: "tasks")
            self.loadTasks()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func viewCompletedTasks() {
        let completedTasksVC = CompletedTasksViewController()
        navigationController?.pushViewController(completedTasksVC, animated: true)
    }
    
    @objc func openSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        let task = tasks[indexPath.row]
        
        let attributeString = NSMutableAttributedString(string: task)
        if task.hasPrefix("✅") {
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: task.count))
        }
        cell.textLabel?.attributedText = attributeString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            UserDefaults.standard.set(tasks, forKey: "tasks")
            tableView.deleteRows(at: [indexPath], with: .fade)
            loadTasks()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: "Complete") { (action, view, completionHandler) in
            if !self.tasks[indexPath.row].hasPrefix("✅") { // Prevent duplicate completion
                self.tasks[indexPath.row] = "✅ " + self.tasks[indexPath.row]
                UserDefaults.standard.set(self.tasks, forKey: "tasks")
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            completionHandler(true)
        }
        
        completeAction.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
}

class CompletedTasksViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Completed Tasks"
    }
}
