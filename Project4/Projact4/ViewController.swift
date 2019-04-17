//
//  ViewController.swift
//  Projact4
//
//  Created by Falmer nightprowler Fahey on 12/04/2019.
//  Copyright © 2019 School21. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

	var webView: WKWebView!
	var progressView: UIProgressView!
	var websites = ["apple.com", "hackingwithswift.com"]
	var website: String!
	
	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
		
		
		//let url = URL(string: "https://" + websites[0])!
		let url = URL(string: "https://" + website)!
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
		
		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		let progressButton = UIBarButtonItem(customView: progressView)
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
		let undo = UIBarButtonItem(barButtonSystemItem: .rewind , target: webView, action: #selector(webView.goBack))
		let redo = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
		toolbarItems = [progressButton, spacer, refresh, undo, redo]
		navigationController?.isToolbarHidden = false
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url
		
		
		if let host = url?.host {
			for website in websites {
				if host.contains(website) {
					decisionHandler(.allow)
					return
				}
			}
		}
		let ac = UIAlertController(title: "Error", message: "This website is blocked!", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
		present(ac, animated: true)
		decisionHandler(.cancel)
	}
	
	@objc func openTapped() {
		let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
		for website in websites {
			ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
		}
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
		present(ac, animated: true)
	}
	
	func openPage(action: UIAlertAction) {
		let url = URL(string: "https://" + action.title!)!
		webView.load(URLRequest(url: url))
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}
}

