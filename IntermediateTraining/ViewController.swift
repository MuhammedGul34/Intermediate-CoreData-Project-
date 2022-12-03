//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Muhammed Gül on 23.11.2022.
//

import UIKit





class CompaniesController: UITableViewController {
    
    let companies = [
        Company(name: "Apple", founded: Date()),
        Company(name: "Google", founded: Date()),
        Company(name: "Facebook", founded: Date())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        view.backgroundColor = .white

        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
        //tableView.separatorEffect = .none
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView() // blank UIView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        setupNavigationStyle()
       
        
    }
    
    
   @objc func handleAddCompany(){
        print("Adding company...")
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .LightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
       
        cell.backgroundColor = .teal
        
        let company = companies[indexPath.row]
        
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func setupNavigationStyle(){
        
    
        navigationController?.navigationBar.backgroundColor = .lightRed
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
       
    }
  
}

