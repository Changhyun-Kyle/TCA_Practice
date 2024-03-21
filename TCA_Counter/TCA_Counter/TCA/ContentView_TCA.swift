//
//  ContentView_TCA.swift
//  TCA_Counter
//
//  Created by 강창현 on 3/21/24.
//

import ComposableArchitecture
import SwiftUI

struct NetworkService_TCA {
    var fetch: @Sendable (Int) async throws -> String
}

extension NetworkService_TCA: DependencyKey {
    static var liveValue: NetworkService_TCA = Self { number in
        let (data, _) = try await URLSession.shared.data(
            from: URL(string: "http://www.numbersapi.com/\(number)")!
        )
        return String(decoding: data, as: UTF8.self)
    }
}

extension DependencyValues {
    var numberFact: NetworkService_TCA {
        get { self[NetworkService_TCA.self] }
        set { self[NetworkService_TCA.self] = newValue }
    }
}

struct CounterFeature_TCA: Reducer {
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoadingFact = false
    }
    
    enum Action: Equatable {
        case incrementButtonTapped
        case decrementButtonTapped
        case factResponse(String)
        case getFactButtonTapped
    }
    
    @Dependency(\.numberFact) var numberFact
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case .factResponse(let fact):
                state.fact = fact
                state.isLoadingFact = false
                return .none
            case .getFactButtonTapped:
                state.fact = nil
                state.isLoadingFact = true
                return .run { [count = state.count] send in
                    try await send(.factResponse(self.numberFact.fetch(count)))
                }
            }
        }
    }
}

struct ContentView_TCA: View {
    let store: StoreOf<CounterFeature_TCA>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    Text("\(viewStore.count)")
                    Button("+") {
                        viewStore.send(.incrementButtonTapped)
                    }
                    Button("-") {
                        viewStore.send(.decrementButtonTapped)
                    }
                }
                
                Section {
                    Button {
                        viewStore.send(.getFactButtonTapped)
                    } label: {
                        HStack {
                            if viewStore.isLoadingFact {
                              Spacer()
                              ProgressView()
                            }
                        }
                        Text("데이터 가져오기")
                    }
                    if let fact = viewStore.fact {
                        Text(fact)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView_TCA(
        store: Store(
            initialState: CounterFeature_TCA.State()
        ) {
            CounterFeature_TCA()
        }
    )
}
