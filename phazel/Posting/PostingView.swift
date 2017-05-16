//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import DDHFoundation

class PostingView: DDHView {
    
    let textView: DDHTextView
    let sendButton: DDHButton
    let statusStackView: UIStackView
    fileprivate let countLabel: UILabel
    fileprivate let stackView: UIStackView
    fileprivate let spinner: UIActivityIndicatorView
    fileprivate let sendButtonTitle = "Post"
    fileprivate let statusHostView: UIView

    override init(frame: CGRect) {
        
        textView = DDHTextView()
        textView.backgroundColor = AppColors.background
        textView.font = UIFont.preferredFont(forTextStyle: .body)
//        textView.keyboardAppearance = .dark
        
        countLabel = DDHLabel()
        countLabel.backgroundColor = AppColors.background
        countLabel.textColor = AppColors.text.withAlphaComponent(0.6)
        countLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        countLabel.textAlignment = .right
        countLabel.text = "256"
        
        sendButton = DDHButton(type: .system)
        sendButton.addTarget(nil, action: .send, for: .touchUpInside)
        sendButton.setTitle(sendButtonTitle, for: .normal)
        sendButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
//        sendButton.backgroundColor = UIColor.buttonBackground
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        sendButton.isEnabled = false
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        
        sendButton.addSubview(spinner)
        
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
        
        statusStackView = UIStackView(arrangedSubviews: [])
        statusStackView.translatesAutoresizingMaskIntoConstraints = false
        statusStackView.axis = .vertical
        
        statusHostView = UIView()
        statusHostView.translatesAutoresizingMaskIntoConstraints = false
        statusHostView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        statusHostView.alpha = 0.0
        statusHostView.layer.cornerRadius = 10
        statusHostView.addSubview(statusStackView)
        
        super.init(frame: frame)
        
        textView.delegate = self
        
        addSubview(stackView)
        stackView.addSubview(statusHostView)
        
        let views = ["stackView": stackView, "statusStackView": statusStackView, "statusHostView": statusHostView]
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|-[stackView]-|", options: [], metrics: nil, views: views)
        layoutConstraints += [spinner.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor)]
        layoutConstraints += [spinner.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor)]
        layoutConstraints += [statusHostView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)]
        layoutConstraints += [statusHostView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)]
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|-(>=40)-[statusHostView]-(>=40)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|-10-[statusStackView]-10-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[statusStackView]-10-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

extension PostingView: PostingViewProtocol {
    
    var topView: UIView {
        return stackView
    }
    
    var text: String? {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
        }
    }
    
    func update(with error: Error?) {
        
        if let error = error {
            addImageAndLabelForState(state: .failure, text: error.localizedDescription)
        } else {
            textView.text = ""
            sendButton.isEnabled = false
            updateCountLabel(for: textView.text)
            
            addImageAndLabelForState(state: .success, text: nil)
        }
    }
    
    enum PostingState {
        case success, failure
    }
    
    fileprivate func addImageAndLabelForState(state: PostingState, text: String?) {
        let image: UIImage?
        switch state {
        case .success:
            image = UIImage(named: "success")?.withRenderingMode(.alwaysTemplate)
        case .failure:
            image = UIImage(named: "failure")?.withRenderingMode(.alwaysTemplate)
        }
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.white
        statusStackView.addArrangedSubview(imageView)
        
        if let text = text, text.characters.count > 0 {
            let label = UILabel()
            label.text = text
            label.numberOfLines = 0
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = UIFont.preferredFont(forTextStyle: .body)
            statusStackView.addArrangedSubview(label)
        }
        UIView.animate(withDuration: 0.3, animations: { 
            self.statusHostView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: { 
                self.statusHostView.alpha = 0.0
            }, completion: { _ in
                for view in self.statusStackView.arrangedSubviews {
                    view.removeFromSuperview()
                }
            })
        }
    }
    
    func setFirstResponder() {
        textView.becomeFirstResponder()
    }
    
    func set(animating: Bool) {
        if animating {
            sendButton.setTitle(nil, for: .normal)
            spinner.startAnimating()
        } else {
            sendButton.setTitle(sendButtonTitle, for: .normal)
            spinner.stopAnimating()
        }
    }
}

// MARK: - UITextViewDelegate
extension PostingView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        updateCountLabel(for: textView.text)
        
        if remainingCharacters < 0 {
            sendButton.isEnabled = false
        } else {
            if textView.text.characters.count == 0 {
                sendButton.isEnabled = false
            } else {
                sendButton.isEnabled = true
            }
        }
    }
}

// MARK: - Helper
extension PostingView {
    fileprivate var remainingCharacters: Int {
        return 256 - textView.text.characters.count
    }
    
    fileprivate func updateCountLabel(for text: String) {
        countLabel.text = "\(remainingCharacters)"
        
        if remainingCharacters < 0 {
            countLabel.textColor = UIColor.red
        } else {
            countLabel.textColor = AppColors.text.withAlphaComponent(0.6)
        }
    }
}

protocol PostingViewProtocol {
    var topView: UIView { get }
    var text: String? { get set }
    func update(with error: Error?)
    func setFirstResponder()
    func set(animating: Bool)
}

@objc protocol PostProtocol {
    @objc func send()
}

fileprivate extension Selector {
    static let send = #selector(PostProtocol.send)
}
