//  Created by Dominik Hauser on 08/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import Roaster

class ShareViewController: SLComposeServiceViewController {

    var urlToShare: URL?
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var spinnerHost: UIView!
    
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
                if let textToShare = text {
                    DispatchQueue.main.async {
                        self.textView.text = textToShare
                    }
                }
                self.urlToShare = url
            })
            
        }
        
    }
    
    override func isContentValid() -> Bool {
        
        charactersRemaining = Int(256 - contentText.characters.count) as NSNumber!
        
        return contentText.characters.count < 256
    }

    override func didSelectPost() {
        
        let textToShare: String
        guard let url = urlToShare, let text = contentText else {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        textToShare = "[\(text)](\(url))"
        
        let apiClient = APIClient()
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
        
        let urlType = kUTTypePropertyList as String
        
        if itemProvider.hasItemConformingToTypeIdentifier(urlType) {
            itemProvider.loadItem(forTypeIdentifier: urlType, options: nil, completionHandler: { item, error in
                
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
        }
        
    }
}
