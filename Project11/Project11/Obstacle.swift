//
//  Obstacles.swift
//  Project11
//
//  Created by Falmer nightprowler Fahey on 17/04/2019.
//  Copyright © 2019 School21. All rights reserved.
//

import SpriteKit

class Obstacle: NSObject {
	var obstacle: SKNode
	var live = 5
	
	init(obstacle: SKNode) {
		self.obstacle = obstacle
	}
}
