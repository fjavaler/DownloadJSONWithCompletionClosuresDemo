//
//  DownloadJSONWithCompletionClosuresDemoApp.swift
//  DownloadJSONWithCompletionClosuresDemo
//
//  Created by Fred Javalera on 6/10/21.
//

import SwiftUI

@main
struct DownloadJSONWithCompletionClosuresDemoApp: App {
  @StateObject var vm = ContentViewModel()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(vm)
    }
  }
}
