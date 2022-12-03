//
//  CompanyCell.swift
//  IntermediateTraining
//
//  Created by Muhammed Gül on 28.11.2022.
//

import UIKit

class CompanyCell : UITableViewCell {
    var company: Company?{
        didSet {
            nameFoundedDateLabel.text = company?.name
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            if let name = company?.name, let founded = company?.founded {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "MMM dd, yyyy"
                
                let foundedDateString = dateFormater.string(from: founded)
                let dateString = "\(name) - Founded: \(foundedDateString)"
                
                nameFoundedDateLabel.text = dateString
            } else {
                nameFoundedDateLabel.text = company?.name
            }
        }
    }
  
    let companyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "select_photo_empty"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let nameFoundedDateLabel : UILabel = {
        let label = UILabel()
        label.text = "COMPANY NAME"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .teal
        
        addSubview(companyImageView)
        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameFoundedDateLabel)
        nameFoundedDateLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8).isActive = true
        nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
