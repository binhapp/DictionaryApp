//
//  Store.swift
//  LabanDict
//
//  Created by Binh Nguyen on 1/19/18.
//  Copyright © 2018 Binh Nguyen. All rights reserved.
//

import Foundation

private let STORE_KEY = "LabanDict"

struct Store {
  var labanDict: Vocabularies = Vocabularies() {
    didSet {
      stored()
    }
  }
  
  init() {
    let decoder = JSONDecoder()
    guard
      let json = UserDefaults.standard.string(forKey: STORE_KEY),
      let data = json.data(using: .utf8),
      let labanDict = try? decoder.decode(Vocabularies.self, from: data)
      else { return }
    self.labanDict = labanDict
  }
  
  func stored() {
    let encoder = JSONEncoder()
    guard
      let data = try? encoder.encode(labanDict),
      let json = String(data: data, encoding: .utf8)
      else { return }
    UserDefaults.standard.setValue(json, forKey: STORE_KEY)
  }
}
