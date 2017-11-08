//  Created by dasdom on 11/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.cd
//

import UIKit
import DDHFoundation
import Roaster

class PostCell: UITableViewCell {
    
    let avatarImageView: DDHImageView
    fileprivate let buttonStackView: UIStackView
    fileprivate let expandedSourceLabelBottom: CGFloat = 30
    let followsYouIndicatorView: UIView
//    let followsYouLabel: UILabel
    let postTextView: DDHTextView
    let profileButton: DDHButton
    let replyButton: DDHButton
    let threadButton: DDHButton
    let sourceLabel: DDHLabel
    fileprivate let sourceLabelBottom: CGFloat = 7
    var stackViewBottomConstraint: NSLayoutConstraint?
    let timeLabel: DDHLabel
    let usernameLabel: DDHLabel
    let youFollowIndicatorView: UIView
    
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
        timeLabel.textAlignment = .right
        
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
        replyButton.setImage(#imageLiteral(resourceName: "reply"), for: .normal)
        replyButton.addTarget(nil, action: .reply, for: .touchUpInside)
        
        profileButton = DDHButton(type: .system)
        profileButton.setImage(#imageLiteral(resourceName: "showProfile"), for: .normal)
        profileButton.addTarget(nil, action: .showProfile, for: .touchUpInside)
        
        threadButton = DDHButton(type: .system)
        threadButton.setImage(#imageLiteral(resourceName: "showThread"), for: .normal)
        threadButton.addTarget(nil, action: .showThread, for: .touchUpInside)
        
        buttonStackView = UIStackView(arrangedSubviews: [replyButton, threadButton, profileButton])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.isHidden = true
        buttonStackView.distribution = .fillEqually
        
        followsYouIndicatorView = UIView()
        youFollowIndicatorView = UIView()
//        followsYouLabel = UILabel()
//        followsYouLabel.text = "follows you"
//        followsYouLabel.font = UIFont.systemFont(ofSize: 10)
//        followsYouLabel.textColor = AppColors.lightGray
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white
        selectionStyle = .none
        clipsToBounds = true

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: .tap))

        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(postTextView)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(buttonStackView)
        contentView.addSubview(followsYouIndicatorView)
        contentView.addSubview(youFollowIndicatorView)
//        contentView.addSubview(followsYouLabel)
        
        stackViewBottomConstraint = buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        guard let stackViewBottomConstraint = stackViewBottomConstraint else { fatalError() }
        stackViewBottomConstraint.constant = 30
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackViewBottomConstraint
            ])
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with post: Post, forPresentation: Bool = true) {
        
        guard post.isDeleted == false else { return }
        
        setUserInfo(for: post, forPresentation: forPresentation)
        setText(for: post)
        
        if let sourceName = post.sourceName {
            sourceLabel.text = "via \(sourceName)"
        }
        
        if forPresentation {
            setDateInfo(for: post)
        }
        
        layout(forPresentation: forPresentation)
        
        buttonStackView.isHidden = !post.isSelected
        
        youFollowIndicatorView.backgroundColor = post.user?.youFollow ?? false ? AppColors.youFollow : AppColors.background
        followsYouIndicatorView.backgroundColor = post.user?.followsYou ?? false ? AppColors.followsYou : AppColors.background
//        followsYouLabel.isHidden = !(post.user?.followsYou ?? false)
    }
    
    func setUserInfo(for post: Post, forPresentation: Bool) {
        
        if let user = post.user, let username = user.username {
            usernameLabel.text = username
            
            self.avatarImageView.image = nil
            
            guard forPresentation else { return }
            
            if let userContent = user.content, let avatarImage = userContent.avatarImage, let link = avatarImage.link, let url = URL(string: link) {
                
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
    }
    
    func setText(for post: Post) {
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
    }
    
    func setDateInfo(for post: Post) {
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
    
    func tap(sender: UITapGestureRecognizer) {
        guard let target = target(forAction: .tap, withSender: sender) as AnyObject? else { return }
        _ = target.perform(.tap, with: sender)
    }
}

extension PostCell {
    
    func layout(forPresentation: Bool) {
        let avatarX: CGFloat = 8
        let avatarTop: CGFloat = 8
        let avatarWidth: CGFloat = 60
        
        let screenBounds = UIScreen.main.bounds

        usernameLabel.frame = CGRect(x: avatarX + avatarWidth + 8, y: avatarTop, width: screenBounds.width * 0.6, height: 0)
        usernameLabel.sizeToFit()
        
        if forPresentation {
            let avatarFrame = CGRect(x: avatarX, y: avatarTop, width: avatarWidth, height: avatarWidth)
            avatarImageView.frame = avatarFrame
            
            timeLabel.autoresizingMask = [.flexibleLeftMargin]
            timeLabel.sizeToFit()
            timeLabel.frame.origin = CGPoint(x: screenBounds.width - timeLabel.frame.size.width - 8, y: usernameLabel.frame.minY)

            followsYouIndicatorView.frame = CGRect(x: avatarFrame.midX - 2 - 4, y: avatarFrame.maxY + 2, width: 4, height: 4)
            followsYouIndicatorView.layer.cornerRadius = 2
            youFollowIndicatorView.frame = CGRect(x: avatarFrame.midX + 2, y: followsYouIndicatorView.frame.minY, width: followsYouIndicatorView.frame.width, height: followsYouIndicatorView.frame.height)
            youFollowIndicatorView.layer.cornerRadius = 2
//            followsYouLabel.frame = CGRect(x: avatarFrame.minX, y: avatarFrame.maxY + 2, width: avatarFrame.width, height: 10)
        }
        
        let postTextWidth = screenBounds.width - 3 * 8 - avatarWidth
//        postTextView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let size = postTextView.sizeThatFits(CGSize(width: postTextWidth, height: CGFloat.greatestFiniteMagnitude))
        postTextView.frame = CGRect(x: usernameLabel.frame.minX, y: usernameLabel.frame.maxY + 5, width: postTextWidth, height: size.height)
        
        sourceLabel.frame = CGRect(x: usernameLabel.frame.minX, y: postTextView.frame.maxY + 5, width: 0, height: 0)
        sourceLabel.sizeToFit()
        
    }
}

extension PostCell {
    func showButtons() {
        self.buttonStackView.isHidden = false
        stackViewBottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.buttonStackView.alpha = 1.0
            self.layoutIfNeeded()
        })
    }
    
    func hideButtons() {
        self.buttonStackView.isHidden = false
        stackViewBottomConstraint?.constant = 30
        UIView.animate(withDuration: 0.2, animations: {
            self.buttonStackView.alpha = 0.0
            self.layoutIfNeeded()
        }) { finished in
            self.buttonStackView.isHidden = true
        }
    }
}

@objc protocol CellActionsProtocol {
    @objc func reply(sender: UIButton)
    @objc func showProfile(sender: UIButton)
    @objc func tap(sender: UITapGestureRecognizer)
    @objc func showThread(sender: UIButton)
}

fileprivate extension Selector {
    static let reply = #selector(CellActionsProtocol.reply(sender:))
    static let showProfile = #selector(CellActionsProtocol.showProfile(sender:))
    static let tap = #selector(CellActionsProtocol.tap(sender:))
    static let showThread = #selector(CellActionsProtocol.showThread(sender:))
}
