//  Created by dasdom on 04.06.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import DDHFoundation
import Roaster

final class ProfileHeaderView: UIView {
    
//    let stackView: UIStackView
    let avatarImageView: DDHImageView
    let followButton: UIButton
    let usernameLabel: UILabel
    let nameLabel: UILabel
    let bioLabel: UILabel
    let followersButton: UIButton
    let followingButton: UIButton
    
    override init(frame: CGRect) {
        
        avatarImageView = DDHImageView()
        
        let settingsHostView = UIView()
        let followButtonHostView = UIView()
        
        followButton = UIButton(type: .system)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.layer.cornerRadius = 5
        followButton.layer.borderColor = AppColors.tint.cgColor
        followButton.layer.borderWidth = 1
        followButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        followButton.addTarget(nil, action: .follow, for: .touchUpInside)
        
        followButtonHostView.addSubview(followButton)
        
        let avatarStackView = UIStackView(arrangedSubviews: [settingsHostView, avatarImageView, followButtonHostView])
        avatarStackView.distribution = .fillEqually
        
        nameLabel = DDHLabel()
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        nameLabel.textAlignment = .center
        
        usernameLabel = DDHLabel()
        usernameLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        usernameLabel.textAlignment = .center
        
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        nameStackView.axis = .vertical
        
        bioLabel = DDHLabel()
        bioLabel.numberOfLines = 0
        bioLabel.textAlignment = .center
        bioLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        let infoStackView = UIStackView(arrangedSubviews: [avatarStackView, nameStackView, bioLabel])
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = 5
        
        let infoHostView = UIView()
        infoHostView.addSubview(infoStackView)
        
        followersButton = UIButton(type: .custom)
        followersButton.backgroundColor = AppColors.lightGray
        
        followingButton = UIButton(type: .custom)
        followingButton.backgroundColor = AppColors.lightGray
        
        let buttonStackView = UIStackView(arrangedSubviews: [followersButton, followingButton])
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 1
        
        let stackView = UIStackView(arrangedSubviews: [infoHostView, buttonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: infoHostView.leadingAnchor, constant: 5),
            infoStackView.trailingAnchor.constraint(equalTo: infoHostView.trailingAnchor, constant: -5),
            infoStackView.topAnchor.constraint(equalTo: infoHostView.topAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: infoHostView.bottomAnchor),
            followButton.centerXAnchor.constraint(equalTo: followButtonHostView.centerXAnchor),
            followButton.centerYAnchor.constraint(equalTo: followButtonHostView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor)
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
        } else {
            if let userContent = user.content, let avatarImage = userContent.avatarImage, let link = avatarImage.link, let url = URL(string: link) {
                
                let apiClient = APIClient(userDefaults: UserDefaults())
                apiClient.imageData(url: url) { result in
                    if case .success(let data) = result {
                        if let image = UIImage(data: data) {
                            self.avatarImageView.image = image
                            self.setNeedsDisplay(self.avatarImageView.frame)
                        }
                    }
                }
            }
        }

        if let username = user.username {
            usernameLabel.text = "@\(username)"
        }
        
        if let name = user.name {
            nameLabel.text = name
        }
        
        if let bio = user.content?.text {
            bioLabel.text = bio
        }
        
        followersButton.setTitle("\(user.numberOfFollowers) Followers", for: .normal)
        followingButton.setTitle("\(user.numberOfFollowing) Following", for: .normal)
        
        updateFollowButton(with: user)
    }
    
    func updateFollowButton(with user: User) {
        if user.youFollow {
            followButton.setTitle("Unfollow", for: .normal)
            followButton.backgroundColor = AppColors.red
            followButton.tintColor = AppColors.white
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = AppColors.clear
            followButton.tintColor = AppColors.tint
        }
    }
}

@objc protocol ProfileActionsProtocol {
    @objc func follow()
}

fileprivate extension Selector {
    static let follow = #selector(ProfileActionsProtocol.follow)
}
