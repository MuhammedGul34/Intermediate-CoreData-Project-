//
//  CustomMigrationPolicy.swift
//  IntermediateTraining
//
//  Created by Muhammed Gül on 3.12.2022.
//

import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    // type are transformation function here in a just bit
    
    @objc func transformNumEmployees(forNum : NSNumber) -> String {
        if forNum.intValue < 150 {
            return "small"
        } else {
            return "very large"
        }
    }
}
