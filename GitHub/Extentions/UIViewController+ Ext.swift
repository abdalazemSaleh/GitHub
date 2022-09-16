//
//  UIViewController+ Ext.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-15.
//

import UIKit


extension UIViewController {
    
    func presentGFAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
}
