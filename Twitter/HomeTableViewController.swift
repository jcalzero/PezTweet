//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Julien Calfayan on 2/19/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func loadTweet() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 20]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (error) in
            // For a list of twitter error codes go here https://developer.twitter.com/en/docs/basics/response-codes.html
            // The error Peter and I where talking about was 429 (Too Many Requests).
            print(error.localizedDescription) // If there is an API error this will print the error code from the API.
            print("Could not retreive tweets.")
        })
    }
    
    func loadMoreTweets(){
        
        // This is Resource URL for the home timeline
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        // This is an optional parameter to get older tweets in a home timeline.
        // Without the "-1" we would get a duplicate tweet. Please goto the links for more information.
        // https://developer.twitter.com/en/docs/tweets/timelines/guides/working-with-timelines
        // https://developer.twitter.com/en/docs/tweets/timelines/api-reference/get-statuses-home_timeline.html
        let parameters = ["max_id": (tweetArray.last!["id"] as! Int64) - 1]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: parameters, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (error) in
            // For a list of twitter error codes go here https://developer.twitter.com/en/docs/basics/response-codes.html
            // The error Peter and I where talking about was 429 (Too Many Requests).
            print(error.localizedDescription) // If there is an API error this will print the error code from the API.
            print("Could not retreive tweets.")
        })
    }
    
    // MARK: - Table view data source
    @IBAction func logoutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.username.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profilePicture.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
}
