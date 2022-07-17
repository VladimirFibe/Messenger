//
//  ChatsTableViewController.swift
//  Messenger
//
//  Created by Vladimir Fibe on 17.07.2022.
//

import UIKit

class ChatsTableViewController: UITableViewController {
  
  var allRecents: [RecentChat] = []
  var filteredRecents: [RecentChat] = []
  let searchController = UISearchController(searchResultsController: nil)
  override func viewDidLoad() {
    super.viewDidLoad()
    downloadRecentChats()
    setupSearchController()
  }
  
  private func setupSearchController() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = true
    
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search user"
    searchController.searchResultsUpdater = self
    definesPresentationContext = true
    
  }
  private func downloadRecentChats() {
    FirebaseRecentListener.shared.downloadRecentCthatsFromFireStore { allchats in
      self.allRecents = allchats
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  // MARK: - Table view data source
  
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    searchController.isActive ? filteredRecents.count : allRecents.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath) as! RecentTableViewCell
    let recent = searchController.isActive ? filteredRecents[indexPath.row] : allRecents[indexPath.row]
    cell.configure(with: recent)
    
    return cell
  }
  
  private func filteredContnentForSearchText(_ text: String) {
    filteredRecents = allRecents.filter({ recent in
      recent.receiverName.lowercased().contains(text.lowercased())
    })
    tableView.reloadData()
  }
}

extension ChatsTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filteredContnentForSearchText(searchController.searchBar.text!)
  }
  
  
}
