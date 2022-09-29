//
//  UserInfoVC.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-24.
//

import UIKit

protocol userInfoVCDelegate {
    func didTapGitHubProfile(for user: User)
    func didTapGitFollowers(for user: User)
}

class UserInfoVC: UIViewController {

    // MARK: - Variables
    let headerView  = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel   = GFBodyLabel(textAlignment: .center)
    
    var itemViews: [UIView] = []
    var username: String!
    weak var delegate: followerListVCDelegate!  
    
    // MARK: - View didload
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        getUserInfo()
        layoutUI()
    }
    
    // MARK: - Configure functions
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButon = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismisVC))
        navigationItem.rightBarButtonItem = doneButon
    }
    
    func configureUIElements(with user: User) {
        
        let repoItemVC          = GFRepoItemVC(user: user)
        repoItemVC.delegate     = self

        let followerItemVC      = GFFollowerItemVC(user: user)
        followerItemVC.delegate = self
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: followerItemVC, to: self.itemViewOne)
        self.add(childVC: repoItemVC, to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"

    }
    // MARK: - Functions
    /// Get user info
    func getUserInfo() {
        NetworkManger.share.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
            case .failure(let error):
                self.presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    /// Layout UI
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        } 
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    /// Add container view controller to UserInfoVC
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    /// dismis view controller while clicking done button
    @objc func dismisVC() {
        dismiss(animated: true)
    }
}

extension UserInfoVC: userInfoVCDelegate {
    
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else { return presentGFAlert(title: "Invalid URL", message: "The url is invalid", buttonTitle: "OK") }
        presentSafariVC(with: url)
    }
    
    func didTapGitFollowers(for user: User) {
        guard user.followers != 0  else { return presentGFAlert(title: "No followers", message: "This user has no followers. What shame.😔", buttonTitle: "So sad") }
        delegate.requestFollower(for: user.login)
        dismisVC()
    }
}
