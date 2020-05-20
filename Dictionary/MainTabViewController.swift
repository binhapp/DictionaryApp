//
//  MainTabViewController.swift
//  Dictionary
//
//  Created by Binh Nguyen on 5/20/20.
//  Copyright © 2020 Binh Nguyen. All rights reserved.
//

import Cocoa

class MainTabViewController: NSTabViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func selectTab(index: Int) {
    tabView.selectTabViewItem(at: index)
  }
  
}

