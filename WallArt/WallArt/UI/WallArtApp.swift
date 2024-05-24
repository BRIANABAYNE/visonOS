//
//  WallArtApp.swift
//  WallArt
//
//  Created by Briana Bayne on 5/8/24.
//

import SwiftUI

@main
struct WallArtApp: App {
    
    // State property wrapper, that I wan to persist ViewModel instance throughout the application lifecycle in my app, you have to use a @State wrapper every time you want to mutate a var contained in the struct
    @State private var viewModel = ViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            // injecting the viewModel - The content view now as access to the viewModel
                .environment(viewModel)
        }.windowStyle(.plain)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
            /// Passing in the viewModel as an environment to the immersiveView 
                .environment(viewModel)
        }
    }
}
