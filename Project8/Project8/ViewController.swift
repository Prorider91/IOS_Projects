//
//  ViewController.swift
//  Project8
//
//  Created by Falmer nightprowler Fahey on 15/04/2019.
//  Copyright © 2019 School21. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var cluesLabel: UILabel!
	var answersLabel: UILabel!
	var currentAnswer: UITextField!
	var scoreLabel:	UILabel!
	var letterButtons = [UIButton]()
	
	var activatedButtons = [UIButton]()
	var solutions = [String]()
	
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
			if oldValue < score {
				realScore += 1
			}
		}
	}
	var realScore = 0
	
	var level = 1
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .white
		
		scoreLabel = UILabel()
		scoreLabel.translatesAutoresizingMaskIntoConstraints = false
		scoreLabel.textAlignment = .right
		scoreLabel.text = "Score: 0"
		view.addSubview(scoreLabel)
		
		cluesLabel = UILabel()
		cluesLabel.translatesAutoresizingMaskIntoConstraints = false
		cluesLabel.font = UIFont.systemFont(ofSize: 24)
		cluesLabel.text = "CLUES"
		cluesLabel.numberOfLines = 0
		view.addSubview(cluesLabel)
		
		answersLabel = UILabel()
		answersLabel.translatesAutoresizingMaskIntoConstraints = false
		answersLabel.font = UIFont.systemFont(ofSize: 24)
		answersLabel.text = "ANSWERS"
		answersLabel.numberOfLines = 0
		view.addSubview(answersLabel)
		
		currentAnswer = UITextField()
		currentAnswer.translatesAutoresizingMaskIntoConstraints	= false
		currentAnswer.placeholder = "Tap letters to guess"
		currentAnswer.textAlignment = .center
		currentAnswer.font = UIFont.systemFont(ofSize: 44)
		currentAnswer.isUserInteractionEnabled = false
		view.addSubview(currentAnswer)
		
		let submit = UIButton(type: .system)
		submit.translatesAutoresizingMaskIntoConstraints = false
		submit.setTitle("SUBMIT", for: .normal)
		submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
		view.addSubview(submit)
		
		let clear = UIButton(type: .system)
		clear.translatesAutoresizingMaskIntoConstraints	= false
		clear.setTitle("CLEAR", for: .normal)
		clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
		view.addSubview(clear)
		
		let buttonsView = UIView()
		buttonsView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(buttonsView)
		
		NSLayoutConstraint.activate([
				scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
				scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
				
				cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
				cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
				cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
				
				answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
				answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
				answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
				answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
				
				currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
				currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
				
				submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
				submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
				submit.heightAnchor.constraint(equalToConstant: 44),
				
				clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
				clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
				clear.heightAnchor.constraint(equalToConstant: 44),
				
				buttonsView.widthAnchor.constraint(equalToConstant: 750),
				buttonsView.heightAnchor.constraint(equalToConstant: 350),
				buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
				buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
		])
		
		// set some values for the width and height of each button
		let width = 150
		let heigth = 80
		
		//create 20 buttons as a 4x5 grid
		for row in 0..<4 {
			for col in 0..<5 {
				let letterButton = UIButton(type: .system)
				letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
				letterButton.setTitle("WWW", for: .normal)
				letterButton.layer.borderWidth = 1
				letterButton.layer.borderColor = UIColor.lightGray.cgColor
				
				let frame = CGRect(x: col * width, y: row * heigth, width: width, height: heigth)
				letterButton.frame = frame
				
				letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
				
				buttonsView.addSubview(letterButton)
				letterButtons.append(letterButton)
			}
		}
		
		cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
		answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)

	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		performSelector(inBackground: #selector(loadLevel), with: nil)
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	@objc func loadLevel() {
		var clueString = ""
		var solutionString = ""
		var letterBits = [String]()
		
		if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
			if let levelContents = try? String(contentsOf: levelFileURL) {
				var lines = levelContents.components(separatedBy: "\n")
				lines.shuffle()
				
				for (index, line) in lines.enumerated() {
					let patrs = line.components(separatedBy: ": ")
					let answer = patrs[0]
					let clue = patrs[1]
					
					clueString += "\(index + 1). \(clue)\n"
					
					let solutionWord = answer.replacingOccurrences(of: "|", with: "")
					solutionString += "\(solutionWord.count) letters\n"
					solutions.append(solutionWord)
					
					let bits = answer.components(separatedBy: "|")
					letterBits += bits
				}
			}
		}
		
		DispatchQueue.main.async { [weak self] in
			self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
			self?.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
		
		
			letterBits.shuffle()
		
			if letterBits.count == self?.letterButtons.count, let count = self?.letterButtons.count {
				for i in 0..<count {
					self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
				}
			}
		}
	}
	
	func levelUp(action: UIAlertAction) {
		level += 1
		solutions.removeAll()
		
		performSelector(inBackground: #selector(loadLevel), with: nil)
		
		for btn in letterButtons {
			btn.isHidden = false
		}
	}
	
	@objc func letterTapped(_ sender: UIButton) {
		guard let buttonTitle = sender.titleLabel?.text else { return }
		currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
		activatedButtons.append(sender)
		sender.isHidden = true
	}
	
	@objc func submitTapped(_ sender: UIButton) {
		guard let answerText = currentAnswer.text else { return }
		
		if let solutionPosition = solutions.index(of: answerText) {
			activatedButtons.removeAll()
			
			var splitAnswer = answersLabel.text?.components(separatedBy: "\n")
			splitAnswer?[solutionPosition] = answerText
			answersLabel.text = splitAnswer?.joined(separator: "\n")
			
			currentAnswer.text = ""
			score += 1
			
			if realScore % 7 == 0 {
				let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
				ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
				present(ac, animated: true)
			}
		} else {
			let ac = UIAlertController(title: "Incorrect guess", message: "You are wrong!\nTry again", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Got it", style: .default, handler: { [ weak self ]_ in
				self?.clearTapped(nil)
			}))
			present(ac, animated: true)
			score -= 1
		}
	}
	
	@objc func clearTapped(_ sender: UIButton?) {
		currentAnswer.text = ""
		
		for button in activatedButtons {
			button.isHidden = false
		}
		
		activatedButtons.removeAll()
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

