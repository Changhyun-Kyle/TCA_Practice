//
//  TCA_CounterApp.swift
//  TCA_Counter
//
//  Created by 강창현 on 3/21/24.
//

import SwiftUI

@main
struct TCA_CounterApp: App {
    @StateObject var counterFeature: CounterFeature = CounterFeature()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(counterFeature)
        }
    }
}