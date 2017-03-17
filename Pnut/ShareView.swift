//  Created by dasdom on 15/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import DDHFoundation

class ShareView: UIView {

    private let spinner: UIActivityIndicatorView
    private let spinnerHost: UIView
    private let spinnerStackView: UIStackView
    fileprivate let overlayLabel: UILabel
    let stackView: UIStackView
    let textView: UITextView
    let urlLabel: DDHLabel
    let sendButton: UIButton
    let cancelButton: UIButton
    let remainingCharacterLabel: UILabel
    
    override init(frame: CGRect) {
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.startAnimating()
        
        overlayLabel = UILabel()
        overlayLabel.text = NSLocalizedString("Loading...", comment: "")
        overlayLabel.textColor = UIColor.white
        
        spinnerStackView = UIStackView(arrangedSubviews: [spinner, overlayLabel])
        spinnerStackView.translatesAutoresizingMaskIntoConstraints = false
        spinnerStackView.axis = .vertical
        spinnerStackView.alignment = .center
        spinnerStackView.spacing = 10
        
        spinnerHost = UIView()
        spinnerHost.translatesAutoresizingMaskIntoConstraints = false
        spinnerHost.backgroundColor = UIColor(white: 0, alpha: 0.5)
        spinnerHost.layer.cornerRadius = 10
        spinnerHost.addSubview(spinnerStackView)
        spinnerHost.isHidden = true
        
        textView = DDHTextView()
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.keyboardAppearance = .dark

        urlLabel = DDHLabel()
        urlLabel.textColor = UIColor(white: 0.7, alpha: 1.0)
        urlLabel.backgroundColor = UIColor.brown
        urlLabel.lineBreakMode = .byTruncatingMiddle
        urlLabel.textAlignment = .center
        urlLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
//        sendButton.backgroundColor = UIColor.red
        sendButton.addTarget(nil, action: .send, for: .touchUpInside)
        
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
//        cancelButton.backgroundColor = UIColor.red
        cancelButton.addTarget(nil, action: .cancel, for: .touchUpInside)
        
        remainingCharacterLabel = UILabel()
        remainingCharacterLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        remainingCharacterLabel.textColor = UIColor(white: 0.7, alpha: 1.0)
       
        let sendButtonStackView = UIStackView(arrangedSubviews: [cancelButton, remainingCharacterLabel, sendButton])
        sendButtonStackView.axis = .horizontal
        sendButtonStackView.distribution = .equalSpacing
//        sendButtonStackView.alignment = .trailing

        stackView = UIStackView(arrangedSubviews: [textView, urlLabel, sendButtonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        
        let backgroundView = DDHView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 5
        stackView.insertSubview(backgroundView, at: 0)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        tintColor = UIColor.tint

        addSubview(stackView)
        stackView.addSubview(spinnerHost)

        let views: [String: UIView] = ["stackView": stackView, "backgroundView": backgroundView]
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|-(>=20)-[stackView]-(>=20)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "[stackView(300@750)]", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[stackView]", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|[backgroundView]|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|", options: [], metrics: nil, views: views)
        layoutConstraints += [stackView.centerXAnchor.constraint(equalTo: centerXAnchor)]
        layoutConstraints += [spinnerHost.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)]
        layoutConstraints += [spinnerHost.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)]
        layoutConstraints += [spinnerHost.widthAnchor.constraint(equalToConstant: 100)]
        layoutConstraints += [spinnerHost.heightAnchor.constraint(equalToConstant: 100)]
        layoutConstraints += [spinnerStackView.centerXAnchor.constraint(equalTo: spinnerHost.centerXAnchor)]
        layoutConstraints += [spinnerStackView.centerYAnchor.constraint(equalTo: spinnerHost.centerYAnchor)]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showSpinner(text: String) {
        overlayLabel.text = text
        spinner.startAnimating()
        spinnerHost.isHidden = false
    }
    
    func hideSpinner() {
        spinner.stopAnimating()
        spinnerHost.isHidden = true
    }
    
    var bottomView: UIView {
        return stackView
    }
}

@objc protocol PostProtocol {
    @objc func send()
    @objc func cancel()
}

fileprivate extension Selector {
    static let send = #selector(PostProtocol.send)
    static let cancel = #selector(PostProtocol.cancel)
}
