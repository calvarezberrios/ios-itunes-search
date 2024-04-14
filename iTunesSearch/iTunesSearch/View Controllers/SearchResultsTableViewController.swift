//
//  SearchResultsTableViewController.swift
//  iTunesSearch
//
//  Created by Carlos E. Alvarez-Berrios on 4/14/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    
    
    @IBOutlet weak var resultTypesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
    let searchResultController = SearchResultController()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResultController.searchResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        
        let result = searchResultController.searchResults[indexPath.row]
        
        content.text = result.title
        content.secondaryText = result.creator
        
        cell.contentConfiguration = content

        return cell
    }
    
    private func getSelectedResultType() -> ResultType {
        
        var resultType: ResultType!
        
        switch resultTypesSegmentedControl.selectedSegmentIndex{
        case 0:
            resultType = .software
        case 1:
            resultType = .musicTrack
        case 2:
            resultType = .movie
        default:
            break
        }
        
        return resultType
    }
    
    private func makeSearch() {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {
            return
        }
        
        let resultType = getSelectedResultType()
        
        activityMonitor.startAnimating()
        
        searchResultController.performSearch(searchTerm: searchTerm, resultType: resultType) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.activityMonitor.stopAnimating()
                self.tableView.reloadData()
            }
            
        }
    }
    
    @IBAction func selectSearchType(_ sender: UISegmentedControl) {
        makeSearch()
    }
    
}

extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        makeSearch()
    }
}
