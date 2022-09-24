//
//  ViewController.swift
//  mobiletest
//
//  Created by sebastian panesso on 20/09/22.
//

import UIKit
import Combine
import CoreData


class ViewController: BaseViewContoller, LoadDataViewResponse {
   
    
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    private var viewModel : LoadDataViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = LoadDataViewModel(networkService: NetworkServiceImp(), postAPIService: PostApiServiceImp(), coreDataService: CoreDataServiceImp(context: self.context), context: context)
        viewModel.viewOutput = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.checkEmptyStorage()
    }
    
    func isStorageEmpty(isEmpty:Bool){
        isEmpty ? viewModel.checkNetworkConnection() : isDataSaved(isSaved: !isEmpty)
    }
    
    func isNetworkConnected(isConnected:Bool){
        if isConnected {
            viewModel.fetchPosts()
        } else {
            self.presentAlertWithTitle(title: "Network Error", message: "The first time you need to be connected to the internet", options: "Ok") { code in
                self.viewModel.checkEmptyStorage()
            }
        }
    }
    
    func isDataFetched(posts: [PostAPI]) {
        viewModel.storagePosts(posts: posts)
    }
    
    func isDataSaved(isSaved:Bool){
        spinner.stopAnimating()
        if isSaved {
            self.performSegue(withIdentifier: "postsListSegue", sender: self)
        } else {
            self.presentAlertWithTitle(title: "Storage Error", message: "There was an error saving the data locally, please try again", options: "Ok") { code in
                self.viewModel.checkEmptyStorage()
            }
        }
    }
}


