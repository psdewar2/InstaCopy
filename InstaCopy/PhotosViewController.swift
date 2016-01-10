//
//  PhotosViewController.swift
//  InstaCopy
//
//  Created by Peyt Spencer Dewar on 1/9/16.
//  Copyright © 2016 PSD. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var instaTable: UITableView!
    
    var results: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instaTable.dataSource = self
        instaTable.delegate = self

        // Do any additional setup after loading the view.
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.results = responseDictionary["data"] as! [NSDictionary]
                            self.instaTable.reloadData()
                    }
                }
        });
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //REQUIRED methods of UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InstaCell", forIndexPath: indexPath) as! InstaCell
        
        let result: NSDictionary
        result = results![indexPath.section]

        //displays user's popular pictures
        let result_images = result["images"] as! NSDictionary
        let result_lowResolution = result_images["standard_resolution"] as! NSDictionary
        let result_url = result_lowResolution["url"] as! String
        
        let popularPicUrl = NSURL(string: result_url)
        cell.popularPic.setImageWithURL(popularPicUrl!)
        
        let result_likes = result["likes"] as! NSDictionary
        let result_likeCount = result_likes["count"] as! Int
        
        cell.likeCountText.text = String("Likes: \(result_likeCount)")
        cell.likeCountText.sizeToFit()
        
        return cell
            }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //if images is not nil then
        if let results = results {
            print("PSD \(results.count) <----")
            return results.count
            
        } else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let result: NSDictionary
        result = results![section]
        
        //for username
        let result_user = result["user"] as! NSDictionary
        let result_username = result_user["username"] as! String
        
        let result_profPicUrl = result_user["profile_picture"] as! String
        let profilePicUrl = NSURL(string: result_profPicUrl)
        
        //cell.usernamePic.setImageWithURL(profilePicUrl!)
        //cell.usernameText.text = result_username

        //transparent white bar
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
    
        //mini circle
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
    
        // Use the section number to get the right URL
        profileView.setImageWithURL(profilePicUrl!)
        headerView.addSubview(profileView)
    
        // Add a UILabel for the username here
        let usernameText = UILabel(frame: CGRect(x: 45, y: 10, width: 200, height: 30))
        usernameText.font = UIFont(name: usernameText.font!.fontName, size: 14)
        usernameText.textAlignment = NSTextAlignment.Left
        usernameText.textColor = UIColor(red:0.071, green:0.337, blue:0.533, alpha:1)
        
        usernameText.text = result_username
        headerView.addSubview(usernameText)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
