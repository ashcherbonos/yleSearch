//
//  ViewController.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 3/27/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    lazy var viewModel = SearchViewModel(delegate: self)
    private let cellIdentifier: String = "SearchResultCell"
    private var searchController: UISearchController!
    private var imageLoader = ImageLoader()
    
    @IBOutlet weak var tableView: UITableView!
    
//    lazy var dismissKeyboardOnTapRecognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSearchBarInNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        imageLoader.emptyCache()
    }
}

// MARK: - ViewModel Delegate

extension SearchViewController: SearchViewModelDelegate {
    
    func updateView() {
        tableView.reloadData()
    }
}

// MARK: - Navigation

extension SearchViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? ProgrammDetailsViewController,
            let programmIndex = tableView.indexPathForSelectedRow?.row
            else { return }
        detailsVC.programm = viewModel.getData(for: programmIndex)
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
        guard let searchBarText = searchBar.text
            else { return }
        viewModel.search(for: searchBarText)
    }
}

// MARK: - Table View

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        let programm = viewModel.getData(for: indexPath.row)
        cell.textLabel?.text = programm.title
        cell.detailTextLabel?.text = programm.description
        imageLoader.load(url: programm.previewImageURL(size: cell.bounds.height), intoImageView: cell.imageView, withStub: programm.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.isReady,
            indexPath.row == viewModel.dataLastIndex
            else { return }
        viewModel.loadMoreData()
    }
}
