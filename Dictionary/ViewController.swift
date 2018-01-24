//
//  ViewController.swift
//  Dictionary
//
//  Created by Binh Nguyen on 1/19/18.
//  Copyright © 2018 Binh Nguyen. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {

  @IBOutlet weak var webView: WKWebView! {
    didSet {
      let url = URL(string: "http://m.dict.laban.vn")!
      webView.load(URLRequest(url: url))
      webView.navigationDelegate = self
    }
  }
  
  fileprivate var stored: Store = Store.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

extension ViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    let group = DispatchGroup()
    
    var vocabulary = Vocabulary()
    vocabulary.urlString = webView.url?.absoluteString
    
    group.enter()
    webView.parseName {
      vocabulary.name = $0
      group.leave()
    }
    
    group.enter()
    webView.parsePronounce {
      vocabulary.pronounce = $0
      group.leave()
    }
    
    group.enter()
    webView.parseVoices {
      vocabulary.voices = $0
      group.leave()
    }
    
    group.notify(queue: .main) {
      self.stored.add(vocabulary: vocabulary)
    }
  }
}

extension WKWebView {
  func parseName(completion: @escaping (String?) -> Void) {
    let js = rootElement + ".getElementsByTagName('h2')[0].innerText"
    evaluateJavaScript(js) { (data, _) in
      completion(data as? String)
    }
  }
  
  func parsePronounce(completion: @escaping ([String]?) -> Void) {
    let js = rootElement + ".getElementsByTagName('p')[0].innerText"
    evaluateJavaScript(js) { (data, _) in
      completion((data as? String)?.split(separator: " ").flatMap { String($0) })
    }
  }
  
  func parseVoices(completion: @escaping ([String]?) -> Void) {
    var voices: [String] = []
    let group = DispatchGroup()
    [0, 1].forEach { i in
      group.enter()
      let js = rootElement + ".getElementsByTagName('div')[0].getElementsByTagName('source')[\(i)].src"
      evaluateJavaScript(js) { (data, _) in
        if let urlString = data as? String {
          voices.append(urlString)
        }
        group.leave()
      }
    }
    group.notify(queue: .main) {
      completion(voices)
    }
  }
}

private let rootElement = "document.getElementsByClassName('inside title-inside')[0]"

