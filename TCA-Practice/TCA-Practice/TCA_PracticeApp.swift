//
//  TCA_PracticeApp.swift
//  TCA-Practice
//
//  Created by 강창현 on 2023/07/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_PracticeApp: App {
    
    let counterStore = Store(initialState: CounterState(),
                             reducer: counterReducer,
                             environment: CounterEnvironment())
    
    var body: some Scene {
        WindowGroup {
            CounterView(store: counterStore)
        }
    }
}
