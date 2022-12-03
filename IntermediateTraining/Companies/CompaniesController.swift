//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Muhammed Gül on 23.11.2022.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies = [Company]() // empty array
    
    @objc  private func doWork(){
        print("Trying to do work")
        CoreDataManager.shared.persistentContainer.performBackgroundTask { backgroundContext in
            (0...5).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            
            }
            do {
                try   backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
                
            } catch let err {
                print("Failed to save:", err)
            }
        }
        DispatchQueue.global(qos: .background).async
        {}
    }

    @objc private func doUpdates(){
        print("Trying to update companies on a background context")
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask { backgroundContext in
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            
            
            do {
                let companies = try backgroundContext.fetch(request)
                
                companies.forEach { company in
                    print(company.name ?? "")
                    company.name = "C: \(company.name ?? "")"
                }
                
                do {
                    try backgroundContext.save()
        
                    DispatchQueue.main.async {
  
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
  
                        self.companies = CoreDataManager.shared.fetchCompanies()
    
                        self.tableView.reloadData()

                    }
                } catch let saveErr {
                    print("Failed to save on background", saveErr)
                }
            } catch let err {
                print("Failed to fetch companies on background", err)
            }
           
        }
    }
    
   @objc private func nestedUpdates(){
        print("trying to perform nested updates now...")
       
       DispatchQueue.global(qos: .background).async {

           let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
           
           privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
           
           let request : NSFetchRequest<Company> = Company.fetchRequest()
           request.fetchLimit = 1
           do {
               let companies = try privateContext.fetch(request)
               
               companies.forEach { company in
                   print(company.name ?? "")
                   company.name = "D: \(company.name ?? "")"
               }
               do {
                   try privateContext.save()

                   DispatchQueue.main.async {
                   do {
                       
                       let context = CoreDataManager.shared.persistentContainer.viewContext
                       if context.hasChanges {
                          try context.save()
                       }
                       
                   } catch let finalSaveErr {
                       print("Failed to save main context:",finalSaveErr)
                   }
                       
                       self.tableView.reloadData()
                   }
                   
               } catch let saveErr {
                   print("Failed to save private Context:", saveErr)
               }
               
               
           } catch let fetchErr {
               print("Failed to fetch on private context:", fetchErr)
           }
           
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.companies = CoreDataManager.shared.fetchCompanies()
  
        navigationItem.leftBarButtonItems = [
             UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
             UIBarButtonItem(title: "Nested Updates", style: .plain, target: self, action: #selector(nestedUpdates))
        ]
        
        view.backgroundColor = .white
        navigationItem.title = "Companies"
        
    
        tableView.backgroundColor = .darkBlue
        //tableView.separatorEffect = .none
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView() // blank UIView
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellid")
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
    }
    
    @objc private func handleReset(){
        print("Attemping to delete all dcore data objects")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            var indexPathsToRemove = [IndexPath]()
            
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
        } catch let delErr {
            print("Failed to delete objects from core data", delErr)
        }
    }
    
   @objc func handleAddCompany(){

        let createCompanyContoller = CreateCompanyController()
    
       let navController = CustomNavigationController(rootViewController: createCompanyContoller)
       
       createCompanyContoller.delegate = self
       
       present(navController, animated: true, completion: nil)
    }
}

