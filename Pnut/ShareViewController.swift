//  Created by Dominik Hauser on 08/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import Roaster

class ShareViewController: SLComposeServiceViewController {

    var url: URL?
    var initialText: String?
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var spinnerHost: UIView!
    let apiClient = APIClient(userDefaults: UserDefaults(suiteName: "group.com.swiftandpainless.phazel")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "phazel"
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
            
            print("itemProvier: \(itemProvider)")
            print("registeredTypeIdentifiers: \(itemProvider.registeredTypeIdentifiers)")
            
            extractTextAndURL(from: itemProvider, completion: { text, url in
                print("*****************************************************")
                print(text, url)
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
        
        if let url = url, text != url.absoluteString {
            if subString.characters.count > 0 {
                textToShare = "\(prefix)[\(subString)](\(url.absoluteString))\(postfix)"
            } else {
                textToShare = "[\(text)](\(url.absoluteString))"
            }
        } else {
            textToShare = text
        }
        print("text: \(textToShare)")
        
        spinner.startAnimating()
        spinnerHost.isHidden = false
        apiClient.post(text: textToShare) { result in
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                switch result {
                case .success(let postId):
                    print("postId: \(postId)")
                case .failure(let error):
                    print("error: \(error)")
                    break
                }
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
        
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
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
