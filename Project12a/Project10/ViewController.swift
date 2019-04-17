//
//  ViewController.swift
//  Project10
//
//  Created by Falmer nightprowler Fahey on 16/04/2019.
//  Copyright © 2019 School21. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	var people = [Person]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
		
		let defaults = UserDefaults.standard
		
		if let savedPeople = defaults.object(forKey: "people") as? Data {
			if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] ?? [Person]() {
				people = decodedPeople
			}
		}
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return people.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
			fatalError("Unable to dequeue PersonCell.")
		}
		
		let person = people[indexPath.item]
		
		cell.name.text = person.name
		
		let path = getDocumentDirectory().appendingPathComponent(person.image)
		cell.imageView.image = UIImage(contentsOfFile: path.path)
		
		cell.imageView.layer.borderWidth = 2
		cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
		cell.imageView.layer.cornerRadius = 3
		cell.layer.cornerRadius = 7
		
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let person = people[indexPath.item]
		
		let ac1 = UIAlertController(title: "Select action", message: nil, preferredStyle: .alert)
		
		ac1.addAction(UIAlertAction(title: "Delete", style: .default))
		ac1.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [weak self, weak person]_ in
			let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
			
			ac.addTextField()
			
			ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
			
			ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
				guard let newName = ac?.textFields?[0].text else { return }
				person?.name = newName
				
				self?.collectionView?.reloadData()
				self?.save()
			})
			
			self?.present(ac, animated: true)
		}))
		
		present(ac1, animated: true)
	}
	
	@objc func renamePerson(person: Person) {
		
		
	}

	@objc func addNewPerson() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
		
		let imageName = UUID().uuidString
		let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
		print(imagePath)
		
		if let jpegData = UIImageJPEGRepresentation(image, 0.8) {
			try? jpegData.write(to: imagePath)
		}
		
		let person = Person(name: "Unknown", image: imageName)
		people.append(person)
		collectionView?.reloadData()
		save()
		
		dismiss(animated: true)
	}
	
	func getDocumentDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	
	func save() {
		let savedData = NSKeyedArchiver.archivedData(withRootObject: people)
		let defaults = UserDefaults.standard
		defaults.set(savedData, forKey: "people")
	}
}
