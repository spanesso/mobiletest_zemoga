//
//  PostDetailViewModel.swift
//  mobiletest
//
//  Created by sebastian panesso on 22/09/22.
//

import UIKit
import Combine
import CoreData

protocol PostsDetailViewResponse : AnyObject {
    func getPostComments( commentsList: [Comments] )
    func getLikeStatus()
}

class PostDetailViewModel {
    
    private let coreDataService : CoreDataService
    
    weak var viewOutput : PostsDetailViewResponse?
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func onLoadView(id:Int){
        let comments = coreDataService.getPostComments(id:id)
        viewOutput?.getPostComments(commentsList:comments)
    }
    
    func toogleLike(post:Posts){
        coreDataService.likeTogglePost(post: post)
        viewOutput?.getLikeStatus()
    }
}

