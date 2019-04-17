//
//  DetailViewController.swift
//  Project1
//
//  Created by Falmer nightprowler Fahey on 11/04/2019.
//  Copyright © 2019 School21. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
	@IBOutlet var imageView: UIImageView!
	
	var selectedImage: String?
	var imageNumber: Int?
	var imagesCount: Int?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		if let ic = imagesCount, let inum = imageNumber {
			title = "Picture \(inum) of \(ic)"
		} else {
			title = selectedImage
		}
		navigationItem.largeTitleDisplayMode = .never
		
		if let loadImage = selectedImage {
			imageView.image = UIImage(named: loadImage)
		}
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.hidesBarsOnTap = false
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
