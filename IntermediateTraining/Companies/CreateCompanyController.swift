//
//  CreateCompanyController.swift
//  IntermediateTraining
//
//  Created by Muhammed Gül on 24.11.2022.
//

import UIKit
import CoreData

// Custom Delegation

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
            
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
                setupCircularImageStyle()
            }
            
            guard let founded = company?.founded else {return}
            datePicker.date = founded
        }
    }
    
    private func setupCircularImageStyle(){
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
        companyImageView.layer.borderWidth = 2
        
    }
    var delegate: CreateCompanyControllerDelegate?

    lazy var companyImageView : UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "select_photo_empty"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return imageView
    }()
    
    @objc private func handleSelectPhoto(){
        print("Trying to select photo......")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            companyImageView.image = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        
        setupCircularImageStyle()
        
        dismiss(animated: true, completion: nil)
    }
    
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
    
    let datePicker : UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        dp.translatesAutoresizingMaskIntoConstraints = false
        
        return dp
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ternary syntax
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupCancelButton()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        view.backgroundColor = .darkBlue
     
        navigationItem.title = "Create Company"
        
        
        }
    
    @objc private func handleSave(){
        print("Trying to save company...")
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
  
    }
    
    private func saveCompanyChanges(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company?.imageData = imageData
        }
        
        
        do {
            try context.save()
            dismiss(animated: true, completion: {
                self.delegate?.didEditCompany(company: self.company!)
            })
            
        }catch let saveErr {
            print("Failed to save company changes",saveErr)
        }
    }
    
    private func createCompany(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company.setValue(imageData, forKey: "imageData")
        }
        do {
           try context.save()
            
            // success
            dismiss(animated: true, completion: {
                self.delegate?.didAddCompany(company: company as! Company)
            })
        } catch let saveErr {
            print("Failed to save Company :",saveErr)
        }
    }
    
    private func setupUI(){
        let lightBlueBackgroundView = setupLightBlueBackgroundView(height: 350)
                
        view.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 116).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        view.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
       
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true
        }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
        }
    
    
    }


