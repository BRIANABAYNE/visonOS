//
//  ContentView.swift
//  WallArt
//
//  Created by Briana Bayne on 5/8/24.
//

import SwiftUI
import RealityKit


struct ContentView: View {


    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        VStack(alignment: .leading, content: {
            Text("Welcome to Generative Art in VisionOS")
                .font(.extraLargeTitle2)
        
        })
        .padding(50)
        .glassBackgroundEffect()
        .onAppear(perform: {
            Task {
                await openImmersiveSpace(id: "ImmersiveSpace")
            }
        })
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
