//
//  ViewController.swift
//  ImageCollage
//
//  Created by Sagar Thukral on 23/08/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var collageImageView : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func openCollageVCAction(_ sender: UIButton) {
        let collageVC = self.storyboard?.instantiateViewController(withIdentifier: "CollageCollectionViewController") as? CollageCollectionViewController ?? CollageCollectionViewController()
        collageVC.delegate = self
        self.navigationController?.pushViewController(collageVC, animated: true)
    }
    
}

extension ViewController : CollageDelegate {
    func collageImage(image: UIImage) {
        self.collageImageView.image = image
    }
}
