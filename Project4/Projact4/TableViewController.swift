//
//  TableViewController.swift
//  Projact4
//
//  Created by Falmer nightprowler Fahey on 12/04/2019.
//  Copyright © 2019 School21. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

	var websites = ["apple.com", "hackingwithswift.com"]
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)
		cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "WebPage") as? ViewController {
			vc.website = websites[indexPath.row]
			navigationController?.pushViewController(vc, animated: true)
		}
	}

}
