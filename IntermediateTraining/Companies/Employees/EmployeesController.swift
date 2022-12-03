//
//  EmployeesController.swift
//  IntermediateTraining
//
//  Created by Muhammed Gül on 28.11.2022.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    // remember this is called when we dismissemployee creation
    func didAddEmployee(employee: Employee) {
//        employees.append(employee)
//        fetchEmployees()
//        tableView.reloadData()
//
//        what is the insertion index path
        // first index of programdan farklı olarak yapıldı
        guard let section = employeeTypes.firstIndex(of: employee.type!) else { return }
        
        // what is my row
        
        let row = allEmployees[section].count
        
        let insertionIndexPath = IndexPath(row: row, section: section)
        
        allEmployees[section].append(employee)
        
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
    
    var company : Company?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
//        if section == 0 {
//            label.text = EmployeeType.Executive.rawValue
//        } else if section == 1 {
//            label.text = EmployeeType.SeniorManagement.rawValue
//        } else {
//            label.text = EmployeeType.Staff.rawValue
//        }
        
        label.text = employeeTypes[section]
        
        label.backgroundColor = UIColor.LightBlue
        label.textColor = UIColor.darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    var allEmployees = [[Employee]]()
    
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue,
        EmployeeType.Intern.rawValue
    ]
    
    private func fetchEmployees(){
        
    guard let companyEmployees = company?.employees?.allObjects as? [Employee] else {return}
        
        allEmployees = []
        //let s use my array and loop to filter instead
        
        employeeTypes.forEach { employeeType in
            // somehow construct my allemployees array
            allEmployees.append(
                companyEmployees.filter { $0.type == employeeType }
            )
        }
        // let filter employees for "Executives"
//        let executives = companyEmployees.filter { employee in
//            return employee.type == EmployeeType.Executive.rawValue
//        }
//        
//        let seniorManagement = companyEmployees.filter { $0.type == EmployeeType.SeniorManagement.rawValue}
//        
//        allEmployees = [
//        executives,
//        seniorManagement,
//        companyEmployees.filter { $0.type == EmployeeType.Staff.rawValue }
//        ]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
//        if indexPath.section == 0 {
//            emloyee = shortNameEmployees
//        }
//        // i will use  a ternary operator
//        let employee = employees[indexPath.row]
//        let employee = indexPath.section == 0 ? shortNameEmployees[indexPath.row] : longNameEmployees[indexPath.row]
//
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = employee.name
        
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "MMM dd, yyyy"
            
            cell.textLabel?.text = "\(employee.name ?? "")   \(dateFormater.string(from: birthday))"
        }
        
//        if let taxId = employee.employeeInformation?.taxId {
//            cell.textLabel?.text = "\(employee.name ?? "")   \(taxId)"
//        }
        
        cell.backgroundColor = UIColor.teal
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allEmployees[section].count
//        if section == 0 {
//            return shortNameEmployees.count
//        }
//        return longNameEmployees.count
    }
    
    let cellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEmployees()
        
        tableView.backgroundColor = UIColor.darkBlue
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
    }
    @objc private func handleAdd(){
        
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    }
}
