//
//  ChessApp.swift
//  Chess
//
//  Created by Maarten on 25/12/2021.
//

import SwiftUI

@main
struct ChessApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(board: Board())
        }
    }
}
