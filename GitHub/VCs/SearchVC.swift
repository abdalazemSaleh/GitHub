//
//  SearchVC.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-13.
//

import UIKit

class SearchVC: UIViewController {
    
    // MARK: - Variables
    let logoImageView = UIImageView()
    let userNameTF = GFTextField()
    let searchButton = GFButton(backgroundColor:  .systemGreen, title: "Get Followers")
    var logoImageViewTopConstraint: NSLayoutConstraint!
    
    var isUserNameEnterd: Bool { return !userNameTF.text!.isEmpty }
    
    // MARK: - View didload
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureUserNameTF()
        configureSearchButton()
        createDismissKeyBoardTapGesture()
    }
    
    // MARK: - View willAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTF.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Functions
    /// Create dismiss keyboard tap gesture
    func createDismissKeyBoardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    /// Push follower list view controller
    @objc func pushFollowerListVC() {
        guard  isUserNameEnterd else {
            presentGFAlert(title: "Empty Username", message: "Please enter Username. We need to know who to look for 😄.", buttonTitle: "OK")
            return
        }
        
        userNameTF.resignFirstResponder()
        
        let vc = FollowerListVC(username: userNameTF.text!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Configure logo image
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    /// Configure user name
    func configureUserNameTF() {
        view.addSubview(userNameTF)
        userNameTF.delegate = self
        
        NSLayoutConstraint.activate([
            userNameTF.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            userNameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            userNameTF.heightAnchor.constraint(equalToConstant: 48)
        ])
        
    }
    
    /// Configure search button
    func configureSearchButton() {
        view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            searchButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
}


extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
}
