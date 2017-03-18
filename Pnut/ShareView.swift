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
    let titleLabel: UILabel
    let stackView: UIStackView
    let textView: UITextView
    let urlLabel: DDHLabel
    let sendButton: UIButton
    let cancelButton: UIButton
    let countLabel: UILabel
    
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
        
        titleLabel = DDHLabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textAlignment = .center
//        titleLabel.textColor = AppColors.barText
//        titleLabel.backgroundColor = AppColors.bar
        
        let separatorView = UIView()
        separatorView.backgroundColor = AppColors.text
        
        textView = DDHTextView()
        textView.backgroundColor = AppColors.clear
        textView.font = UIFont.preferredFont(forTextStyle: .body)
//        textView.keyboardAppearance = .dark

        countLabel = UILabel()
        countLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        countLabel.textColor = AppColors.text.withAlphaComponent(0.6)
        countLabel.backgroundColor = AppColors.background
        countLabel.textAlignment = .left

        let countStackView = UIStackView(arrangedSubviews: [countLabel])
        countStackView.alignment = .top
        
        let textStackView = UIStackView(arrangedSubviews: [textView, countStackView])
        textStackView.spacing = 5
        
        urlLabel = DDHLabel()
        urlLabel.textColor = AppColors.background
        urlLabel.backgroundColor = AppColors.lightGray
        urlLabel.lineBreakMode = .byTruncatingMiddle
        urlLabel.textAlignment = .center
        urlLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        sendButton = UIButton(type: .system)
        sendButton.setTitle("Post", for: .normal)
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
//        sendButton.backgroundColor = UIColor.red
        sendButton.addTarget(nil, action: .send, for: .touchUpInside)
        
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
//        cancelButton.backgroundColor = UIColor.red
        cancelButton.addTarget(nil, action: .cancel, for: .touchUpInside)
       
        let sendButtonStackView = UIStackView(arrangedSubviews: [cancelButton, sendButton])
        sendButtonStackView.axis = .horizontal
        sendButtonStackView.distribution = .equalSpacing
//        sendButtonStackView.alignment = .trailing

        stackView = UIStackView(arrangedSubviews: [titleLabel, separatorView, textStackView, urlLabel, sendButtonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
//        stackView.layer.cornerRadius = 10
//        stackView.layer.masksToBounds = true
//        stackView.spacing = 0
        
        let backgroundView = DDHView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.masksToBounds = true
        stackView.insertSubview(backgroundView, at: 0)
        
        super.init(frame: frame)
        
//        backgroundColor = UIColor.background.withAlphaComponent(0.9)
        backgroundColor = UIColor(white: 0, alpha: 0.8)
        tintColor = AppColors.tint

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
        layoutConstraints += [titleLabel.heightAnchor.constraint(equalToConstant: 30)]
        layoutConstraints += [separatorView.heightAnchor.constraint(equalToConstant: 0.5)]
        layoutConstraints += [countLabel.widthAnchor.constraint(equalToConstant: 30)]
        layoutConstraints += [countLabel.heightAnchor.constraint(equalToConstant: 30)]
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
