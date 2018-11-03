//
//  ViewController.swift
//  TumblrFeed
//
//  Created by Eli Armstrong on 9/2/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // variables
    var posts: [[String: Any]] = []
    let refreshControl = UIRefreshControl()
    let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let tryAgain = UIAlertAction(title: "Try Again", style: .default) { (action) in
            self.fetchPhotos()
        }
        self.alertController.addAction(tryAgain)
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        fetchPhotos()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        let post = posts[indexPath.row]
        
        if let photos = post["photos"] as? [[String: Any]] {
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)
            
            let placeholderImage = UIImage(named: "placeholder")!
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: cell.PhotoImg.frame.size,
                radius: 20.0
            )
            
            cell.PhotoImg.af_setImage(withURL: url!, placeholderImage: placeholderImage, filter: filter, imageTransition: .crossDissolve(0.2))
        }
        
        return cell
    }
    
    func fetchPhotos(){
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.alertController.title = "Cannot Get Photos"
                self.alertController.message = error.localizedDescription
                self.present(self.alertController, animated: true){}
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchPhotos()
        self.refreshControl.endRefreshing()
    }

}

