//
//  mobiletestTests.swift
//  mobiletestTests
//
//  Created by sebastian panesso on 20/09/22.
//

import XCTest
import Combine
import CoreData
@testable import mobiletest


class mobiletestTests: XCTestCase {
    
    var viewModel : LoadDataViewModel!
    
    var coreServices : MockCoreDataService!
    var networkService : MockNetworkService!
    var postAPIServices : MockPostAPIServices!
    
    var viewModelViewResponse : MockLoadDataViewResponse!

    override func setUp() {
        super.setUp()
        
        let persistentStoreDescription = NSPersistentStoreDescription()
               persistentStoreDescription.type = NSInMemoryStoreType

               let container = NSPersistentContainer(name: "mobiletest")
               container.persistentStoreDescriptions = [persistentStoreDescription]
               container.loadPersistentStores { (storeDescription, error) in
                   if let error = error {
                       fatalError(error.localizedDescription)
                   }
               }

        let context = container.viewContext
        
        coreServices = MockCoreDataService()
        networkService = MockNetworkService()
        postAPIServices = MockPostAPIServices()
        
        viewModelViewResponse = MockLoadDataViewResponse()
        
        viewModel = LoadDataViewModel(networkService: networkService, postAPIService: postAPIServices, coreDataService: coreServices, context: context)
        
        viewModel.viewOutput = viewModelViewResponse
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //GET API TESTING
    
    func testFetchPostList_onViewDidLoadWithSuccess() {
        
        let posts:[PostAPI] = [
            .init(id: 1, title: "Post titile 1", body: "Post body 1"),
            .init(id: 2, title: "Post titile 2", body: "Post body 2"),
            .init(id: 3, title: "Post titile 3", body: "Post body 3")
        ]
    
        postAPIServices.getPostResult = CurrentValueSubject(posts).eraseToAnyPublisher()
        
        viewModel.fetchPosts()
        
        XCTAssertEqual(viewModelViewResponse.postsArray.count,3)
    }
    
    func testFetchPostList_onViewDidLoadWithError() {
        
        postAPIServices.getPostResult = Fail(error: NSError()).eraseToAnyPublisher()
        
        viewModel.fetchPosts()
        
        XCTAssertEqual(viewModelViewResponse.postsArray.count,0)
    }
    
    //STORAGE DATA TESTING
    
    func testStoragePostList_onViewDidLoadWithSuccess() {
        
        let posts:[PostAPI] = [
            .init(id: 1, title: "Post titile 1", body: "Post body 1"),
            .init(id: 2, title: "Post titile 2", body: "Post body 2"),
            .init(id: 3, title: "Post titile 3", body: "Post body 3")
        ]
    
        coreServices.postAPIList = posts
        
        viewModel.storagePosts(posts: posts )
        
        XCTAssertEqual(viewModelViewResponse.isDataSaved,true)
    }
    
    func testStoragePostList_onViewDidLoadWithError() {
        
        let posts:[PostAPI] = []
    
        coreServices.postAPIList = posts
        
        viewModel.storagePosts(posts: posts )
        
        XCTAssertEqual(viewModelViewResponse.isDataSaved,false)
    }
    
    //NETWORK TESTING
    
    func testChecNetWorkConnectionWithSuccess() {
        
        networkService.isConnected = true
        
        viewModel.checkNetworkConnection()
        
        XCTAssertEqual(viewModelViewResponse.isNetworkConnected,true)
    }
    
    func testChecNetWorkConnectionWithError() {
        
        networkService.isConnected = false
        
        viewModel.checkNetworkConnection()
        
        XCTAssertEqual(viewModelViewResponse.isNetworkConnected,false)
    }
    
    //EMPTY DATA TESTING
    
    func testChecEmptyDataWithSuccess() {
        
        coreServices.isEmptyPost = true
        
        viewModel.checkEmptyStorage()
        
        XCTAssertEqual(viewModelViewResponse.isStorageEmpty,true)
    }
    
    func testChecEmptyDataWithError() {
        
        coreServices.isEmptyPost = false
        
        viewModel.checkEmptyStorage()
        
        XCTAssertEqual(viewModelViewResponse.isStorageEmpty,false)
    }

}

class MockPostAPIServices : PostAPIService {

    var getPostResult : AnyPublisher<[mobiletest.PostAPI], Error>?
    func fetchPosts() -> AnyPublisher<[mobiletest.PostAPI], Error> {
        if let result = getPostResult {
            return result
        } else {
            fatalError("Result can't be nil")
        }
    }


    var getPostResultPublisher : AnyPublisher<[mobiletest.PostAPI], Error>?
    func postsPublisher() -> AnyPublisher<[mobiletest.PostAPI], Error> {
        if let result = getPostResultPublisher {
            return result
        } else {
            fatalError("Result can't be nil")
        }
    }

    var getPostCommentsResultPublisher : AnyPublisher<[mobiletest.PostCommentAPI], Error>?
    func postCommentsPublisher(id: Int) -> AnyPublisher<[mobiletest.PostCommentAPI], Error> {
        if let result = getPostCommentsResultPublisher {
            return result
        } else {
            fatalError("Result can't be nil")
        }
    }

}

class MockCoreDataService : CoreDataService {
    
    var postAPIList : [mobiletest.PostAPI]?
    func storagePosts(posts: [mobiletest.PostAPI]) -> Bool {
        if let isStorage = postAPIList{
            if isStorage.count > 0 {
                return true
            } else {
                return false
            }
        } else {
            fatalError("Result can't be nil")
        }
    }
    
    var getPostResult : [mobiletest.Posts]?
    func getPosts() -> [mobiletest.Posts] {
        if let result = getPostResult {
             return result
        } else {
         fatalError("Result can't be nil")
        }
    }
    
    var isEmptyPost : Bool?
    func isEmptyPosts() -> Bool {
        if let isEmpty = isEmptyPost{
            return isEmpty
        } else {
            fatalError("Result can't be nil")
        }
    }
    
    
    
    var getPostCommentsResult : [mobiletest.Comments]?
    func getPostComments(id: Int) -> [mobiletest.Comments] {
        if let result = getPostCommentsResult {
             return result
        } else {
         fatalError("Result can't be nil")
        }
    }
    
    var getLikesPostResult : [mobiletest.Posts]?
    func getLikePosts() -> [mobiletest.Posts] {
        if let result = getLikesPostResult {
             return result
        } else {
         fatalError("Result can't be nil")
        }
    }
    
    func deleteAllData(entity: String) {
        print("delete al local storage posts and comments")
    }
    
    func likeTogglePost(post: mobiletest.Posts) {
        print("toogle of post like or dislike")
    }
    
    func deletePost(post: mobiletest.Posts) {
        print("delete post")
    }
}

class MockNetworkService : NetworkService {
    var isConnected : Bool?
    func isConnectedToNetwork() -> Bool {
        if let connected = isConnected{
            return connected
        } else {
            fatalError("Result can't be nil")
        }
    }
}

                                    
class MockLoadDataViewResponse : LoadDataViewResponse {
    
    var postsArray : [mobiletest.PostAPI] = []
    func isDataFetched(posts: [mobiletest.PostAPI]) {
        postsArray = posts
    }

    var isDataSaved = false
    func isDataSaved(isSaved: Bool) {
        isDataSaved = isSaved
    }

    var isStorageEmpty = false
    func isStorageEmpty(isEmpty: Bool) {
        isStorageEmpty = isEmpty
    }

    var isNetworkConnected = false
    func isNetworkConnected(isConnected: Bool) {
        isNetworkConnected = isConnected
    }
  
}
