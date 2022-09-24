//
//  loadDataViewModel.swift
//  mobiletest
//
//  Created by sebastian panesso on 22/09/22.
//

import UIKit
import Combine
import CoreData

protocol LoadDataViewResponse : AnyObject {
    func isDataFetched(posts:[PostAPI])
    func isDataSaved(isSaved:Bool)
    func isStorageEmpty(isEmpty:Bool)
    func isNetworkConnected(isConnected:Bool)
}

class LoadDataViewModel {
    
    private let postAPIService:PostAPIService
    private let coreDataService:CoreDataService
    private let networkService:NetworkService
    private let context: NSManagedObjectContext
    
    weak var viewOutput : LoadDataViewResponse?
    
    private var postSusbcriber : AnyCancellable?
    
    init(networkService: NetworkService, postAPIService: PostAPIService, coreDataService: CoreDataService, context: NSManagedObjectContext) {
        self.context = context
        self.networkService = networkService
        self.postAPIService = postAPIService
        self.coreDataService = coreDataService
    }
    
    func checkNetworkConnection(){
        let haveConnection = networkService.isConnectedToNetwork()
        self.viewOutput?.isNetworkConnected(isConnected: haveConnection)
    }
    
    func checkEmptyStorage(){
        let isEmptyPosts = coreDataService.isEmptyPosts()
        self.viewOutput?.isStorageEmpty(isEmpty: isEmptyPosts)
    }
    
    func fetchPosts(){
        getPosts()
    }
    
    func storagePosts(posts:[PostAPI]){
        saveLocallyPosts(posts:posts)
    }
    
    private func getPosts() {
        postSusbcriber = self.postAPIService.fetchPosts()
            .sink(receiveCompletion: { _ in }, receiveValue: { (posts) in
                self.viewOutput?.isDataFetched(posts: posts)
            })
    }
    
    private func saveLocallyPosts(posts:[PostAPI]) {
        let storagePosts = self.coreDataService.storagePosts(posts: posts)
        self.viewOutput?.isDataSaved(isSaved: storagePosts)
    }
    
}
