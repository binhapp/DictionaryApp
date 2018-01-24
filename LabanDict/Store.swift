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
  
  static let shared = Store()
  
  private(set) var labanDict: Vocabularies = Vocabularies()
  
  init() {
    let decoder = JSONDecoder()
    guard
      let json = UserDefaults.standard.string(forKey: STORE_KEY),
      let data = json.data(using: .utf8),
      let labanDict = try? decoder.decode(Vocabularies.self, from: data)
      else { return }
    self.labanDict = labanDict
  }
  
  mutating func add(vocabulary: Vocabulary) {
    if vocabulary.name == nil { return }
    if let index = labanDict.vocabularies.index(where: { $0.name == vocabulary.name }) {
      var oldVocabulary = labanDict.vocabularies[index]
      oldVocabulary.count += 1
      oldVocabulary.updatedAt = Date()
      labanDict.vocabularies[index] = oldVocabulary
    } else {
      labanDict.vocabularies.insert(vocabulary, at: 0)
    }
    sorted()
    stored()
  }
  
  private mutating func sorted() {
    labanDict.vocabularies = labanDict.vocabularies
      .sorted(by: { $0.updatedAt > $1.updatedAt })
  }
  
  private func stored() {
    let encoder = JSONEncoder()
    guard
      let data = try? encoder.encode(labanDict),
      let json = String(data: data, encoding: .utf8)
      else { return }
    UserDefaults.standard.setValue(json, forKey: STORE_KEY)
  }
}
