//
//  ScheduleReminderContainerView.swift
//  Shelter
//
//  Created by Александра Сергеева on 24.07.2024.
//

import UIKit

final class ScheduleReminderContainerView: UIView {
    lazy var reminderTextTF = {
        let textField = TextFieldsFactory.createTextField(with: "What to remind")
        textField.delegate = delegate
        return textField
    }()
    
    lazy var countOfCharactersLabel = {
        let label = LabelsFactory.createLabel(with: "15")
        label.textColor = .lightGray
        return label
    }()
    
    lazy var dateOfReminderTextField: UITextField = {
        let date = TextFieldsFactory.createTextField(with: "Date to remind")
        date.delegate = delegate
        date.inputView = dateOfReminderPicker
        date.inputAccessoryView = toolBar
        return date
    }()
    
    lazy var dateOfReminderPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = .current
        picker.backgroundColor = .systemBackground
        picker.datePickerMode = .dateAndTime
        picker.minimumDate = Date()
        picker.timeZone = .autoupdatingCurrent
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    lazy var scheduleReminderButton = ButtonsFactory.createButton(with: "Schedule a reminder")
    
    lazy var isDailyLabel = LabelsFactory.createLabel(with: "Repeat reminder daily?")
    
    lazy var isDailySwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.setOn(false, animated: true)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    lazy var toolBar: UIToolbar = {
        let bar = UIToolbar()
        bar.barStyle = UIBarStyle.default
        bar.isTranslucent = true
        bar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        bar.setItems([doneButton], animated: false)
        bar.isUserInteractionEnabled = true
        return bar
    }()
    
    private let delegate: UITextFieldDelegate
    
    private let offsetForConstraints: CGFloat = 16
    
    init(delegate: UITextFieldDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ScheduleReminderContainerView {
    func setupViews() {
        addSubview(reminderTextTF)
        addSubview(scheduleReminderButton)
        addSubview(dateOfReminderTextField)
        addSubview(isDailyLabel)
        addSubview(isDailySwitcher)
        addSubview(countOfCharactersLabel)
        
        backgroundColor = .systemBackground
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraints = [
            reminderTextTF.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: offsetForConstraints),
            reminderTextTF.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -offsetForConstraints),
            reminderTextTF.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: offsetForConstraints),
            
            countOfCharactersLabel.topAnchor.constraint(equalTo: reminderTextTF.topAnchor, constant: 8),
            countOfCharactersLabel.trailingAnchor.constraint(equalTo: reminderTextTF.trailingAnchor, constant: -8),
            
            dateOfReminderTextField.topAnchor.constraint(equalTo: reminderTextTF.bottomAnchor, constant: offsetForConstraints),
            dateOfReminderTextField.trailingAnchor.constraint(equalTo: reminderTextTF.trailingAnchor),
            dateOfReminderTextField.leadingAnchor.constraint(equalTo: reminderTextTF.leadingAnchor),
            
            isDailyLabel.topAnchor.constraint(equalTo: dateOfReminderTextField.bottomAnchor, constant: offsetForConstraints),
            isDailyLabel.leadingAnchor.constraint(equalTo: dateOfReminderTextField.leadingAnchor),
            
            isDailySwitcher.topAnchor.constraint(equalTo: dateOfReminderTextField.bottomAnchor, constant: offsetForConstraints),
            isDailySwitcher.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -offsetForConstraints),
            isDailySwitcher.bottomAnchor.constraint(equalTo: isDailyLabel.bottomAnchor),
            
            scheduleReminderButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            scheduleReminderButton.widthAnchor.constraint(equalToConstant: 188),
            scheduleReminderButton.heightAnchor.constraint(equalToConstant: 44),
            scheduleReminderButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}
