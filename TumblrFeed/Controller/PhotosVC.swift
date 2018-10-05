//
//  ViewController.swift
//  TumblrFeed
//
//  Created by Eli Armstrong on 9/2/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var posts: [[String: Any]] = []
    let refreshControl = UIRefreshControl()
    let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
    
    
    
    // Main views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let tryAgain = UIAlertAction(title: "Try Again", style: .default) { (action) in
            self.fetchPhotos()
        }
        self.alertController.addAction(tryAgain)
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControl.Event.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        fetchPhotos()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    // Table view controls
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("\n \(posts[section].count) \n")
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 0, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor =  UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // Set the avatar
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        // Add a UILabel for the date here
        // Use the section number to get the right URL
        let label = UILabel(frame: CGRect(x: 50, y: 10, width: 320, height: 50))
        label.textColor = UIColor(white: 1, alpha: 1)
        let post = posts[section]
        let date = Date(timeIntervalSince1970: (post["timestamp"] as! Double))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        label.text = dateFormatter.string(from: date)
        label.font = UIFont(name: "Helvetica Neue", size: 17)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        headerView.addSubview(label)
        
        
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        let post = posts[indexPath.section]
        
        if let photos = post["photos"] as? [[String: Any]] {
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)
            
            let placeholderImage = UIImage(named: "placeholder")!
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: cell.photoImg.frame.size,
                radius: 20.0
            )
            
            cell.photoImg.af_setImage(withURL: url!, placeholderImage: placeholderImage, filter: filter, imageTransition: .crossDissolve(0.2))
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Fetch the photos from tumblr
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
                //print(dataDictionary)
                
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoDetailsVC
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
            let post = posts[indexPath.section]
            let photos = post["photos"] as! [[String: Any]]
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)
            vc.url = url
        }
        
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchPhotos()
        self.refreshControl.endRefreshing()
    }
    
}

