//
//  ViewController+SearchBar.swift
//  Weather
//
//  Created by Elina Lua Ming on 5/19/23.
//

import UIKit


extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.activateSearchMode()
        
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.deactivateSearchMode()
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        // Not implemented: For completion, we should also implement a function to cancel any remaining in-flight geocoding requests.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.searchBarResults = []
            self.activateSearchMode()
            
            return
        }
        
        self.fetchSearchInputInteractor.perform(for: searchText) { result, error  in
            guard let result = result, error == nil else {
                // Show alert for failure
                self.displayFailureAlert()
                return
            }
            
            self.searchBarResults = result
            
            if self.searchBarResults.isEmpty {
                self.noteToUser.text = "No results."
            }
            
            self.searchResultsTable.reloadData()
        }
    }
    
    func activateSearchMode() {
        self.searchModeDimmingView.isHidden = false
        self.noteToUser.isHidden = false
        
        self.noteToUser.text = "Please enter a city."
    }
    
    func deactivateSearchMode() {
        self.searchBarResults = []
        
        self.searchModeDimmingView.isHidden = true
        self.noteToUser.isHidden = true
    }
}
