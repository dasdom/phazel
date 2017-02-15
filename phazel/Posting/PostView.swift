//  Created by dasdom on 15/02/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

class PostView: DDHView {
    
    let textView: DDHTextView
    let sendButton: DDHButton
    
    override init(frame: CGRect) {
        
        textView = DDHTextView()
        
        sendButton = DDHButton()
        sendButton.addTarget(nil, action: .send, for: .touchUpInside)
        
        super.init(frame: frame)
        
        addSubview(textView)
        addSubview(sendButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostView: PostViewProtocol {
    var text: String? {
        return textView.text
    }
}

protocol PostViewProtocol {
    var text: String? { get }
}

@objc protocol PostProtocol {
    @objc func send()
}

fileprivate extension Selector {
    static let send = #selector(PostProtocol.send)
}
