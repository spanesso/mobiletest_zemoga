//
//  PostListViewModel.swift
//  mobiletest
//
//  Created by sebastian panesso on 22/09/22.
//

import Foundation


protocol PostsListViewResponse : AnyObject {
    func getPostList( posts:[Posts] )
    func postDeleted()
    func dataBaseDeleted()
}

class PostListViewModel {
    private let coreDataService : CoreDataService
    
    weak var viewOutput : PostsListViewResponse?
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func fetchStoragePosts(){
        getPosts()
    }
    
    func getLikeList(){
        getLikePosts()
    }
    
    func getPostFromAPI(){
        callAPIPosts()
    }
    
    func deletePost(post:Posts){
        coreDataService.deletePost(post:post )
        viewOutput?.postDeleted()
    }
    
    private func getPosts(){
        let posts = coreDataService.getPosts()
        viewOutput?.getPostList(posts: posts)
    }
    
    private func getLikePosts(){
        let posts = coreDataService.getLikePosts()
        viewOutput?.getPostList(posts: posts)
    }
    
    private func callAPIPosts(){
        coreDataService.deleteAllData(entity: "Posts")
        coreDataService.deleteAllData(entity: "Comments")
        viewOutput?.dataBaseDeleted()
    }
}
