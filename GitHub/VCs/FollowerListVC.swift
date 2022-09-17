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
        
        NetworkManger.share.getFollowers(for: userName, page: 1) { [weak self] result in
            switch result {
            case .success(let followers):
                print("followers number = \(followers.count)")
            case .failure(let error):
                self?.presentGFAlert(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "OK")
            }
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) { 
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
