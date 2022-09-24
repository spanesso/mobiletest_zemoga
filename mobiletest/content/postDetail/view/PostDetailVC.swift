//
//  PostDetail.swift
//  mobiletest
//
//  Created by sebastian panesso on 21/09/22.
//
 

import Foundation
import UIKit
import Combine
import CoreData

class PostDetailVC: BaseViewContoller,PostsDetailViewResponse {
    
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var body: UILabel!
    @IBOutlet var tableview: UITableView!
    
    private var viewModel : PostDetailViewModel!
    
    public var post:Posts!
    
    private var comments = [Comments](){
        didSet {
            tableview.reloadData()
        }
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        viewModel = PostDetailViewModel(coreDataService: CoreDataServiceImp(context: self.context))
        viewModel.viewOutput = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.onLoadView(id: Int(post.id))
    }
    
    func getPostComments(commentsList: [Comments]) {
        comments = commentsList
    }
    
    func getLikeStatus() {
        setUpNavBar()
    }
    
    private func setUpView(){
        setUpNavBar()
        setPostInfo()
        setUpTableView()
    }
    
    private func setUpNavBar(){
        title = "Post ID: \(post.id)"
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: post.favorite ? "star.fill" : "star" ), style: .plain, target: self, action: #selector(likeTapped)), animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setPostInfo(){
        postTitle.text = post.title
        body.text = post.body
    }
    
    private func setUpTableView(){
        tableview.dataSource = self
        tableview.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
    }

    @objc func likeTapped(sender: UIBarButtonItem) {
        post.favorite = !post.favorite
        viewModel.toogleLike(post: post)
    }
}

// MARK: - UITableViewDataSource

extension PostDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath) as! CommentCell
        cell.configure(com: comments[indexPath.item])
        return cell
    }
}
