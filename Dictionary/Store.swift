//
//  Store.swift
//  Dictionary
//
//  Created by Binh Nguyen on 1/19/18.
//  Copyright © 2018 Binh Nguyen. All rights reserved.
//

import Foundation

private let STORE_KEY = "Dictionary"

struct Store {
  
  static let shared = Store()
  
  private(set) var Dictionary: Vocabularies = Vocabularies()
  
  init() {
    let decoder = JSONDecoder()
    guard
      let json = UserDefaults.standard.string(forKey: STORE_KEY),
      let data = json.data(using: .utf8),
      let Dictionary = try? decoder.decode(Vocabularies.self, from: data)
      else { return }
    self.Dictionary = Dictionary
  }
  
  mutating func add(vocabulary: Vocabulary) {
    if vocabulary.name == nil { return }
    if let index = Dictionary.vocabularies.index(where: { $0.name == vocabulary.name }) {
      var oldVocabulary = Dictionary.vocabularies[index]
      oldVocabulary.count += 1
      oldVocabulary.updatedAt = Date()
      Dictionary.vocabularies[index] = oldVocabulary
    } else {
      Dictionary.vocabularies.insert(vocabulary, at: 0)
    }
    sorted()
    stored()
  }
  
  private mutating func sorted() {
    Dictionary.vocabularies = Dictionary.vocabularies
      .sorted(by: { $0.updatedAt > $1.updatedAt })
  }
  
  private func stored() {
    let encoder = JSONEncoder()
    guard
      let data = try? encoder.encode(Dictionary),
      let json = String(data: data, encoding: .utf8)
      else { return }
    UserDefaults.standard.setValue(json, forKey: STORE_KEY)
  }
}
