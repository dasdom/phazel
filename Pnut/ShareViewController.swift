//  Created by Dominik Hauser on 08/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import Roaster

@objc(ShareViewController)

class ShareViewController: UIViewController {

    var url: URL?
    var initialText: String?
    private let spinner: UIActivityIndicatorView
    private let spinnerHost: UIView
    private let spinnerStackView: UIStackView
    let userDefaults = UserDefaults(suiteName: "group.com.swiftandpainless.phazel")!
    let apiClient: APIClient
    
    let textView: UITextView
    let sendButton: UIButton
    var contentText: String {
        return textView.text
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        apiClient = APIClient(userDefaults: userDefaults)
        
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
        
        textView = UITextView()
        textView.backgroundColor = UIColor.yellow
        textView.font = UIFont.preferredFont(forTextStyle: .body)

        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        sendButton.backgroundColor = UIColor.red
        
        let sendButtonStackView = UIStackView(arrangedSubviews: [sendButton])
        sendButtonStackView.axis = .vertical
        sendButtonStackView.alignment = .trailing
        
        let stackView = UIStackView(arrangedSubviews: [textView, sendButtonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.white
        stackView.insertSubview(backgroundView, at: 0)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        view.addSubview(stackView)
        
        let views = ["stackView": stackView, "backgroundView": backgroundView]
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|-20-[stackView]-20-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[stackView]-40-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|[backgroundView]|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "phazel"
        
        view.addSubview(spinnerHost)
        
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints += [spinnerHost.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        layoutConstraints += [spinnerHost.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        layoutConstraints += [spinnerHost.widthAnchor.constraint(equalToConstant: 100)]
        layoutConstraints += [spinnerHost.heightAnchor.constraint(equalToConstant: 100)]
        layoutConstraints += [spinnerStackView.centerXAnchor.constraint(equalTo: spinnerHost.centerXAnchor)]
        layoutConstraints += [spinnerStackView.centerYAnchor.constraint(equalTo: spinnerHost.centerYAnchor)]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentationAnimationDidFinish()
    }
    
    func presentationAnimationDidFinish() {
        
        guard let items = extensionContext?.inputItems else {
//            print("No inputItems")
            return
        }
        
//        print("items: \(items)")
        
        guard !items.isEmpty, let item = items[0] as? NSExtensionItem else {
//            print("No NSExtensionItem")
            return
        }
        
        guard let attachments = item.attachments else {
//            print("No attachments")
            return
        }
        
        for attachment in attachments {
            guard let itemProvider = attachment as? NSItemProvider else {
//                print("No NSItemProvider")
                return
            }
            
//            print("itemProvier: \(itemProvider)")
//            print("registeredTypeIdentifiers: \(itemProvider.registeredTypeIdentifiers)")
            
            extractTextAndURL(from: itemProvider, completion: { text, url in
                DispatchQueue.main.async {
                    if let textToShare = text {
                        self.textView.text = textToShare
                    } else if (self.textView.text?.characters.count ?? 0) < 1 {
                        self.textView.text = url.absoluteString
                    }
                    self.initialText = self.textView.text
                }
                self.url = url
            })
            
        }
        
    }
    
    func isContentValid() -> Bool {
        
//        charactersRemaining = Int(256 - contentText.characters.count) as NSNumber!
        
        return contentText.characters.count < 256
    }

    func didSelectPost() {
        
        var (prefix, subString, postfix) = extractPrefixSubstringPostfix(from: contentText, initialText: initialText)
        
        let text = extractText(from: contentText, and: url)
        
        guard text.characters.count > 0 else {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        var postedURL: URL?
        let textToShare: String
        if let url = url, text != url.absoluteString {
            postedURL = url
            if subString.characters.count > 0 {
                textToShare = "\(prefix)[\(subString)](\(url))\(postfix)"
            } else {
                textToShare = "[\(text)](\(url))"
            }
        } else {
            textToShare = text
        }
        print("text: \(textToShare)")
        
        spinner.startAnimating()
        spinnerHost.isHidden = false
        
        let lastPostedURLKey = "lastPostedURL"
        let lastPostIdKey = "lastPostId"
        let lastPostedURL = userDefaults.url(forKey: lastPostedURLKey)
        let lastPostId: String?
        if lastPostedURL == postedURL {
            lastPostId = userDefaults.string(forKey: lastPostIdKey)
        } else {
            lastPostId = nil
        }
        
        apiClient.post(text: textToShare, replyTo: lastPostId) { result in
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                switch result {
                case .success(let postId):
                    print("postId: \(postId)")
                    self.userDefaults.set(postId, forKey: lastPostIdKey)
                    self.userDefaults.set(postedURL, forKey: lastPostedURLKey)
                case .failure(let error):
                    print("error: \(error)")
                    break
                }
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
        
    }

//    override func configurationItems() -> [Any]! {
//        return []
//    }
}

// MARK: - Data extractors
extension ShareViewController {
    func extractTextAndURL(from itemProvider: NSItemProvider, completion: @escaping (String?, URL) -> ()) {
        
        let plistType = kUTTypePropertyList as String
        let urlType = kUTTypeURL as String
//        let textType = kUTTypeText as String
        
        if itemProvider.hasItemConformingToTypeIdentifier(plistType) {
           
            itemProvider.loadItem(forTypeIdentifier: plistType, options: nil, completionHandler: { item, error in
                
                guard let item = item as? NSDictionary else { return }
                guard let elements = item[NSExtensionJavaScriptPreprocessingResultsKey] as? [String:String] else {
//                    print("No elmenents")
                    return
                }
                
                var textToShare: String? = nil
                if let selectedText = elements["selection"], selectedText.characters.count > 0 {
                    textToShare = selectedText
                } else if let title = elements["title"], title.characters.count > 0 {
                    textToShare = title
                } else if let urlString = elements["URL"] {
                    textToShare = urlString
                }
                
                if let urlString = elements["URL"], let url = URL(string: urlString) {
                    completion(textToShare, url)
                    
                }
            })
        } else if itemProvider.hasItemConformingToTypeIdentifier(urlType) {
            
            itemProvider.loadItem(forTypeIdentifier: urlType, options: nil, completionHandler: { item, error in
                
                print("item: \(item)")
                if let url = item as? URL {
                    completion(nil, url)
                }
            })
        }
    }
    
    func extractPrefixSubstringPostfix(from contentText: String?, initialText: String?) -> (String, String, String) {
        var prefix = ""
        var subString = ""
        var postfix = ""
        
        var text: String = ""
        if let unwrappedText = contentText, unwrappedText.characters.count > 0 {
            text = unwrappedText
            
            if let initialText = initialText {
                if text.characters.count > initialText.characters.count {
                    if let range = text.range(of: initialText) {
                        subString = text.substring(with: range)
                        prefix = text.substring(to: range.lowerBound)
                        postfix = text.substring(from: range.upperBound)
                    }
                }
            }
            
            if subString.characters.count < 1 {
                if let startIndex = text.range(of: "["), let stopIndex = text.range(of: "]"),
                    startIndex.lowerBound < stopIndex.lowerBound {
                    
                    subString = text.substring(with: Range(uncheckedBounds: (lower: startIndex.upperBound, upper: stopIndex.lowerBound)))
                    prefix = text.substring(to: startIndex.lowerBound)
                    postfix = text.substring(from: stopIndex.upperBound)
                }
                
            }
        }
        
        return (prefix, subString, postfix)
    }
    
    func extractText(from contentText: String?, and url: URL?) -> String {
        var text: String = ""
        if let unwrappedText = contentText, unwrappedText.characters.count > 0 {
            text = unwrappedText
        } else if let url = url {
            text = url.absoluteString
        }
        return text
    }
}
