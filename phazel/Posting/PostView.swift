//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class PostView: DDHView {
    
    let textView: DDHTextView
    let sendButton: DDHButton
    fileprivate let countLabel: UILabel
    fileprivate let stackView: UIStackView
    
    override init(frame: CGRect) {
        
        textView = DDHTextView()
        textView.backgroundColor = UIColor.background
        textView.textColor = UIColor.white
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        
        countLabel = DDHLabel()
        countLabel.backgroundColor = UIColor.background
        countLabel.textColor = UIColor.lightGray
        countLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        countLabel.textAlignment = .right
        countLabel.text = "256"
        
        sendButton = DDHButton(type: .system)
        sendButton.addTarget(nil, action: .send, for: .touchUpInside)
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
//        sendButton.backgroundColor = UIColor.buttonBackground
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        sendButton.isEnabled = false
        
        let countStackView = UIStackView(arrangedSubviews: [countLabel])
        countStackView.alignment = .top
        
        let topStackView = UIStackView(arrangedSubviews: [textView, countStackView])
        
        let sendButtonStackView = UIStackView(arrangedSubviews: [sendButton])
        sendButtonStackView.alignment = .trailing
        sendButtonStackView.axis = .vertical
        
        stackView = UIStackView(arrangedSubviews: [topStackView, sendButtonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.background
        textView.delegate = self
        
        addSubview(stackView)
        
        let views = ["stackView": stackView]
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|-[stackView]-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostView: PostViewProtocol {
    
    var topView: UIView {
        return stackView
    }
    
    var text: String? {
        return textView.text
    }
    
    func reset() {
        textView.text = ""
    }
    
    func setFirstResponder() {
        textView.becomeFirstResponder()
    }
}

extension PostView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let remainingCharacters = 256 - textView.text.characters.count
        countLabel.text = "\(remainingCharacters)"
        
        if remainingCharacters < 0 {
            countLabel.textColor = UIColor.red
            sendButton.isEnabled = false
        } else {
            countLabel.textColor = UIColor.lightGray
            if textView.text.characters.count == 0 {
                sendButton.isEnabled = false
            } else {
                sendButton.isEnabled = true
            }
        }
    }
}

protocol PostViewProtocol {
    var topView: UIView { get }
    var text: String? { get }
    func reset()
    func setFirstResponder()
}

@objc protocol PostProtocol {
    @objc func send()
}

fileprivate extension Selector {
    static let send = #selector(PostProtocol.send)
}
