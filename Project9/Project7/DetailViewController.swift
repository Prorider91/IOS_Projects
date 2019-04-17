//
//  DetailViewController.swift
//  Project7
//
//  Created by Falmer nightprowler Fahey on 15/04/2019.
//  Copyright © 2019 School21. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

	var webView: WKWebView!
	var detailItem: Petition?
	
	override func loadView() {
		webView = WKWebView()
		view = webView
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		guard let detailItem = detailItem else { return }
		
		let html = """
		<html>
		<head>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<style> body { font-size: 150%; } </style>
		</head>
		<body>
		\(detailItem.body)
		</body>
		</html>
		"""
		
		webView.loadHTMLString(html, baseURL: nil)
    }

}
