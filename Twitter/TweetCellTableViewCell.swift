//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Julien Calfayan on 2/19/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var tweetContent: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var retweetButton: UIButton!
    
    var favorited:Bool = false
    var retweeted:Bool = false
    var tweetID:Int = -1
    
    func setFavorite(_isFavorited:Bool) {
        favorited = _isFavorited
        if (favorited) {
            likeButton.setImage(UIImage(named: "likeRed"), for: UIControl.State.normal)
        } else {
            likeButton.setImage(UIImage(named: "likeGray"), for: UIControl.State.normal)
        }
    }
    
    func setRetweet(_isRetweeted:Bool) {
        retweeted = _isRetweeted
        if (retweeted) {
            retweetButton.setImage(UIImage(named: "retweetGreen"), for: UIControl.State.normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweetGray"), for: UIControl.State.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profilePicture.layer.cornerRadius = 35
        profilePicture.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favoriteTweet(_ sender: Any) {
        let toBeFavorited = !favorited
        
        if (toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetID: tweetID, success: {
                self.setFavorite(_isFavorited: true)
            }, failure: { (error) in
                print("Favorite not succeded \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetID: tweetID, success: {
                self.setFavorite(_isFavorited: false)
            }, failure: { (error) in
                print("Unfavorite not succeded \(error)")
            })
        }
    }
    
    @IBAction func retweetTweet(_ sender: Any) {
        let toBeRetweeted = !retweeted
        
        if (toBeRetweeted) {
            TwitterAPICaller.client?.retweetTweet(tweetID: tweetID, success: {
                self.setRetweet(_isRetweeted: true)
            }, failure: { (error) in
                print("Retweet not succeded \(error)")
            })
        } else {
            TwitterAPICaller.client?.unretweetTweet(tweetID: tweetID, success: {
                self.setRetweet(_isRetweeted: false)
            }, failure: { (error) in
                print("Unretweet not succeded \(error)")
            })
        }
    }
    
}
