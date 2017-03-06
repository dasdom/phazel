//  Created by Dominik Hauser on 08/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import Roaster

@objc(ShareViewController)

class ShareViewController: SLComposeServiceViewController {

    var url: URL?
    var initialText: String?
    private let spinner: UIActivityIndicatorView
    private let spinnerHost: UIView
    private let stackView: UIStackView
    let userDefaults = UserDefaults(suiteName: "group.com.swiftandpainless.phazel")!
    let apiClient: APIClient
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        apiClient = APIClient(userDefaults: userDefaults)
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.startAnimating()
        
        let label = UILabel()
        label.text = NSLocalizedString("Posting", comment: "")
        label.textColor = UIColor.white
        
        stackView = UIStackView(arrangedSubviews: [spinner, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        
        spinnerHost = UIView()
        spinnerHost.translatesAutoresizingMaskIntoConstraints = false
        spinnerHost.backgroundColor = UIColor(white: 0, alpha: 0.7)
        spinnerHost.layer.cornerRadius = 10
        spinnerHost.addSubview(stackView)
        spinnerHost.isHidden = true
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
        layoutConstraints += [stackView.centerXAnchor.constraint(equalTo: spinnerHost.centerXAnchor)]
        layoutConstraints += [stackView.centerYAnchor.constraint(equalTo: spinnerHost.centerYAnchor)]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    override func presentationAnimationDidFinish() {
        
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
    
    override func isContentValid() -> Bool {
        
        charactersRemaining = Int(256 - contentText.characters.count) as NSNumber!
        
        return contentText.characters.count < 256
    }

    override func didSelectPost() {
        
        let textToShare: String
        var prefix = ""
        var postfix = ""
        var subString = ""
        
        var text: String
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
        } else {
            if let url = url {
                text = url.absoluteString
            } else {
                text = ""
            }
        }
        
        guard text.characters.count > 0 else {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        var postedURL: URL?
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

    override func configurationItems() -> [Any]! {
        return []
    }
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
}
