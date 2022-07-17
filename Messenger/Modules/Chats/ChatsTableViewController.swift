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
  
  @IBAction func composeBarButtonPressed(_ sender: UIBarButtonItem) {
    let usersView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersView") as! UsersTableViewController
    navigationController?.pushViewController(usersView, animated: true)
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
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let recent = searchController.isActive ? filteredRecents[indexPath.row] : allRecents[indexPath.row]
      FirebaseRecentListener.shared.deleteRecent(recent)
      if searchController.isActive {
        filteredRecents.remove(at: indexPath.row)
      } else {
        allRecents.remove(at: indexPath.row)
      }
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let recent = searchController.isActive ? filteredRecents[indexPath.row] : allRecents[indexPath.row]
    FirebaseRecentListener.shared.clearUnreadCounter(recent: recent)
    //TODO: continue to chatroom
    goToChat(recent: recent)
  }
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = #colorLiteral(red: 0.949000001, green: 0.949000001, blue: 0.9689999819, alpha: 1)
    return headerView
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    1
  }
  private func filteredContnentForSearchText(_ text: String) {
    filteredRecents = allRecents.filter({ recent in
      recent.receiverName.lowercased().contains(text.lowercased())
    })
    tableView.reloadData()
  }
  
  // MARK: - Navigation
  private func goToChat(recent: RecentChat) {
    let viewController = ChatViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }
}

extension ChatsTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filteredContnentForSearchText(searchController.searchBar.text!)
  }
}
