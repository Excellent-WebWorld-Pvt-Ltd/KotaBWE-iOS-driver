//
//  PaymentWebPageVC.swift
//  Peppea
//
//  Created by EWW082 on 27/12/19.
//  Copyright © 2019 Mayur iMac. All rights reserved.
//

import UIKit
import WebKit

typealias PaymentSuccessCallback  = (_ isPaid: Bool) -> Void

class PaymentWebPageVC: BaseViewController {
    //MARK:- Variables
    lazy var webView = WKWebView(frame: view.bounds)
    lazy var progressIndicator = UIActivityIndicatorView()
    private var popupWebView: WKWebView?
    let completion: PaymentSuccessCallback?
    let paymentUrl: URL
    
    init(_ paymentUrl: URL, completion: @escaping PaymentSuccessCallback) {
        self.paymentUrl = paymentUrl
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        self.setupNavigation(.normal(title: "Make Payment", leftItem: .none))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(webView)
        progressIndicator.color = .white
        progressIndicator.hidesWhenStopped = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: progressIndicator)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        webView.configuration.preferences.javaScriptEnabled = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(URLRequest(url: paymentUrl))
    }
    
    func checkWebURL(_ urlString: String) {
        if urlString == NetworkEnvironment.webPaymentSuccessUrl {
            UtilityClass.triggerHapticFeedback(.success)
            self.completion?(true)
            self.navigationController?.popViewController(animated: true)
        } else if urlString == NetworkEnvironment.webPaymentFailureUrl {
            UtilityClass.triggerHapticFeedback(.error)
            self.completion?(false)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func cancelTapped() {
        let alert = UIAlertController(title: "Cancel Payment?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { [unowned self] _ in
            self.goBack()
        }
        let noAction = UIAlertAction(title: "No", style: .default)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true)
    }
}


//MARK:- WebView Delegate Methods

extension PaymentWebPageVC : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        if let urlString = navigationAction.request.url?.absoluteString {
            self.checkWebURL(urlString)
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        progressIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressIndicator.stopAnimating()
    }
}

extension PaymentWebPageVC: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        popupWebView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView?.navigationDelegate = self
        popupWebView?.uiDelegate = self
        if let newWebview = popupWebView {
            view.addSubview(newWebview)
        }
        return popupWebView ?? nil
    }
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popupWebView = nil
    }
}
