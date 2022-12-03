//
//  CompaniesController+CreateCompany.swift
//  IntermediateTraining
//
//  Created by Muhammed Gül on 28.11.2022.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate  {
    func didEditCompany(company: Company) {
    
        let row = companies.index(of: company)
        
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newindexPAth = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newindexPAth], with: .automatic)
    }
}
