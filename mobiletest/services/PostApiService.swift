//
//  DataManager.swift
//  mobiletest
//
//  Created by sebastian panesso on 20/09/22.
//

import UIKit
import Combine

protocol PostAPIService {
    func fetchPosts() -> AnyPublisher< [PostAPI], Error>
    func postsPublisher() -> AnyPublisher<[PostAPI], Error>
    func postCommentsPublisher(id:Int) -> AnyPublisher<[PostCommentAPI], Error>
}

class PostApiServiceImp : PostAPIService {
    
    private let urlString = "https://jsonplaceholder.typicode.com/posts"
    
    func fetchPosts() -> AnyPublisher<[PostAPI], Error> {
        return postsPublisher()
            .flatMap { postsArr in
                postsArr.publisher.setFailureType(to: Error.self)
            }.flatMap { [self] post in
                self.postCommentsPublisher(id: post.id)
                  .flatMap { comments in
                      comments.publisher.setFailureType(to: Error.self)
                  }
                  .collect()
                   .map { comments in
                      var newPost = post
                       newPost.comments = comments
                      return newPost
                   }
            }.collect()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func postsPublisher() -> AnyPublisher< [PostAPI], Error> {
       
        let url = URL(string: urlString)!
        return load(url: url)
    }
    
    func postCommentsPublisher(id:Int) -> AnyPublisher<[PostCommentAPI], Error> {
        let url = URL(string: "\(urlString)/\(id)/comments")!
        return load(url: url)
    }
        
    func load<T:Decodable>(url:URL) -> AnyPublisher<T,Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                            guard let httpResponse = response as? HTTPURLResponse,
                                      httpResponse.statusCode == 200 else {
                                        throw NetworkError.responseError
                            }
                            return data
                        }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
