//
//  PhotoDetailsVC.swift
//  TumblrFeed
//
//  Created by Eli Armstrong on 9/30/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotoDetailsVC: UIViewController {
    
    public var url: URL?
    @IBOutlet weak var detailsImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let placeholderImage = UIImage(named: "placeholder")!
        
        detailsImg.af_setImage(withURL: url!, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.2))
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
