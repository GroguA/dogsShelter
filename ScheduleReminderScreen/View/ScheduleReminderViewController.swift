//
//  ScheduleReminderViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 12.01.2024.
//

import UIKit

class ScheduleReminderViewController: UIViewController {
    private var viewModel: IScheduleReminderViewModel & IScheduleReminderNavigation
    
    private lazy var containerView = ScheduleReminderContainerView(delegate: self)
    
    init(viewModel: IScheduleReminderViewModel & IScheduleReminderNavigation) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.onAction = { [weak self] action in
            switch action {
            case .showError:
                self?.showAlertMessage(message: action.rawValue)
            case .closeScreen:
                self?.viewModel.popScheduleReminderScreen()
            }
        }
    }
    
}

private extension ScheduleReminderViewController {
    func setupViews() {
        navigationItem.title = "Schedule a reminder"
        
        containerView.dateOfReminderPicker.addTarget(
            self,
            action: #selector(timePickerValueChanged),
            for: .valueChanged
        )
        
        containerView.isDailySwitcher.addTarget(
            self,
            action: #selector(isDailyTapped),
            for: .valueChanged
        )
        
        containerView.scheduleReminderButton.addTarget(
            self,
            action: #selector(scheduleReminderTapped),
            for: .touchUpInside
        )
    
    }
    
    func showAlertMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    
    @objc func timePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let outputTime = dateFormatter.string(from: sender.date)
            containerView.dateOfReminderTextField.text = outputTime
    }
    
    @objc func scheduleReminderTapped() {
        viewModel.onScheduleReminderTapped(
            body:  containerView.reminderTextTF.text,
            date:  containerView.dateOfReminderPicker.date,
            isDaily:  containerView.isDailySwitcher.isOn
        )
    }
    
    @objc func isDailyTapped(_ sender: UISwitch) {
        
    }
    
}

extension ScheduleReminderViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField ==  containerView.reminderTextTF {
            guard let currentString = textField.text else { return false }
            let maxLength = 15
            let currentStringForLength = (textField.text ?? "") as NSString
            let newString = currentStringForLength.replacingCharacters(in: range, with: string)
            
            let newLength = maxLength - currentString.count
            containerView.countOfCharactersLabel.text = String(newLength)
            
            return newString.count <= maxLength
        } else {
            return false
        }
    }
}
