//
//  ViewController.swift
//  Project7
//
//  Created by Falmer nightprowler Fahey on 13/04/2019.
//  Copyright © 2019 School21. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

	var petitions = [Petition]()
	var filtredPetitions = [Petition]()
	var filterString: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let urlString: String
		
		if navigationController?.tabBarItem.tag == 0 {
			urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
		} else {
			urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
		}
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showCredits))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "filter", style: .plain, target: self, action: #selector(setFilter))
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parse(json: data)
			} else {
				showError()
			}
		} else {
			showError()
		}
		
		filtredPetitions = petitions
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filtredPetitions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let petition = filtredPetitions[indexPath.row]
		cell.textLabel?.text = petition.title
		cell.detailTextLabel?.text = petition.body
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = DetailViewController()
		vc.detailItem = petitions[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func parse(json: Data) {
		let decoder = JSONDecoder()
		
		if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
			petitions = jsonPetitions.results
			tableView.reloadData()
		}
	}
	
	func showError() {
		
		let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	
	@objc func showCredits() {
		let ac = UIAlertController(title: "Info", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	
	@objc func setFilter() {
		let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
		ac.addTextField(configurationHandler: nil)
		ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] action in
			if let filterString = ac?.textFields?[0].text, filterString != "" {
				self?.filter(filterString)
			} else {
				self?.noFilter()
			}
		})
		present(ac, animated: true)
	}
	
	func filter(_ filter: String) {
		filtredPetitions.removeAll()
		filtredPetitions = petitions.filter( { petition in
			return petition.title.contains(filter) || petition.body.contains(filter)
		})
		title = filter
		tableView.reloadData()
	}
	
	func noFilter() {
		filtredPetitions = petitions
		title = "no filter"
		tableView.reloadData()
	}
}

