//
//  WebViewController.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/6/19.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import UIKit
import SnapKit

class WebViewController: BaseViewController, UIWebViewDelegate, UINavigationControllerDelegate {

    private let hud = NoticesCenter()

    public var htmlURL: String!

    var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlEncoding = htmlURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            , let url = URL.init(string: urlEncoding) {
            var request = URLRequest.init(url: url)
            request.timeoutInterval = 30
            
            setupWeb(request)
        }else {
            hud.failureHidden("无效地址")
        }
    }
    
    func setupWeb(_ request: URLRequest) {
        if webView != nil {
            webView.stopLoading()
         
            webView.removeFromSuperview()
            webView.delegate = nil
            webView = nil
        }
        
        webView = UIWebView()
        webView.delegate = self
        view.addSubview(webView)
        webView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
        
        if #available(iOS 11, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }

        webView.loadRequest(request)
        
    }
    
    func setupWeb() {
        if webView != nil {
            webView.stopLoading()
            
            webView.removeFromSuperview()
            webView.delegate = nil
            webView = nil
        }
        
        webView = UIWebView()
        webView.delegate = self
        view.addSubview(webView)
        webView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
        
        if #available(iOS 11, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func webLoad(_ url: String) {
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        var request = URLRequest.init(url: URL.init(string: urlEncoding!)!)
        request.timeoutInterval = 30

        webView.loadRequest(request)
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        webView.delegate = nil
    }

    override func prepare(parameters: [String : Any]?) {
        htmlURL = parameters?["url"] as? String
        navigationItem.title = parameters?["title"] as? String
    }

    //MARK:
    //MARK: UIWebViewDelegate

    func webViewDidStartLoad(_ webView: UIWebView) {
        hud.noticeLoading()
        
        PrintLog("请求url: \(webView.request?.url?.absoluteString ?? "无")")
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        hud.noticeHidden()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if (error as NSError).code == NSURLErrorCancelled {
            return
        }
        webView.stopLoading()
        webView.delegate = nil
        PrintLog(error.localizedDescription)
        hud.failureHidden(error.localizedDescription)
    }

}

//class WebViewController: BaseViewController {
//
//    private let hud = NoticesCenter()
//
//    public var htmlURL: String!
//
//    var webView: WKWebView = {
//        let webView = WKWebView()
//        webView.allowsBackForwardNavigationGestures = true
//        return webView
//    }()
//
//    fileprivate var progressView: UIProgressView = {
//        let progressView = UIProgressView.init(progressViewStyle: .default)
//        progressView.progressTintColor = SR_RED_COLOR
//        progressView.trackTintColor    = .clear
//        return progressView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if #available(iOS 11, *) {
//            webView.scrollView.contentInsetAdjustmentBehavior = .never
//        }
//
//        webView.navigationDelegate = self
//        view.addSubview(webView)
//        view.addSubview(progressView)
//
//        webView.snp.makeConstraints { $0.edges.equalTo(UIEdgeInsets.zero) }
//        progressView.snp.makeConstraints {
//            $0.left.equalTo(view)
//            $0.right.equalTo(view)
//            $0.top.equalTo(view)
//            $0.height.equalTo(2)
//        }
//
//        let urlEncoding = htmlURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
//        var request = URLRequest.init(url: URL.init(string: urlEncoding!)!)
//        request.timeoutInterval = 30
//        webView.load(request)
//
//        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.new, .old], context: nil)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        guard let web = object as? WKWebView else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//            return
//        }
//        if keyPath == "estimatedProgress" {
//            if web.estimatedProgress >= 1.0 {
//                progressView.alpha = 0
//                progressView.setProgress(0, animated: true)
//            }else {
//                progressView.alpha = 1.0
//                progressView.setProgress(Float(web.estimatedProgress), animated: true)
//            }
//        }else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//        }
//    }
//
//    override func prepare(parameters: [String : Any]?) {
//        htmlURL = parameters?["url"] as? String
//        navigationItem.title = parameters?["title"] as? String
//    }
//
//    deinit {
//        webView.removeObserver(self, forKeyPath: "estimatedProgress")
//        webView.navigationDelegate = nil
//    }
//
//}

//extension WebViewController: WKNavigationDelegate {
//
////    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
////        hud.noticeLoading()
////    }
////
////    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
////        hud.noticeHidden()
////    }
//
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        webView.stopLoading()
////        hud.failureHidden(error.localizedDescription)
//    }
//
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//        if navigationAction.navigationType == .backForward {
//            if webView.backForwardList.backList.count > 0 {
//                let item = webView.backForwardList.currentItem
//                for backItem in webView.backForwardList.backList {
//                    if item == backItem { webView.go(to: webView.backForwardList.backList.first!) }
//                }
//            }
//        }
//
//        decisionHandler(.allow)
//    }
//}

