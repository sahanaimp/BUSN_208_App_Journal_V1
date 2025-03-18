//
//  AppEntry.swift
//  tic_tac_toe_SR
//
//  Created by Raghuraman, Sahana on 2/10/25.
//

import SwiftUI

@main
struct AppEntry: App {
    
    @StateObject var game = GameService() //create an instance of the class
    
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(game)
        }
    }
}

