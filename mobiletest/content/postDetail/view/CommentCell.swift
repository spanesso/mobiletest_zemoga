//
//  CommentCell.swift
//  mobiletest
//
//  Created by sebastian panesso on 21/09/22.
//

import Foundation
import Foundation
import UIKit

class CommentCell: UITableViewCell {
    
    class var reuseIdentifier: String { get {  return "CommentCell" } }
    
    
    @IBOutlet var comment: UILabel!
    
    func configure(com:Comments){
        let email = com.email ?? ""
        let body = com.body ?? ""
        
        let attributedString = NSMutableAttributedString(string:"")
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let boldString = NSMutableAttributedString(string: "\(email): ", attributes:attrs)
        attributedString.append(boldString)
        attributedString.append(NSMutableAttributedString(string:body))
   
        comment.attributedText = attributedString
    }
    
}
