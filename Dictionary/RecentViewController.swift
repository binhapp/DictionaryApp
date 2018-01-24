//
//  RecentViewController.swift
//  Dictionary
//
//  Created by Binh Nguyen on 1/23/18.
//  Copyright © 2018 Binh Nguyen. All rights reserved.
//

import Cocoa

class RecentViewController: NSViewController {
  
  @IBOutlet weak var recentTableView: NSTableView!
  
  fileprivate var stored: Store = Store.shared {
    didSet {
      print(stored)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRecentTableView()
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    recentTableView.reloadData()
  }
  
  private func setupRecentTableView() {
    recentTableView.dataSource = self
    recentTableView.delegate = self
  }
}

extension RecentViewController: NSTableViewDataSource, NSTableViewDelegate {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return stored.Dictionary.vocabularies.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    guard let identifier = tableColumn?.identifier else { return nil }
    let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
    
    let vocabulary = stored.Dictionary.vocabularies[row]
    
    switch identifier.hashValue {
    case Column.name.identifier.hashValue:
      cell?.textField?.stringValue = vocabulary.name ?? "-"
    case Column.pronounce.identifier.hashValue:
      cell?.textField?.stringValue = vocabulary.pronounce?.first ?? "-"
    case Column.count.identifier.hashValue:
      cell?.textField?.stringValue = String(vocabulary.count)
    default:
      break
    }

    return cell
  }
}

fileprivate enum Column: String {
  case name, pronounce, count
  
  var identifier: NSUserInterfaceItemIdentifier {
    return NSUserInterfaceItemIdentifier(rawValue: rawValue)
  }
}
