//  Created by dasdom on 04.06.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import DDHFoundation

class ProfileHeaderView: UIView {
    
    let stackView: UIStackView
    let avatarImageView: DDHImageView
    let usernameLabel: UILabel
    let nameLabel: UILabel
    
    override init(frame: CGRect) {
        
        avatarImageView = DDHImageView()
        
        usernameLabel = DDHLabel()
        
        nameLabel = DDHLabel()
        
        stackView = UIStackView(arrangedSubviews: [avatarImageView, usernameLabel, nameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileHeaderView {
    func update(with user: User) {
        if let avatarImage = user.content?.avatarImage?.image {
            avatarImageView.image = avatarImage
        }

        if let username = user.username {
            usernameLabel.text = "@\(username)"
        }
        
        if let name = user.name {
            nameLabel.text = name
        }
    }
}
