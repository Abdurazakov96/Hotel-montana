//
//  RegistrationController.swift
//  Hotel montana
//
//  Created by Магомед Абдуразаков on 22/08/2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import UIKit
class RegistrationController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var firstNameTextField:  UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    @IBOutlet var inDatePickerLabel: UILabel!
    @IBOutlet var outDatePickerLabel: UILabel!
    @IBOutlet var adultsLabel: UILabel!
    @IBOutlet var childrenLabel: UILabel!
    @IBOutlet var adultsStepper: UIStepper!
    @IBOutlet var childrenStepper: UIStepper!
    @IBOutlet var wifiSwitch: UISwitch!
    @IBOutlet var roomTypeLabel: UILabel!
    
    // MARK: - Public properties
    
    var inDatePickerLabelIndex = IndexPath(row: 0, section: 1)
    var inDatePickerIndex = IndexPath(row: 1, section: 1)
    var outDatePickerLabelIndex = IndexPath(row: 2, section: 1)
    var outDatePickerIndex = IndexPath(row: 3, section: 1)
    var inDatePickerStatus:Bool = false {
        didSet {
            checkInDatePicker.isHidden = !inDatePickerStatus
        }
        
    }
    var outDatePickerStatus:Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !outDatePickerStatus
        }
        
    }
    var roomType: RoomType?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let todaysDate = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = todaysDate
        checkInDatePicker.date = todaysDate
        checkOutDatePicker.date =
            checkInDatePicker.date.addingTimeInterval(24 * 60 * 60)
        updateDateViews()
        updateRoomType()
        updatePeople()
        addDoneButtonTo(firstNameTextField)
        addDoneButtonTo(lastNameTextField)
        addDoneButtonTo(emailTextField)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SelectedRoomType" else {return}
        let destination = segue.destination as? SelectedTableViewController
        destination?.delegate = self
        destination?.roomType = roomType
    }
    
    // MARK: - Public methods
    
    func updatePeople() {
        adultsLabel.text = String(Int(adultsStepper.value))
        childrenLabel.text = String(Int(childrenStepper.value))
    }
    
    func updateDateViews() {
        checkOutDatePicker.minimumDate =
            checkInDatePicker.date.addingTimeInterval(24 * 60 * 60)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        inDatePickerLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        outDatePickerLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name}
        else {
            roomTypeLabel.text = "Not set"
        }
        
    }
    
    // MARK: - IBActions
    
    @IBAction func dateInPickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    @IBAction func steppinChanged(_ sender: UIStepper) {
        updatePeople()
    }
    
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        let wifiSwitchStatus = wifiSwitch.isOn
        
        guard firstNameTextField.text != ""  else {return}
        guard firstNameTextField.text != ""  else {return}
        guard firstNameTextField.text != ""  else {return}
        guard roomType?.name != "" else {return}
        let registration = Registration(
            firstName: firstNameTextField.text ?? "",
            lastName: lastNameTextField.text ?? "",
            email: emailTextField.text ?? "",
            chickInDate: checkInDatePicker.date,
            checkOutDate: checkOutDatePicker.date,
            numberOfAdults: Int(adultsStepper.value),
            numberOfChildren: Int(childrenStepper.value),
            roomType: roomType,
            wifi: wifiSwitchStatus)
        
        print(registration)
    }
    
}

// MARK: - Extension

extension RegistrationController {
    
    // MARK: - Lifecycle
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case inDatePickerIndex:
            return inDatePickerStatus ? UITableView.automaticDimension : 0
        case outDatePickerIndex:
            return  outDatePickerStatus ? UITableView.automaticDimension : 0
        default:
            return UITableView.automaticDimension
        }
        
    }
    
}

// MARK: - Extension

extension RegistrationController {
    
    // MARK: - Lyfecycle
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case inDatePickerLabelIndex:
            inDatePickerStatus.toggle()
            outDatePickerStatus = false
        case outDatePickerLabelIndex:
            outDatePickerStatus.toggle()
            inDatePickerStatus = false
        default:
            return
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}

// MARK: - Extension

extension RegistrationController: SelectedRoomTypeTableViewControllerProtocol{
    
    // MARK: - Public method
    
    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
}

// MARK: - Extension

extension RegistrationController: UITextFieldDelegate {
    
    // MARK: - Lifecycle
    
    // Скрытие клавиатуры по тапу за пределами Text View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true) // Скрывает клавиатуру, вызванную для любого объекта
    }
    
    // MARK: - Private method
    
    // Метод для отображения кнопки "Готово" на цифровой клавиатуре
    private func addDoneButtonTo(_ textField: UITextField) {
        
        let keyboardToolbar = UIToolbar()
        textField.inputAccessoryView = keyboardToolbar
        keyboardToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title:"Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDone))
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
    
    // MARK: - Public method
    // Скрываем клавиатуру нажатием на "Done"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Objc private method
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }
    
    
    
    
}
