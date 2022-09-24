//
//  PostListVC.swift
//  mobiletest
//
//  Created by sebastian panesso on 21/09/22.
//


import Foundation
import UIKit
import Combine

class PostListVC: BaseViewContoller,PostsListViewResponse {
    
    @IBOutlet var tableview: UITableView!
    
    private var viewModel : PostListViewModel!
    private var selectedPost:Posts?
    private var posts = [Posts](){
        didSet {
            tableview.reloadData()
        }
    }
    
    var isLikesSelected = false
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        viewModel = PostListViewModel(coreDataService: CoreDataServiceImp(context: self.context))
        viewModel.viewOutput = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchStoragePosts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetailSegue",
           let selectedPost = selectedPost,
           let postDetailVC = segue.destination as? PostDetailVC {
            postDetailVC.post = selectedPost
        }
    }
    
    // MARK: - Private functions
    
    private func setUpView(){
        setUpNavBar()
        setUpTableView()
    }
    
    private func setUpNavBar(){
        title = "Posts"
        navigationItem.setHidesBackButton(true, animated: false)
        
        let likes = UIBarButtonItem(image: UIImage(systemName: isLikesSelected ? "list.clipboard" : "star" ), style: .plain, target: self, action: #selector(showLikePost))
        let webApi = UIBarButtonItem(image: UIImage(systemName:  "globe" ), style: .plain, target: self, action: #selector(getWebAPIPosts))
        navigationItem.rightBarButtonItems = [likes, webApi]
 
    }
    
    private func setUpTableView(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
    }
    
    // MARK: - Protocol functions
    
    func getPostList(posts: [Posts]) {
        self.posts = posts
    }
    
    func postDeleted() {
        viewModel.fetchStoragePosts()
    }
    
    func dataBaseDeleted() {
        performSegue(withIdentifier:  "loadDataSegue", sender: nil)
    }
    
    @objc func showLikePost(sender: UIBarButtonItem) {
        isLikesSelected = !isLikesSelected
        isLikesSelected ? viewModel.getLikeList() : viewModel.fetchStoragePosts()
        setUpNavBar()
    }
    
    @objc func getWebAPIPosts(sender: UIBarButtonItem) {
        viewModel.getPostFromAPI()
    }
    
}

// MARK: - UITableViewDataSource

extension PostListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier, for: indexPath) as! PostCell
        cell.configure(post: posts[indexPath.item])
        return cell
    }
}

// MARK: - Table View Delegate

extension PostListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPost = posts[indexPath.item]
        performSegue(withIdentifier:  "postDetailSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            self.viewModel.deletePost(post: self.posts[indexPath.item] )
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

