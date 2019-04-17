//
//  Person.swift
//  Project10
//
//  Created by Falmer nightprowler Fahey on 16/04/2019.
//  Copyright © 2019 School21. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
	
	var name: String
	var image: String
	
	init(name: String, image: String) {
		self.name = name
		self.image = image
	}
	
	required init(coder aDecoder: NSCoder) {
		name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
		image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: "name")
		aCoder.encode(image, forKey: "image")
	}
}
