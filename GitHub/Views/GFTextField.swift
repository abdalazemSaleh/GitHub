//
//  GFTextField.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-14.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius              = 8
        layer.borderWidth               = 2
        layer.borderColor               = UIColor.systemGray4.cgColor
        
        textColor                       = .label
        tintColor                       = .label
        textAlignment                   = .center
        
        backgroundColor                 = .tertiarySystemBackground
        minimumFontSize                 = 12
        autocorrectionType              = .no
        returnKeyType                   = .go
        
        placeholder                     = "Enter a user name"
        
        font                            = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth       = true
        
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
