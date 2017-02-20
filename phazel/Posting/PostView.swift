//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class PostView: DDHView {
    
    let textView: DDHTextView
    let sendButton: DDHButton
    fileprivate let stackView: UIStackView
    
    override init(frame: CGRect) {
        
        textView = DDHTextView()
        textView.backgroundColor = UIColor.background
        textView.textColor = UIColor.white
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        
        sendButton = DDHButton()
        sendButton.addTarget(nil, action: .send, for: .touchUpInside)
        sendButton.backgroundColor = UIColor.red
        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        sendButton.backgroundColor = UIColor.buttonBackground

        stackView = UIStackView(arrangedSubviews: [textView, sendButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.background
        
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
