//
//  Mondaine_Clock__Mac_App.swift
//  Mondaine Clock (Mac)
//
//  Created by Steve Wang on 8/10/24.
//

import SwiftUI

@main
struct Mondaine_Clock__Mac_App: App {
    var body: some Scene {
            WindowGroup {
                ClockView()
            }
            .windowStyle(HiddenTitleBarWindowStyle())
        }
    }
