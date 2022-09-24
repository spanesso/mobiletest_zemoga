//
//  mobiletestPersistenceContainerTests.swift
//  mobiletestTests
//
//  Created by sebastian panesso on 24/09/22.
//

import XCTest
import CoreData
@testable import mobiletest

final class mobiletestPersistenceContainerTests: XCTestCase {
    
    var viewModel : PostListViewModel!
    var coreServices : MockCoreDataService!
    
    var testPersistentContainer: NSPersistentContainer?
    var context: NSManagedObjectContext?
    
    var viewPostsListViewResponse : MockPostsListViewResponse!

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

               self.testPersistentContainer = container
               self.context = self.testPersistentContainer?.viewContext
        
        
        coreServices = MockCoreDataService()
        
        viewPostsListViewResponse = MockPostsListViewResponse()
        
        viewModel = PostListViewModel(coreDataService: coreServices)
        viewModel.viewOutput  = viewPostsListViewResponse
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testPersistenceContainerNotNil() {
        XCTAssertNotNil(self.testPersistentContainer)
    }
    
    func testPersistenceContextNotNil() {
        XCTAssertNotNil(self.context)
    }
    
    func testPersistencePosts() {
        
        guard let context = context else {
            fatalError("persistence context should not be nil")
        }
        
        let posts:[PostAPI] = [
            .init(id: 1, title: "Post titile 1", body: "Post body 1"),
            .init(id: 2, title: "Post titile 2", body: "Post body 2"),
            .init(id: 3, title: "Post titile 3", body: "Post body 3")
        ]
        
        var postsStorage:[Posts] = []
        
        posts.forEach { post in
            
            let idPost = Int32(post.id)
            
            let storagePost = Posts(context: context)
            storagePost.id = idPost
            storagePost.title = post.title
            storagePost.body = post.body
            storagePost.favorite = false
            
            do {
                try context.save()
                postsStorage.append(storagePost)
            } catch {
                fatalError("context can't persistence data")
            }
        }
        
        coreServices.getPostResult = postsStorage
        
        viewModel.fetchStoragePosts()
        
        XCTAssertEqual(viewPostsListViewResponse.postsArray.count,3)
        
    }

}



class MockPostsListViewResponse : PostsListViewResponse {
   
    var postsArray : [mobiletest.Posts] = []
    func getPostList(posts: [mobiletest.Posts]) {
        postsArray = posts
    }
    
    var isPostDeleted = false
    func postDeleted() {
        isPostDeleted = true
    }
    
    var isDataBaseDeleted = false
    func dataBaseDeleted() {
        isDataBaseDeleted = true
    }
    
}
