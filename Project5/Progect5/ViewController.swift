//
//  ViewController.swift
//  Progect5
//
//  Created by Falmer nightprowler Fahey on 13/04/2019.
//  Copyright © 2019 School21. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	//MARK: Properties
	var allWords = [String]()
	var usedWords = [String]()

	//MARK: Override
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
		
		if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
			if let startWords = try? String(contentsOf: startWordsURL) {
				allWords = startWords.components(separatedBy: "\n")
			}
		}
		
		if allWords.isEmpty {
			allWords = ["silkworm"]
		}
		
		startGame()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return usedWords.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
		cell.textLabel?.text = usedWords[indexPath.row]
		return cell
	}
	
	//MARK: private methods
	
	@objc func startGame() {
		let randomIndex = Int(arc4random_uniform(UInt32(allWords.count - 1)))
		title = allWords[randomIndex]
		usedWords.removeAll(keepingCapacity: true)
		tableView.reloadData()
	}
	
	@objc func promptForAnswer() {
		let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
		ac.addTextField()
		let submitAnswer = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
			guard let answer = ac?.textFields?[0].text else { return }
			self?.submit(answer)
		}
		
		ac.addAction(submitAnswer)
		present(ac, animated: true)
	}
	
	func submit(_ answer: String) {
		let lowerAnswer = answer.lowercased()
		
		if isPossible(word: lowerAnswer) {
			if isOriginal(word: lowerAnswer) {
				if isReal(word: lowerAnswer) {
					usedWords.insert(lowerAnswer, at: 0)
					
					let indexPath = IndexPath(row: 0, section: 0)
					tableView.insertRows(at: [indexPath], with: .automatic)
					
					return
				} else {
					showErrorMessage(title: "Word not recognised", message: "You can't just make them up, you know!")
				}
			} else {
				showErrorMessage(title: "Word used already", message: "Be more original!")
			}
		} else {
			guard let title = title?.lowercased() else { return }
			showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title)")
		}
	}
	
	func isPossible(word: String) -> Bool {
		guard var tempWord = title?.lowercased(), tempWord != word else { return false }
		
		for letter in word {
			if let position = tempWord.index(of: letter) {
				tempWord.remove(at: position)
			} else {
				return false
			}
		}
		
		return true
	}
	
	func isOriginal(word: String) -> Bool {
		return !usedWords.contains(word)
	}
	
	func isReal(word: String) -> Bool {
		let checker = UITextChecker()
		let len = word.utf16.count
		if len < 3 { return false }
		let range = NSRange(location: 0, length: word.utf16.count)
		let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
		
		return misspelledRange.location == NSNotFound
	}
	
	func showErrorMessage(title: String, message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
}



