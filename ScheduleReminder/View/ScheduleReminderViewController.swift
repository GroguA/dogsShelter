//
//  ScheduleReminderViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 12.01.2024.
//

import UIKit

class ScheduleReminderViewController: UIViewController {
    
    var id: String = ""
    
    private let viewModel = ScheduleReminderViewModel()
    
    private var isDaily: Bool = false
    private var hour: Int?
    private var minute: Int?
    private var month: Int?
    private var day: Int?
    
    private lazy var reminderTextTF: UITextField = {
        let reminder = UITextField()
        reminder.placeholder = "What you want to remind"
        reminder.keyboardType = .default
        reminder.autocapitalizationType = .sentences
        reminder.borderStyle = .roundedRect
        reminder.delegate = self
        reminder.autocorrectionType = .default
        reminder.translatesAutoresizingMaskIntoConstraints = false
        return reminder
    }()
    
    private lazy var countOfCharactersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.text = "15"
        return label
    }()
    
    private lazy var dateOfReminderTextField: UITextField = {
        let date = UITextField()
        date.placeholder = "Select date to remind"
        date.keyboardType = .default
        date.borderStyle = .roundedRect
        date.autocorrectionType = .no
        date.inputView = dateOfReminderPicker
        date.inputAccessoryView = toolBar
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private lazy var dateOfReminderPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = .current
        picker.backgroundColor = .white
        picker.datePickerMode = .dateAndTime
        picker.timeZone = .autoupdatingCurrent
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var scheduleReminderButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemBlue
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        let button = UIButton(configuration: configuration)
        button.configuration?.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            return outgoing
        }
        button.setTitle("Schedule a reminder", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(scheduleReminderTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var toolBar: UIToolbar = {
        let bar = UIToolbar()
        bar.barStyle = UIBarStyle.default
        bar.isTranslucent = true
        bar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        bar.setItems([doneButton], animated: false)
        bar.isUserInteractionEnabled = true
        return bar
    }()
    
    private lazy var isDailyLabel: UILabel = {
       let label = UILabel()
        label.text = "Repeat this reminder daily?"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private lazy var isDailySwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(isDailyTapped), for: .valueChanged)
        switcher.setOn(false, animated: true)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.onAction = { action in
            switch action {
            case .editingError:
                self.showAlertMessage(message: action.rawValue)
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(reminderTextTF)
        view.addSubview(scheduleReminderButton)
        view.addSubview(dateOfReminderTextField)
        view.addSubview(isDailyLabel)
        view.addSubview(isDailySwitcher)
        view.addSubview(countOfCharactersLabel)
        
        navigationItem.title = "Schedule a reminder"
        
        view.backgroundColor = .white
        
        
        let constraints = [
            reminderTextTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            reminderTextTF.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            reminderTextTF.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            countOfCharactersLabel.topAnchor.constraint(equalTo: reminderTextTF.topAnchor, constant: 8),
            countOfCharactersLabel.trailingAnchor.constraint(equalTo: reminderTextTF.trailingAnchor, constant: -8),
            
            dateOfReminderTextField.topAnchor.constraint(equalTo: reminderTextTF.bottomAnchor, constant: 16),
            dateOfReminderTextField.trailingAnchor.constraint(equalTo: reminderTextTF.trailingAnchor),
            dateOfReminderTextField.leadingAnchor.constraint(equalTo: reminderTextTF.leadingAnchor),
            
            isDailyLabel.topAnchor.constraint(equalTo: dateOfReminderTextField.bottomAnchor, constant: 16),
            isDailyLabel.leadingAnchor.constraint(equalTo: dateOfReminderTextField.leadingAnchor),
            
            isDailySwitcher.topAnchor.constraint(equalTo: dateOfReminderTextField.bottomAnchor, constant: 16),
            isDailySwitcher.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            isDailySwitcher.bottomAnchor.constraint(equalTo: isDailyLabel.bottomAnchor),
            
            scheduleReminderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            scheduleReminderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    private func showAlertMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc private func timePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let outputTime = dateFormatter.string(from: sender.date)
        dateOfReminderTextField.text = outputTime
        hour = Calendar.current.component(.hour, from: sender.date)
        minute = Calendar.current.component(.minute, from: sender.date)
        month = Calendar.current.component(.month, from: sender.date)
        day = Calendar.current.component(.day, from: sender.date)
    }
    
    @objc private func scheduleReminderTapped() {
        viewModel.onScheduleREminderTapped(body: reminderTextTF.text, hour: hour, minute: minute, isDaily: isDaily, day: day, month: month, identifier: id)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func isDailyTapped(_ sender: UISwitch) {
        if sender.isOn {
            isDaily = true
        } else {
            isDaily = false
        }
    }
    
}

extension ScheduleReminderViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentString = textField.text else { return false }
        let maxLength = 15
        let currentStringForLength = (textField.text ?? "") as NSString
        let newString = currentStringForLength.replacingCharacters(in: range, with: string)
        
        let newLength = maxLength - currentString.count
        self.countOfCharactersLabel.text = String(newLength)
        
        return newString.count <= maxLength
    }
}
