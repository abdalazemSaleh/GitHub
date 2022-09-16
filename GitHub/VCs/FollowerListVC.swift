//
//  FollowerListVC.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-15.
//

import UIKit

class FollowerListVC: UIViewController {

    var userName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true 
    }

    override func viewWillAppear(_ animated: Bool) { 
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
