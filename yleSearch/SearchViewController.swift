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
    var searchController : UISearchController!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var dismissKeyboardOnTapRecognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
    
    private var programms: [TvProgramm] = {[]}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSearchBarInNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? ProgrammDetailsViewController,
            let programmIndex = tableView.indexPathForSelectedRow?.row
            else { return }
        let selectedProgramm = programms[programmIndex]
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
        let _ = QueryService(searchTerm: searchText) { results in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let results = results else { return }
            self.programms = results
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - Table View

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        let programm = programms[indexPath.row]
        cell.textLabel?.text = programm.title
        cell.detailTextLabel?.text = programm.description
        cell.imageView?.image = UIImage(named: "Blank52")
        
        if let previewImageURL = programm.previewImageURL  {
            let task = URLSession.shared.dataTask(with: previewImageURL) { data, response, error in
                guard error == nil, response.statusCodeIsOK, let data = data else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    if let cellToUpdate = tableView.cellForRow(at: indexPath) {
                        cellToUpdate.imageView?.image = image
                    }
                }
            }
            task.resume()
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let lastElement = dataSource.count - 1
//        if !loadingData && indexPath.row == lastElement {
//            indicator.startAnimating()
//            loadingData = true
//            loadMoreData()
//        }
//    }
}
