//
//  ContentView.swift
//  TCA-Practice
//
//  Created by 강창현 on 2023/07/24.
//

import SwiftUI
import ComposableArchitecture

// 도메인 + 상태
struct CounterState: Equatable {
    var count: Int = 0
}

// 도메인 + 액션
enum CounterAction: Equatable {
    case addCount // 카운트를 더하는 액션
    case subtractCount // 카운트를 빼는 액션
}

struct CounterEnvironment {
    
}

let counterReducer = AnyReducer<CounterState, CounterAction, CounterEnvironment> { state, action, environment in
    // 들어온 액션에 따라 상태를 변경
    switch action {
    case .addCount:
        state.count += 1
        return EffectTask.none
    case .subtractCount:
        state.count -= 1
        return EffectTask.none
    }
    
}

struct CounterView: View {
    
    let store: Store<CounterState, CounterAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            
            VStack {
                Text("\(viewStore.state.count)")
                HStack {
                    Button("+") {
                        viewStore.send(.addCount)
                    }
                    Button("-") {
                        viewStore.send(.subtractCount)
                    }
                }
            }
        }
    }
}

//struct CounterView_Previews: PreviewProvider {
//    static var previews: some View {
//        CounterView()
//    }
//}
