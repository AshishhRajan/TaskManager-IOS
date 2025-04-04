import UIKit

class SettingsViewController: UIViewController {
    
    let darkModeLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable Dark Mode"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let darkModeSwitch: UISwitch = {
        let darkModeSwitch = UISwitch()
        darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        darkModeSwitch.isOn = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        darkModeSwitch.addTarget(self, action: #selector(darkModeChanged), for: .valueChanged)
        return darkModeSwitch
    }()
    
    let clearDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear All Data", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearData), for: .touchUpInside)
        return button
    }()
    
    let appVersionLabel: UILabel = {
        let label = UILabel()
        label.text = "App Version: 1.0.0"
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Settings"
        
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(darkModeLabel)
        view.addSubview(darkModeSwitch)
        view.addSubview(clearDataButton)
        view.addSubview(appVersionLabel)
        
        setupConstraints()
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            darkModeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            darkModeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            darkModeSwitch.centerYAnchor.constraint(equalTo: darkModeLabel.centerYAnchor),
            darkModeSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            clearDataButton.topAnchor.constraint(equalTo: darkModeLabel.bottomAnchor, constant: 40),
            clearDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearDataButton.widthAnchor.constraint(equalToConstant: 200),
            clearDataButton.heightAnchor.constraint(equalToConstant: 44),
            
            appVersionLabel.topAnchor.constraint(equalTo: clearDataButton.bottomAnchor, constant: 40),
            appVersionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    @objc func darkModeChanged() {
        let isDarkModeEnabled = darkModeSwitch.isOn
        UserDefaults.standard.set(isDarkModeEnabled, forKey: "darkModeEnabled")
        
        if isDarkModeEnabled {
            view.backgroundColor = .black
            darkModeLabel.textColor = .white
            appVersionLabel.textColor = .white
        } else {
            view.backgroundColor = .white
            darkModeLabel.textColor = .black
            appVersionLabel.textColor = .black
        }
    }
    
    @objc func clearData() {
        let alert = UIAlertController(title: "Clear All Data", message: "Are you sure you want to clear all app data?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
            UserDefaults.standard.removeObject(forKey: "tasks")
            UserDefaults.standard.removeObject(forKey: "darkModeEnabled")
            self.darkModeSwitch.setOn(false, animated: true)
            self.view.backgroundColor = .white
        }))
        
        
        present(alert, animated: true, completion: nil)
    }
}

