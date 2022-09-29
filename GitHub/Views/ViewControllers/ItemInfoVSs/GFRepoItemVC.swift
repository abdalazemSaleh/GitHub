//
//  GFRepoItemVC.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-26.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    // MARK: - Configure Functions
    private func configureItems() {
        itemInfoViewOne.set(ItemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(ItemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTaped() {
        delegate.didTapGitHubProfile(for: user)
    }
    
}
