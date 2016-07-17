//
//  WebViewController.swift
//  OCR
//
//  Created by Family Account on 2016/06/19.
//  Copyright © 2016年 Family Account. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet var webView:UIWebView!
    @IBOutlet var toolbar: UIToolbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.backgroundColor = UIColor(red:0.00, green:0.83, blue:0.57, alpha:1.00)
        
        webView.delegate = self
        let rect:CGRect = self.view.frame
        webView.frame = rect
        webView.scalesPageToFit = true
        
        let url = url2
        let request: NSURLRequest = NSURLRequest(URL: url)

         webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        print("indicator on")
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        print("indicator off")
    }
    // 戻るボタンの処理
    @IBAction func back() {
        self.webView?.goBack()
    }
    
    // 進むボタンの処理
    @IBAction func forward() {
        self.webView?.goForward()
    }
    
    // 再読み込みボタンの処理
    @IBAction func refresh() {
        self.webView?.reload()
    }
    @IBAction func dismiss(){
       self.dismissViewControllerAnimated(true,completion: nil)
    }
    
}
