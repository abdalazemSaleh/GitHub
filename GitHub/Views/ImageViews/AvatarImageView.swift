//
//  AvatarImageView.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-18.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    /// Variables
    let cash                = NetworkManger.share.cach
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
    
    /// Download image function
    func downloadImage(from urlString: String) {
        
        let cashKey = NSString(string: urlString)
        
        if let image = cash.object(forKey: cashKey) {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self ] data, response, error in
            
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200  else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            self.cash.setObject(image, forKey: cashKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
            
        }
        task.resume()
        
        
    }

}
