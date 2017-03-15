//  Created by dasdom on 15/03/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import DDHFoundation

class ShareView: UIView {

    private let spinner: UIActivityIndicatorView
    private let spinnerHost: UIView
    private let spinnerStackView: UIStackView
    let textView: UITextView
    let sendButton: UIButton
    private let stackView: UIStackView
    
    override init(frame: CGRect) {
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.startAnimating()
        
        let label = UILabel()
        label.text = NSLocalizedString("Posting", comment: "")
        label.textColor = UIColor.white
        
        spinnerStackView = UIStackView(arrangedSubviews: [spinner, label])
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
//        textView.backgroundColor = UIColor.yellow
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        
        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        sendButton.backgroundColor = UIColor.red
        
        let sendButtonStackView = UIStackView(arrangedSubviews: [sendButton])
        sendButtonStackView.axis = .vertical
        sendButtonStackView.alignment = .trailing
        
        stackView = UIStackView(arrangedSubviews: [textView, sendButtonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        let backgroundView = DDHView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(backgroundView, at: 0)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        addSubview(stackView)
        addSubview(spinnerHost)

        let views: [String: UIView] = ["stackView": stackView, "backgroundView": backgroundView]
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|-20-[stackView]-20-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[stackView]", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|[backgroundView]|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|", options: [], metrics: nil, views: views)
        layoutConstraints += [spinnerHost.centerXAnchor.constraint(equalTo: centerXAnchor)]
        layoutConstraints += [spinnerHost.centerYAnchor.constraint(equalTo: centerYAnchor)]
        layoutConstraints += [spinnerHost.widthAnchor.constraint(equalToConstant: 100)]
        layoutConstraints += [spinnerHost.heightAnchor.constraint(equalToConstant: 100)]
        layoutConstraints += [spinnerStackView.centerXAnchor.constraint(equalTo: spinnerHost.centerXAnchor)]
        layoutConstraints += [spinnerStackView.centerYAnchor.constraint(equalTo: spinnerHost.centerYAnchor)]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showSpinner() {
        spinner.startAnimating()
        spinnerHost.isHidden = false
    }
    
    func hideSpinner() {
        spinner.stopAnimating()
    }
    
    var bottomView: UIView {
        return stackView
    }
}
