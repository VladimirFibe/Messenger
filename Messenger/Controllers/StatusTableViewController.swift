//
//  StatusTableViewController.swift
//  Messenger
//
//  Created by Vladimir Fibe on 16.07.2022.
//

import UIKit

class StatusTableViewController: UITableViewController {
  var allStatuses: [String] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    loadUserStatus()
  }
  
  private func loadUserStatus() {
    allStatuses = UserDefaults.standard.object(forKey: kSTATUS) as! [String]
    tableView.reloadData()
  }
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allStatuses.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath)
    let status = allStatuses[indexPath.row]
    cell.textLabel?.text = status
    cell.accessoryType = Person.currentPerson?.status == status ? .checkmark : .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    updateCellCheck(indexPath)
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = #colorLiteral(red: 0.949000001, green: 0.949000001, blue: 0.9689999819, alpha: 1)
    
    return headerView
  }
  
  private func updateCellCheck(_ indexPath: IndexPath) {
    if var person = Person.currentPerson {
      person.status = allStatuses[indexPath.row]
      Person.save(person)
      FirebaseUserListener.shared.savePersonToFireStore(person)
    }
  }
}
