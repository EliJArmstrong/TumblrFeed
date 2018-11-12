//
//  ZoomVC.swift
//  TumblrFeed
//
//  Created by Eli Armstrong on 11/11/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit

class ZoomVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var image : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        imageView.image = image
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
