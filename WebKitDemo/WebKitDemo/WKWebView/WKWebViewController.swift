//
//  WKWebViewController.swift
//  WebKitDemo
//
//  Created by BriceZhao on 2019/9/23.
//  Copyright © 2019 BriceZhao. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController, WKScriptMessageHandler {
    
    lazy var webView: WKWebView = {
        //为 WKWebView 添加配置信息
        let config = WKWebViewConfiguration()
        //设置全局的偏好对象
        let preference = WKPreferences()
        //设置是否支持JavaScript
        preference.javaScriptEnabled = true
        //在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = preference
        //是使用h5的视频播放器在线播放，还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = true
        //设置视频/音频是否需要用户手动播放 设置为all则会允许自动播放
        config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypes.all
        //设置配置的偏好
        config.preferences = preference
        //自定义JS消息的处理类
        let webview = WKWebView(frame: CGRect.zero, configuration: config)
        return webview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(self.webView)
        let constraints = [NSLayoutConstraint(item: self.webView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0), NSLayoutConstraint(item: self.webView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 0.0), NSLayoutConstraint(item: self.webView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 0.0), NSLayoutConstraint(item: self.webView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0)]
        
        self.webView.addConstraints(constraints)
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
}


class WKMessageHandler: NSObject, WKScriptMessageHandler {
    
    var handler: WKWebViewController?
    
    init(messageHandler: WKWebViewController) {
        handler = messageHandler
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.handler?.userContentController(userContentController, didReceive: message)
    }
}
