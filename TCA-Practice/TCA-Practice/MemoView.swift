//
//  MemoView.swift
//  TCA-Practice
//
//  Created by 강창현 on 2023/07/24.
//

import SwiftUI
import ComposableArchitecture

// 도메인 + 상태
struct MemoState: Equatable {
    var memos: [Memo] = []
    var selected: Memo? = nil
    var isLoading: Bool = false
}

// 도메인 + 액션
enum MemoAction: Equatable {
    case fetchItem(_ id: String) // 단일 아이템 조회 액션
    case fetchItemResponse(Result<Memo, MemoClient.Failure>) // 단일 조회 액션 응답
    case fetchAllItems // 모든 아이템 조회 액션
    case fetchAllItemsResponse(Result<[Memo], MemoClient.Failure>) // 모든 조회 액션 응답
}

// 환경설정 주입
struct MemoEnvironment {
    var memoClient: MemoClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let memoReducer = AnyReducer<MemoState, MemoAction, MemoEnvironment> { state, action, environment in
    // 들어온 액션에 따라 상태를 변경
    switch action {
    case .fetchItem(let memoId):
        enum FetchItemId {}
        state.isLoading = true
        return environment.memoClient
            .fetchMemoItem(memoId)
            .debounce(id: FetchItemId, for: 0.3, scheduler: environment.mainQueue)
            .catchToEffect(MemoAction.fetchItemResponse)
        
    case .fetchItemResponse(.success(let memo)):
        state.selectedMemo = memo
        state.isLoading = false
        return Effect.none
        
    case .fetchItemResponse(.failure):
        state.selectedMemo = nil
        state.isLoading = false
        return Effect.none
        
    case .fetchAllItems:
        enum FetchAllItemsId {}
        state.isLoading = true
        return environment.memoClient
            .fetchMemoItems()
            .debounce(id: FetchAllItemsId,
                      for: 0.3,
                      scheduler: environment.mainQueue)
            .catchToEffect(MemoAction.fetchAllItemsResponse)
    
    case .fetchAllItemsResponse(.success(let memos)):
        state.selectedMemo = memos
        state.isLoading = false
        return Effect.none
        
    case .fetchAllItemsResponse(.failure):
        state.memos = nil
        state.isLoading = false
        return Effect.none
    }
    
}

struct MemoView: View {
    
    let store: Store<MemoState, MemoAction>
    
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

//struct memoView_Previews: PreviewProvider {
//    static var previews: some View {
//        memoView()
//    }
//}
