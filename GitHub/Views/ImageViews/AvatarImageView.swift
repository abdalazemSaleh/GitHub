//
//  AvatarImageView.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-18.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    /// Variables
    let placeholderImage    = UIImage(named: "avatar-placeholder")!

    /// Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configure function
    private func configure() {
        layer.cornerRadius  = 10
        clipsToBounds       = true
        image               = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
