//
//  UsrsTableViewController.swift
//  Messenger
//
//  Created by Vladimir Fibe on 16.07.2022.
//

import UIKit

class UsersTableViewController: UITableViewController {
  var allUsers: [Person] = [Person(status: "ava")]
  var filteredUsers: [Person] = []
  let searchController = UISearchController(searchResultsController: nil)
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.refreshControl = UIRefreshControl()
    self.tableView.refreshControl = self.refreshControl
    setupSearchController()
    downloadUsers()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.largeTitleDisplayMode = .always
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  // MARK: - DownloadUsers
  private func downloadUsers() {
    FirebaseUserListener.shared.downloadAllUsersFromFirebase { all in
      self.allUsers = all
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  // MARK: - Setup Search Controller
  private func setupSearchController() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = true
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search user"
    searchController.searchResultsUpdater = self
    definesPresentationContext = true
  }
  
  private func filteredContentForSearchText(_ text: String) {
    filteredUsers = allUsers.filter({
      $0.username.lowercased().contains(text.lowercased())
    })
    tableView.reloadData()
  }
  
  // MARK: - UIScrollViewDelegate
  override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if self.refreshControl!.isRefreshing {
      self.downloadUsers()
      self.refreshControl!.endRefreshing()
    }
  }
  
  // MARK: - Tableview Delegates
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = #colorLiteral(red: 0.949000001, green: 0.949000001, blue: 0.9689999819, alpha: 1)
    return headerView
  }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    5
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    // TODO: show profile view
    let person = searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
    showUserProfile(person)
  }
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int { 1 }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    searchController.isActive ? filteredUsers.count : allUsers.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as! UsersTableViewCell
    let person = searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
    cell.configure(with: person)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    80
  }
  
  // MARK: - Navigation
  private func showUserProfile(_ person: Person) {
    let profileview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileView") as! ProfileTableViewController
    profileview.person = person
    navigationController?.pushViewController(profileview, animated: true)
  }
}

extension UsersTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filteredContentForSearchText(searchController.searchBar.text ?? "")
  }
}
