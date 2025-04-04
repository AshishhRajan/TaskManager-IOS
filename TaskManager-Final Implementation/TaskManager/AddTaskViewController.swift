import UIKit

class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Task Name:"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter task name..."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let urgencyLabel: UILabel = {
        let label = UILabel()
        label.text = "Urgency Level:"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let urgencyPicker = UIPickerView()
    let urgencyLevels = ["Low", "Medium", "High"]
    
    let deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Deadline Date:"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        return picker
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Time:"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Task", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Add New Task"
        
        urgencyPicker.delegate = self
        urgencyPicker.dataSource = self
        
        setupScrollView()
        setupUI()
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [
            taskTitleLabel, taskTextField,
            urgencyLabel, urgencyPicker,
            deadlineLabel, datePicker,
            timeLabel, timePicker,
            saveButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            taskTextField.heightAnchor.constraint(equalToConstant: 40),
            urgencyPicker.heightAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func saveTask() {
        guard let taskText = taskTextField.text, !taskText.isEmpty else {
            showAlert(title: "Error", message: "Please enter a task name.")
            return
        }
        
        let selectedUrgency = urgencyLevels[urgencyPicker.selectedRow(inComponent: 0)]
        let selectedDate = datePicker.date
        let selectedTime = timePicker.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let dateString = formatter.string(from: selectedDate)
        
        formatter.dateFormat = "hh:mm a"
        let timeString = formatter.string(from: selectedTime)
        
        let taskDetails = "\(taskText) - [\(selectedUrgency)] - Due: \(dateString) at \(timeString)"
        
        var tasks = UserDefaults.standard.stringArray(forKey: "tasks") ?? []
        tasks.append(taskDetails)
        UserDefaults.standard.set(tasks, forKey: "tasks")
        
        NotificationCenter.default.post(name: NSNotification.Name("TaskAdded"), object: nil)
        
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return urgencyLevels.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return urgencyLevels[row] }
}
