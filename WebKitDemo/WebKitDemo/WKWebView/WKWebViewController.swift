//
//  WKWebViewController.swift
//  WebKitDemo
//
//  Created by BriceZhao on 2019/9/23.
//  Copyright © 2019 BriceZhao. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    
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
        //自定义WKScriptMessageHandler为了解决内存不释放的问题
        let handler = WKMessageHandler(messageHandler: self)
        //这个类主要用来做native和Javascript的交互管理
        let userCtrl = WKUserContentController()
        userCtrl.add(handler, name: "backToFront")
        userCtrl.add(handler, name: "jsToOcWithPrams")
        config.userContentController = userCtrl
        //以下代码适配文本大小
        let jsString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkScript = WKUserScript(source: jsString, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(wkScript)
        
        //自定义JS消息的处理类
        let webview = WKWebView(frame: self.view.bounds, configuration: config)
        webview.navigationDelegate = self
        webview.allowsBackForwardNavigationGestures = true
        return webview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(self.webView)
        //本地服务器HTML文件地址
        let url = URL(string: "http://127.0.0.1/JStoOC.html")
        let request = URLRequest(url: url!)
        webView.load(request)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("name:\(message.name)\\\n body:\(message.body)\\\n frameInfo:\(message.frameInfo)\\\n")
        
        
        let parameter = message.body as! [String : String]
        if message.name == "backToFront" {
            navigationController?.popViewController(animated: true)
        } else if message.name == "jsToOcWithPrams" {
            let alert = UIAlertController(title: "JS调用到了OC", message: parameter["params"], preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" && webView.isEqual(object) {
            
        }
        else if keyPath == "title" && webView.isEqual(object) {
            self.navigationItem.title = webView.title;
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: WKNavigationDelegate主要处理一些跳转、加载处理操作，WKUIDelegate主要处理JS脚本，确认框，警告框等
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        getCookie()
    }
    
    func getCookie() -> Void {
        let cookieStorage = HTTPCookieStorage.shared;
        var jsCookieString = "function setCookie(name,value,expires){var oDate=new Date();oDate.setDate(oDate.getDate()+expires);document.cookie=name+'='+value+';expires='+oDate+';path=/'}function getCookie(name){var arr = document.cookie.match(new RegExp('(^| )'+name+'=([^;]*)(;|$)'));if(arr != null) return unescape(arr[2]); return null;}function delCookie(name){var exp = new Date();exp.setTime(exp.getTime() - 1);var cval=getCookie(name);if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();}"
        //拼接JS字符串
        cookieStorage.cookies?.forEach({ (cookie) in
            let excuteJsString = "setCookie('\(cookie.name)', '\(cookie.value)', 1);"
            jsCookieString.append(excuteJsString)
        })
        webView.evaluateJavaScript(jsCookieString, completionHandler: nil)
    }
    
    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "backToFront")
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "jsToOcWithPrams")
        webView.removeObserver(self, forKeyPath: "title")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
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
