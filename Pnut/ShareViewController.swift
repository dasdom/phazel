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
    let userDefaults = UserDefaults(suiteName: "group.com.swiftandpainless.phazel")!
    let apiClient: APIClient
    fileprivate var bottomConstraint: NSLayoutConstraint?
    var charactersRemaining = 256 {
        didSet {
            contentView.countLabel.text = "\(charactersRemaining)"
        }
        
    }
    
    var contentText: String {
        return contentView.textView.text
    }
    
    var contentView: ShareView {
        return view as! ShareView
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        apiClient = APIClient(userDefaults: userDefaults)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.titleLabel.text = "Create a nut"
        
        NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        contentView.countLabel.text = "\(charactersRemaining)"
        contentView.textView.delegate = self
    }
    
    override func loadView() {
        view = ShareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.showSpinner(text: "Loading...")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentationAnimationDidFinish()
        contentView.textView.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        bottomConstraint = contentView.bottomView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20)
        bottomConstraint?.isActive = true
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
                        self.contentView.textView.text = textToShare
                    } else if (self.contentView.textView.text?.characters.count ?? 0) < 1,
                        let unwrappedURL = url {
                        self.contentView.textView.text = unwrappedURL.absoluteString
                    }
                    self.initialText = self.contentView.textView.text
                   
                    if let unwrappedURL = url {
                        if unwrappedURL.absoluteString.characters.count > 0 {
                            self.contentView.urlLabel.text = unwrappedURL.absoluteString
                        }
                    } else {
                        self.contentView.urlLabel.text = "No link..."
                    }
                    
                    self.contentView.sendButton.isEnabled = self.isContentValid()
                    self.contentView.hideSpinner()
                }
                self.url = url
            })
            
        }
        
    }
    
    func isContentValid() -> Bool {
        
        charactersRemaining = 256 - contentText.characters.count
        
        return contentText.characters.count < 256 && contentText.characters.count > 0
    }
}

// MARK: - PostProtocol
extension ShareViewController: PostProtocol {
    
    func send() {
        
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
        
        contentView.showSpinner(text: "Sending...")
        
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
                self.contentView.hideSpinner()
                switch result {
                case .success(let postId):
                    print("postId: \(postId)")
                    self.userDefaults.set(postId, forKey: lastPostIdKey)
                    self.userDefaults.set(postedURL, forKey: lastPostedURLKey)
                case .failure(let error):
                    print("error: \(error)")
                    break
                }
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.alpha = 0
                }) { _ in
                    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                }
            }
        }
        
    }
    
    func cancel() {
        UIView.animate(withDuration: 0.2, animations: { 
            self.view.alpha = 0
        }) { _ in
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

//    override func configurationItems() -> [Any]! {
//        return []
//    }
}

// MARK: - UITextViewDelegate
extension ShareViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        contentView.sendButton.isEnabled = isContentValid()
    }
}

// MARK: - Data extractors
extension ShareViewController {
    func extractTextAndURL(from itemProvider: NSItemProvider, completion: @escaping (String?, URL?) -> ()) {
        
        let plistType = kUTTypePropertyList as String
        let urlType = kUTTypeURL as String
        let textType = kUTTypeText as String
        
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
                
                print("item: \(String(describing: item))")
                if let url = item as? URL {
                    completion(nil, url)
                }
            })
        } else if itemProvider.hasItemConformingToTypeIdentifier(textType) {
            
            itemProvider.loadItem(forTypeIdentifier: textType, options: nil, completionHandler: { item, error in
                if let text = item as? String {
                    completion(text, nil)
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
    
    func keyboardWillShow(sender: NSNotification) {
        guard let frame = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        let convertedFrame = view.convert(frame, from: nil)
        
        bottomConstraint?.constant = -convertedFrame.height
        self.view.layoutIfNeeded()
    }
}

fileprivate extension Selector {
    static let keyboardWillShow = #selector(ShareViewController.keyboardWillShow(sender:))
}
