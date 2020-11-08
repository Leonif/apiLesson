//
//  WKAutorizationView.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 24.09.2020.
//

import UIKit
import WebKit

class WKAutorizationView: WKWebView {
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setup() {

    }
}
