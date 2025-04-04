import UIKit
import LocalAuthentication

class SettingsViewController: UIViewController {

    let darkModeLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable Dark Mode"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let darkModeSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        toggle.addTarget(self, action: #selector(darkModeChanged), for: .valueChanged)
        return toggle
    }()

    let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable Notifications"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let notificationSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        toggle.addTarget(self, action: #selector(notificationChanged), for: .valueChanged)
        return toggle
    }()

    let fontSizeLabel: UILabel = {
        let label = UILabel()
        label.text = "Font Size"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let fontSizeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Small", "Medium", "Large"])
        control.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "fontSizeIndex")
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(fontSizeChanged), for: .valueChanged)
        return control
    }()

    let themeLabel: UILabel = {
        let label = UILabel()
        label.text = "App Theme"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let themeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Light", "Dark", "System"])
        control.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "themeIndex")
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
        return control
    }()

    let biometricLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable Face ID / Touch ID"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let biometricSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = UserDefaults.standard.bool(forKey: "biometricEnabled")
        toggle.addTarget(self, action: #selector(biometricChanged), for: .valueChanged)
        return toggle
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
        title = "Settings"
        view.backgroundColor = .white
        setupUI()
        applyDarkModeIfNeeded()
        applyTheme()
    }


    func setupUI() {
        view.addSubview(darkModeLabel)
        view.addSubview(darkModeSwitch)
        view.addSubview(notificationLabel)
        view.addSubview(notificationSwitch)
        view.addSubview(fontSizeLabel)
        view.addSubview(fontSizeSegmentedControl)
        view.addSubview(themeLabel)
        view.addSubview(themeSegmentedControl)
        view.addSubview(biometricLabel)
        view.addSubview(biometricSwitch)
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

            notificationLabel.topAnchor.constraint(equalTo: darkModeLabel.bottomAnchor, constant: 30),
            notificationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            notificationSwitch.centerYAnchor.constraint(equalTo: notificationLabel.centerYAnchor),
            notificationSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            fontSizeLabel.topAnchor.constraint(equalTo: notificationLabel.bottomAnchor, constant: 30),
            fontSizeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            fontSizeSegmentedControl.topAnchor.constraint(equalTo: fontSizeLabel.bottomAnchor, constant: 10),
            fontSizeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fontSizeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            themeLabel.topAnchor.constraint(equalTo: fontSizeSegmentedControl.bottomAnchor, constant: 30),
            themeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            themeSegmentedControl.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 10),
            themeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            themeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            biometricLabel.topAnchor.constraint(equalTo: themeSegmentedControl.bottomAnchor, constant: 30),
            biometricLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            biometricSwitch.centerYAnchor.constraint(equalTo: biometricLabel.centerYAnchor),
            biometricSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            clearDataButton.topAnchor.constraint(equalTo: biometricLabel.bottomAnchor, constant: 40),
            clearDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearDataButton.widthAnchor.constraint(equalToConstant: 200),
            clearDataButton.heightAnchor.constraint(equalToConstant: 44),

            appVersionLabel.topAnchor.constraint(equalTo: clearDataButton.bottomAnchor, constant: 40),
            appVersionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


    @objc func darkModeChanged() {
        let enabled = darkModeSwitch.isOn
        UserDefaults.standard.set(enabled, forKey: "darkModeEnabled")
        applyDarkModeIfNeeded()
    }

    @objc func notificationChanged() {
        let enabled = notificationSwitch.isOn
        UserDefaults.standard.set(enabled, forKey: "notificationsEnabled")
    }

    @objc func fontSizeChanged() {
        let selectedIndex = fontSizeSegmentedControl.selectedSegmentIndex
        UserDefaults.standard.set(selectedIndex, forKey: "fontSizeIndex")

        let fontSize: CGFloat
        switch selectedIndex {
        case 0: fontSize = 14
        case 1: fontSize = 18
        case 2: fontSize = 22
        default: fontSize = 16
        }

        appVersionLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .light)
    }

    @objc func themeChanged() {
        let index = themeSegmentedControl.selectedSegmentIndex
        UserDefaults.standard.set(index, forKey: "themeIndex")
        applyTheme()
    }

    @objc func biometricChanged() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            UserDefaults.standard.set(biometricSwitch.isOn, forKey: "biometricEnabled")
        } else {
            biometricSwitch.setOn(false, animated: true)
            let alert = UIAlertController(title: "Biometrics Not Available", message: "Your device does not support Face ID / Touch ID.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    @objc func clearData() {
        let alert = UIAlertController(title: "Clear All Data", message: "Are you sure you want to clear all app data?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()

            self.darkModeSwitch.setOn(false, animated: true)
            self.notificationSwitch.setOn(false, animated: true)
            self.fontSizeSegmentedControl.selectedSegmentIndex = 1
            self.themeSegmentedControl.selectedSegmentIndex = 2
            self.biometricSwitch.setOn(false, animated: true)
            self.appVersionLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
            self.view.backgroundColor = .white
            self.darkModeLabel.textColor = .black
            self.appVersionLabel.textColor = .black
        }))
        present(alert, animated: true)
    }

    // MARK: - Helpers

    func applyDarkModeIfNeeded() {
        let isDark = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        view.backgroundColor = isDark ? .black : .white
        darkModeLabel.textColor = isDark ? .white : .black
        notificationLabel.textColor = isDark ? .white : .black
        fontSizeLabel.textColor = isDark ? .white : .black
        themeLabel.textColor = isDark ? .white : .black
        biometricLabel.textColor = isDark ? .white : .black
        appVersionLabel.textColor = isDark ? .white : .black
    }

    func applyTheme() {
        let index = UserDefaults.standard.integer(forKey: "themeIndex")
        switch index {
        case 0:
            overrideUserInterfaceStyle = .light
        case 1:
            overrideUserInterfaceStyle = .dark
        default:
            overrideUserInterfaceStyle = .unspecified
        }
    }
}

