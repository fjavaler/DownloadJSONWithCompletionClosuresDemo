//
//  ContentViewModel.swift
//  DownloadJSONWithCompletionClosuresDemo
//
//  Created by Fred Javalera on 6/10/21.
//

import Foundation

class ContentViewModel: ObservableObject {
  
  // MARK: Properties
  @Published var posts: [PostModel] = []
  
  // MARK: Init
  init() {
    getPosts()
  }
  
  // MARK: Methods
  func getPosts() {
    
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
    
    downloadData(fromURL: url) { returnedData in
      if let data = returnedData {
        guard let newPosts = try? JSONDecoder().decode([PostModel].self, from: data) else { return }
        // Needs to be done from the main thread. Currently on a background thread created by dataTask in downloadData.
        DispatchQueue.main.async { [weak self] in
          self?.posts = newPosts
        }
      } else {
        print("No data returned.")
      }
    }
  }

  func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> Void) {
    
    // dataTask goes onto a background thread by default
    URLSession.shared.dataTask(with: url) { data, response, error in
      
      // Checks
      guard let data = data else {
        print("No data.")
        completionHandler(nil)
        return
      }
      
      guard error == nil else {
        print("Error: \(String(describing: error))")
        completionHandler(nil)
        return
      }
      
      guard let response = response as? HTTPURLResponse else {
        print("Invalid response.")
        completionHandler(nil)
        return
      }
      
      guard response.statusCode >= 200 && response.statusCode < 300 else {
        print("Status code should be 2xx, but is \(response.statusCode)")
        completionHandler(nil)
        return
      }
      
      completionHandler(data)
      
    }
    .resume()
    
  }
  
}
