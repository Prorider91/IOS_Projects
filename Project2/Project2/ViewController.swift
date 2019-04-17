//
//  ViewController.swift
//  Project2
//
//  Created by Falmer nightprowler Fahey on 12/04/2019.
//  Copyright © 2019 School21. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var button1: UIButton!
	@IBOutlet weak var button2: UIButton!
	@IBOutlet weak var button3: UIButton!
	
	var countries = [String]()
	var score = 0
	var correctAnswer = 0
	var roundCounter = 0
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
		
		button1.layer.borderWidth = 1
		button2.layer.borderWidth = 1
		button3.layer.borderWidth = 1
		
		button1.layer.borderColor = UIColor.lightGray.cgColor
		button2.layer.borderColor = UIColor.lightGray.cgColor
		button3.layer.borderColor = UIColor.lightGray.cgColor
		askQuestion()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showScore))
	}

	func askQuestion(action: UIAlertAction! = nil) {
		
		countries.shuffle()
		correctAnswer = Int(arc4random_uniform(3))
		title = countries[correctAnswer].uppercased() + " \(score)"

		button1.setImage(UIImage(named: countries[0]), for: .normal)
		button2.setImage(UIImage(named: countries[1]), for: .normal)
		button3.setImage(UIImage(named: countries[2]), for: .normal)
	}
	
	@objc func showScore() {
		let ac = UIAlertController(title: "Score", message: "Your score is \(score)", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		present(ac, animated: true)
	}

	@IBAction func buttonTapped(_ sender: UIButton) {
		var title: String
		
		if sender.tag == correctAnswer {
			title = "Correct"
			score += 1
		} else {
			title = "Wrong! That's the flag of \(countries[sender.tag].capitalized)"
			score -= 1
		}
		roundCounter += 1
		
		if roundCounter < 10 {
			let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
			present(ac, animated: true)
		} else {
			let ac  = UIAlertController(title: title, message: "Game over! final score is \(score)", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(ac, animated: true)
		}
	}
}

extension MutableCollection {
	/// Shuffles the contents of this collection.
	mutating func shuffle() {
		let c = count
		guard c > 1 else { return }
		
		for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
			// Change `Int` in the next line to `IndexDistance` in < Swift 4.1
			let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
			let i = index(firstUnshuffled, offsetBy: d)
			swapAt(firstUnshuffled, i)
		}
	}
}

