//
//  CoreDataTransactionManager.swift
//  mobiletest
//
//  Created by sebastian panesso on 21/09/22.
//

import Foundation
import Combine
import CoreData
import UIKit

protocol CoreDataService {
    func getPosts() -> [Posts]
    func isEmptyPosts() -> Bool
    func likeTogglePost(post:Posts)
    func deletePost(post:Posts)
    func storagePosts(posts:[PostAPI])-> Bool
    func getPostComments(id:Int) -> [Comments]
    func getLikePosts() -> [Posts]
    func deleteAllData(entity: String)
}

class CoreDataServiceImp:CoreDataService {
    
    
    var context: NSManagedObjectContext!
    
    init(context:NSManagedObjectContext){
        self.context = context
    }
    
    // MARK: - Save data from API call
    
    
    func storagePosts(posts:[PostAPI])-> Bool {
        
        var  isDataSaved = true
        
        if let postList = posts as [PostAPI]? ,
           postList.count > 0 {
            
            posts.forEach { post in
                
                let idPost = Int32(post.id)
                
                let storagePost = Posts(context: self.context)
                storagePost.id = idPost
                storagePost.title = post.title
                storagePost.body = post.body
                storagePost.favorite = false
                
                post.comments?.forEach { comment in
                    
                    let storageComment = Comments(context: self.context)
                    storageComment.id = Int32(comment.id)
                    storageComment.idPost = idPost
                    storageComment.body = comment.body
                    storageComment.email = comment.email
                    storageComment.name = comment.name
                }
                
                do {
                    try self.context.save()
                } catch {
                    isDataSaved = false
                }
            }
        } else {
            isDataSaved = false
        }
        
        return isDataSaved
    }
    
    func getPosts() -> [Posts]{
        var posts = [Posts]()
        do {
            
            let fetchRequest: NSFetchRequest<Posts> = Posts.fetchRequest()
            let descriptors = [NSSortDescriptor(key: "favorite", ascending: false)]
            fetchRequest.sortDescriptors = descriptors
            
            posts = try context.fetch(fetchRequest)
        }catch {}
        
        return posts
    }
    
    func getLikePosts() -> [Posts]{
        var likePosts = [Posts]()
        do {
            let fetchRequest: NSFetchRequest<Posts>
            fetchRequest = Posts.fetchRequest()
            fetchRequest.predicate = NSPredicate( format: "favorite = %@", NSNumber(value: true) )
            likePosts = try context.fetch(fetchRequest)
        }catch {
            
        }
        return likePosts
    }
    
    func getPostComments(id:Int) -> [Comments]{
        var comments = [Comments]()
        do {
            let fetchRequest: NSFetchRequest<Comments>
            fetchRequest = Comments.fetchRequest()
            fetchRequest.predicate = NSPredicate( format: "idPost = %d", id )
            comments = try context.fetch(fetchRequest)
        }catch {
            
        }
        return comments
    }
    
    
    func isEmptyPosts() -> Bool {
        let fetchRequest = NSFetchRequest<Posts>(entityName: "Posts")
        do {
            let result = try context.fetch(fetchRequest)
            return result.isEmpty
        } catch {
            return true
        }
    }
    
    func likeTogglePost(post:Posts) {
        let postEdited = post
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func deletePost(post:Posts){
        context.delete(post)
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func deleteAllData(entity: String) {
        let fetchResult = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let request = NSBatchDeleteRequest(fetchRequest: fetchResult)
        do { try context.execute(request) }
        catch { print(error) }
    }
    
}

