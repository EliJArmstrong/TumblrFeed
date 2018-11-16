//
//  PhotoDetailsVC.swift
//  TumblrFeed
//
//  Created by Eli Armstrong on 9/30/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PhotoDetailsVC: UIViewController {
    
    public var url: URL?
    
    @IBOutlet weak var detailsImg: UIImageView!
    var passImg : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let placeholderImage = UIImage(named: "placeholder")!
        
        detailsImg.af_setImage(withURL: url!, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.2))
        
        let pinched = UIPinchGestureRecognizer(target: self, action: #selector(pinchedImg(_:)))
        detailsImg.addGestureRecognizer(pinched)
        
        Alamofire.request(url!).response { (response) in
            if response.error == nil{
                if let data = response.data{
                    self.passImg = UIImage(data: data)
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pinchedImg(_ sender: UIPinchGestureRecognizer) {
        performSegue(withIdentifier: "ToZoom", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ZoomVC
        vc.image = passImg
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
