//  Created by dasdom on 11/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import DDHFoundation
import Roaster

class PostCell: UICollectionViewCell {
    
    let avatarImageView: UIImageView
    let usernameLabel: UILabel
    let textLabel: UILabel
    let sourceLabel: UILabel
    
    override init(frame: CGRect) {
        
        avatarImageView = DDHImageView()
        
        usernameLabel = DDHLabel()
        usernameLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        
        textLabel = DDHLabel()
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        sourceLabel = DDHLabel()
        sourceLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        let spacerView = DDHView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.backgroundColor = AppColors.gray
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(textLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(spacerView)
        
        let screenBounds = UIScreen.main.bounds
        let avatarLeading: CGFloat = 8
        let avatarTop: CGFloat = 8
        let avatarWidth: CGFloat = 60
        let usernameLeading: CGFloat = avatarLeading
        let textLabelTrailing: CGFloat = avatarLeading
        let textLabelTop: CGFloat = 5
        let textLabelBottom: CGFloat = textLabelTop
        let sourceLabelBottom: CGFloat = avatarTop + 2
        let spacerWidth: CGFloat = 200
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: avatarLeading),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: avatarTop),
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarWidth),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: usernameLeading),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textLabelTrailing),
            textLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: textLabelTop),
            textLabel.bottomAnchor.constraint(equalTo: sourceLabel.topAnchor, constant: -textLabelBottom),
            sourceLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
            sourceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -sourceLabelBottom),
            spacerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            spacerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spacerView.widthAnchor.constraint(equalToConstant: spacerWidth),
            spacerView.heightAnchor.constraint(equalToConstant: 0.5),
            contentView.widthAnchor.constraint(equalToConstant: screenBounds.width)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with post: Post) {
        if let user = post.user, let username = user.username {
            usernameLabel.text = username
            
            self.avatarImageView.image = nil
            if let userContent = user.content, let avatarImage = userContent.avatarImage, let link = avatarImage.link, let url = URL(string: link) {
                let apiClient = APIClient(userDefaults: UserDefaults())
                apiClient.data(url: url) { result in
                    if case .success(let data) = result {
                        if let image = UIImage(data: data), self.usernameLabel.text == username {
                            self.avatarImageView.image = image
                            self.setNeedsDisplay(self.avatarImageView.frame)
                        }
                    }
                }
            }
        }
        
        if let content = post.content, let text = content.text {
            let attributedText = NSMutableAttributedString(string: text)
            
            if let mentions = content.mentions {
                for mention in mentions {
                   attributedText.addAttribute(NSForegroundColorAttributeName, value: AppColors.mention, range: NSMakeRange(Int(mention.pos), Int(mention.len)))
                }
            }
            
            if let links = content.links {
                for link in links {
                    attributedText.addAttribute(NSForegroundColorAttributeName, value: AppColors.link, range: NSMakeRange(Int(link.pos), Int(link.len)))
                }
            }
            
            if let tags = content.tags {
                for tag in tags {
                    attributedText.addAttribute(NSForegroundColorAttributeName, value: AppColors.tag, range: NSMakeRange(Int(tag.pos), Int(tag.len)))
                }
            }
            
            textLabel.attributedText = attributedText
        }
        
        if let sourceName = post.sourceName {
            sourceLabel.text = "via \(sourceName)"
        }
    }
}
