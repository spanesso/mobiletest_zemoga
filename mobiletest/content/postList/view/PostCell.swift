//
//  PostCell.swift
//  mobiletest
//
//  Created by sebastian panesso on 21/09/22.
//

import Foundation
import Foundation
import UIKit

class PostCell: UITableViewCell {
    
    class var reuseIdentifier: String { get {  return "PostCell" } }
    
    @IBOutlet var postLike: UIImageView!
    @IBOutlet var postId: UILabel!
    @IBOutlet var postTitle: UILabel!
    
    func configure(post:Posts){
        postId.text = "Post ID: \(post.id)"
        postTitle.text = post.title
        postLike.isHidden = !post.favorite
    }
}


