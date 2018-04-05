//
//  ViewController.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 3/27/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    let cellIdentifier: String = "SearchResultCell"
    var searchController: UISearchController!
    let dataSourceFactory:TableDataSourcerMaker = YleTableDataSourcerFactory()
    var dataSource: TableDataSourcer = EmptyTableDataSource()
    var imageLoader = ImageLoader()
    private var loadingData = false
    @IBOutlet weak var tableView: UITableView!
    
    lazy var dismissKeyboardOnTapRecognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSearchBarInNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        imageLoader.emptyCache()
    }
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? ProgrammDetailsViewController,
            let programmIndex = tableView.indexPathForSelectedRow?.row,
            let selectedProgramm = dataSource[programmIndex] as? TvProgramm
            else { return }
        detailsVC.programm = selectedProgramm
     }
}

// MARK: - Search Bar

extension SearchViewController:  UISearchControllerDelegate, UISearchBarDelegate {
    
    @objc func dismissKeyboard() {
        searchController.resignFirstResponder()
    }
    
    private func makeSearchBarInNavigationBar() {
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        dismissKeyboard()
        guard let searchText = searchBar.text else { return }
        dataSource = dataSourceFactory.make(query: searchText) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.loadingData = false
            self.tableView.reloadData()
        }
        dataSource.giveNext(20)
    }
    
}

// MARK: - Table View

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        let programm = dataSource[indexPath.row] as! TvProgramm
        cell.textLabel?.text = programm.title
        cell.detailTextLabel?.text = programm.description
        imageLoader.load(url: programm.previewImageURL, intoImageView: cell.imageView, withStub: programm.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = dataSource.count - 1
        if !loadingData && indexPath.row == lastElement {
//            indicator.startAnimating()
            loadingData = true
            dataSource.giveNext(20)
        }
    }
}
