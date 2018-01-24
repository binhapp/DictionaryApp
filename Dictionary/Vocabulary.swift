//
//  Dictionary.swift
//  Dictionary
//
//  Created by Binh Nguyen on 1/19/18.
//  Copyright © 2018 Binh Nguyen. All rights reserved.
//

import Foundation

struct Vocabularies: Codable {
  var vocabularies: [Vocabulary] = []
}

struct Vocabulary: Codable {
  var urlString: String?
  var name: String?
  var pronounce: [String]?
  var voices: [String]?
  var count = 1
  let createdAt: Date = Date()
  var updatedAt: Date = Date()
}
