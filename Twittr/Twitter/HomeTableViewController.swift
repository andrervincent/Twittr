//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Andre Vincent on 2/17/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var tweetNum: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTweets()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        // populate tweet, username, and profile picture of the cell
    
        cell.userNameLabel.text = user["name"] as! String
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as! String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        return cell
    }
    
    func loadTweets() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 10]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: {  (tweets: [NSDictionary]) in
            // Clear remaining/lingering tweets before populating array again
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
                print("Sorry, that didn't work.")
            })
        
    }
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

}
