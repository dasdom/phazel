//  Created by dasdom on 11/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import DDHFoundation
import Roaster

class PostCell: UITableViewCell {
    
    let avatarImageView: DDHImageView
    let usernameLabel: DDHLabel
    let postTextView: DDHTextView
    let sourceLabel: DDHLabel
    let timeLabel: DDHLabel
    let replyButton: DDHButton
    fileprivate let buttonStackView: UIStackView
//    var bottomConstraint: NSLayoutConstraint?
    var stackViewBottomConstraint: NSLayoutConstraint?
    fileprivate let sourceLabelBottom: CGFloat = 7
    fileprivate let expandedSourceLabelBottom: CGFloat = 30
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        avatarImageView = DDHImageView()
        avatarImageView.makeScrollFastOn(backgroundColor: AppColors.background)
        
        usernameLabel = DDHLabel()
        usernameLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        usernameLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        usernameLabel.makeScrollFastOn(backgroundColor: AppColors.background)
        
        timeLabel = DDHLabel()
        timeLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        timeLabel.makeScrollFastOn(backgroundColor: AppColors.background)
        
        postTextView = DDHTextView()
        postTextView.font = UIFont.preferredFont(forTextStyle: .body)
        postTextView.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        postTextView.isScrollEnabled = false
        postTextView.isEditable = false
        postTextView.isUserInteractionEnabled = false
        postTextView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
        postTextView.makeScrollFastOn(backgroundColor: AppColors.background)
        
        sourceLabel = DDHLabel()
        sourceLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        sourceLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        sourceLabel.makeScrollFastOn(backgroundColor: AppColors.background)
        
        replyButton = DDHButton(type: .system)
        replyButton.setTitle("Reply", for: .normal)
        replyButton.addTarget(nil, action: .reply, for: .touchUpInside)
        
        buttonStackView = UIStackView(arrangedSubviews: [replyButton])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.isHidden = true
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white
        selectionStyle = .none
        clipsToBounds = true
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(postTextView)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(buttonStackView)
        
        let avatarLeading: CGFloat = 8
        let avatarTop: CGFloat = 8
        let avatarWidth: CGFloat = 60
        let usernameLeading: CGFloat = avatarLeading
        let textLabelTrailing: CGFloat = avatarLeading
        let textLabelTop: CGFloat = 5
        let textLabelBottom: CGFloat = textLabelTop
        
//        bottomConstraint = sourceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -sourceLabelBottom)
//        guard let bottomConstraint = bottomConstraint else { fatalError() }
//        bottomConstraint.priority = 999
        
        stackViewBottomConstraint = buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        guard let stackViewBottomConstraint = stackViewBottomConstraint else { fatalError() }
        stackViewBottomConstraint.constant = 30
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: avatarLeading),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: avatarTop),
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarWidth),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: usernameLeading),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textLabelTrailing),
            timeLabel.topAnchor.constraint(equalTo: usernameLabel.topAnchor),
            postTextView.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            postTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textLabelTrailing),
            postTextView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: textLabelTop),
            postTextView.bottomAnchor.constraint(equalTo: sourceLabel.topAnchor, constant: -textLabelBottom),
            sourceLabel.leadingAnchor.constraint(equalTo: postTextView.leadingAnchor),
//            bottomConstraint,
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackViewBottomConstraint
            ])
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with post: Post, loadImage: Bool = true) {
        if let user = post.user, let username = user.username {
            usernameLabel.text = username
            
            self.avatarImageView.image = nil
            if let userContent = user.content, let avatarImage = userContent.avatarImage, let link = avatarImage.link, let url = URL(string: link), loadImage {
               
                let apiClient = APIClient(userDefaults: UserDefaults())
                apiClient.imageData(url: url) { result in
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
            
            attributedText.addAttribute(NSFontAttributeName, value: UIFont.preferredFont(forTextStyle: .body), range: NSMakeRange(0, attributedText.length))
            postTextView.attributedText = attributedText
        }
        
        if let sourceName = post.sourceName {
            sourceLabel.text = "via \(sourceName)"
        }
        
        if let creationDate = post.creationDate {
            var value = 0
            let timeInterval = -Int(creationDate.timeIntervalSinceNow)
            value = timeInterval/60
            if value < 60 {
                timeLabel.text = "\(value)m"
            } else {
                value = timeInterval / 3600
                if value < 60 {
                    timeLabel.text = "\(value)h"
                } else {
                    value = timeInterval / (24*3600)
                    timeLabel.text = "\(value)d"
                }
            }
        }
    }
}

extension PostCell {
    func toggleExpansion() {
//        guard let constant = bottomConstraint?.constant else { fatalError() }
//        let compress = constant < -sourceLabelBottom
//        self.buttonStackView.isHidden = false
//        bottomConstraint?.constant = compress ? -sourceLabelBottom : -expandedSourceLabelBottom
//        stackViewBottomConstraint?.constant = compress ? buttonStackView.frame.size.height : 0
//        self.buttonStackView.alpha = compress ? 1.0 : 0.0
//        UIView.animate(withDuration: 0.2, animations: {
//            self.layoutIfNeeded()
//            self.buttonStackView.alpha = compress ? 0.0 : 1.0
//        }) { (finished) in
//            self.buttonStackView.isHidden = compress
//        }
    }
}

@objc protocol CellActionsProtocol {
    @objc func reply(sender: UIButton)
}

fileprivate extension Selector {
    static let reply = #selector(CellActionsProtocol.reply(sender:))
}
