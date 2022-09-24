//
//  Post.swift
//  mobiletest
//
//  Created by sebastian panesso on 20/09/22.
//

import Foundation

struct PostAPI : Decodable {
    var id : Int
    var title : String
    var body : String
    var comments : [PostCommentAPI]?
}

struct PostCommentAPI : Decodable {
    let id : Int
    let name : String
    let email : String
    let body : String
}

