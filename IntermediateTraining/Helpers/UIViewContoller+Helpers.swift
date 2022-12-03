//
//  UIViewContoller+Helpers.swift
//  IntermediateTraining
//
//  Created by Muhammed Gül on 28.11.2022.
//

import UIKit

extension UIViewController {
    //are my extension/helper methods
    
    func setupPlusButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    @objc func handleCancelModal(){
        dismiss(animated: true, completion: nil)
    }
    
    func setupLightBlueBackgroundView(height: CGFloat) -> UIView {
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = UIColor.LightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueBackgroundView)
        
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108).isActive = true
        lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return lightBlueBackgroundView
    }
}
