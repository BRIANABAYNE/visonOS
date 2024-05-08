//
//  ViewModel.swift
//  WallArt
//
//  Created by Briana Bayne on 5/8/24.
//

import Foundation
import Observation

// Represents the different state the Flowstate can be in

enum Flowstate {
    case idle
    case intro
    case projectileFlying
    case updatedWallArt
}

// Swift Macro - SwiftUI is able to listen to different states in the view model and will get updates since it is wrapped with @Observable - this allows it to update it's UI state 
@Observable

class ViewModel {
    //  Variable that is being assigned to the certain sate
    var flowState = Flowstate.idle
    
    
}
