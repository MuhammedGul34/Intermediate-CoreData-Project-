//
//  CreateEmployeeController.swift
//  IntermediateTraining
//
//  Created by Muhammed Gül on 28.11.2022.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    var company : Company?
    
    var delegate : CreateEmployeeControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        // enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        // enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let birthdayTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "MM/dd/yyyy"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Create Employee"
        
        setupCancelButton()
        
        view.backgroundColor = .darkBlue
        
        setupUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc private func handleSave(){
        
        guard let employeeName = nameTextField.text else {return}
        guard let company = self.company else { return }
        
        // turn birthday Textfield.text into a date object
        
        guard let birthdayText = birthdayTextField.text  else { return }
        
        // lets perform the validation step here
        
        if birthdayText.isEmpty {
            showError(title: "Empty Birthday", message: "You hav not entered a birthday.")
            return
        }
        
        let dateFormateer = DateFormatter()
        dateFormateer.dateFormat = "MM/dd/yyyy"
        
        guard let birthdayDate = dateFormateer.date(from: birthdayText) else {
            showError(title: "Invalid Date", message:  "Birthday date entered valid. Please write to birthday as MM/dd/yyyy type!")
            return
        }
        
        
        guard let employeeType =  employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }
        print(employeeType)
//
//        print(birthdayText)
//
//        print(birthdayDate)
//
        //where do wet company from?
        
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, employeeType: employeeType, birthday: birthdayDate, company: company)
        if let error = tuple.1 {
            // is where you present error modal of some kind
            // perhaps use a UIAlertController to show your error message
            print(error)
        }else {
            // creation success
            dismiss(animated: true) {
                // we will call delegate somehow
                self.delegate?.didAddEmployee(employee: tuple.0!)
            }
            dismiss(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
        return
    }
    
    let employeeTypeSegmentedControl: UISegmentedControl = {
    
        let types = [
            EmployeeType.Executive.rawValue,
            EmployeeType.SeniorManagement.rawValue,
            EmployeeType.Staff.rawValue,
            EmployeeType.Intern.rawValue
        ]
        let sc = UISegmentedControl(items: types)
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
      private func setupUI(){
         
          _ = setupLightBlueBackgroundView(height: 150)
          
          view.addSubview(nameLabel)
          nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 108).isActive = true
          nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
          nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
          nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
          nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
         
          view.addSubview(nameTextField)
          nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
          nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
          nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
          nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
          
          view.addSubview(birthdayLabel)
          birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
          birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
          birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
          birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
          birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
          
          view.addSubview(birthdayTextField)
          birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
          birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
          birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
          birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
          
          view.addSubview(employeeTypeSegmentedControl)
          employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
          employeeTypeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
          employeeTypeSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
          employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
        }
    }

