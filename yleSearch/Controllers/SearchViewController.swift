//
//  ViewController.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 3/27/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    lazy var viewModel = SearchViewModel(delegate: self)
    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSearchBarInNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        viewModel.emptyMemory()
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
        guard let detailsVC = segue.destination as? DataConsumer,
            let selectedCellIndex = tableView.indexPathForSelectedRow?.row
            else { return }
        viewModel.fill(consumer: detailsVC, withIndex: selectedCellIndex)
    }
}

// MARK: - Search Bar

extension SearchViewController:  UISearchControllerDelegate, UISearchBarDelegate {
    
    func dismissKeyboard() {
        searchController.resignFirstResponder()
    }
    
    private func makeSearchBarInNavigationBar() {
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.tintColor = AppConstants.searchBarTintColor
        self.searchController.searchBar.showsCancelButton = false
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
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.cellIdentifier)!
        viewModel.fill(consumer: cell as! DataConsumer, withIndex: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard viewModel.isReady,
            indexPath.row == viewModel.dataLastIndex
            else { return }
        viewModel.loadMoreData()
    }
}
