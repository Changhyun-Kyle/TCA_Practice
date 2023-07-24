//
//  MemoClient.swift
//  TCA-Practice
//
//  Created by 강창현 on 2023/07/24.
//

import Foundation
import ComposableArchitecture

struct MemoClient {
    // 단일 아이템 조회
    var fetchMemoItem: (_ id: String) -> EffectPublisher<Memo, Error>
    // 모든 아이템 조회
    var fetchMemoItems: () -> EffectPublisher<Memos, Error>
    
    struct Failure: Error, Equatable {}
}

extension MemoClient {
    static let live = Self(
        fetchMemoItem: { id in
            EffectPublisher.task {
                let (data, _) = try await URLSession.shared.data(from: URL(string: "https://64be4be05ee688b6250c263f.mockapi.io/memo/\(id)")!)
                return try JSONDecoder().decode(Memo.self, from: data)
            }
            .mapError { _ in Failure() }
            .eraseToEffect()
    },
        fetchMemoItems: {
            EffectPublisher.task {
                let (data, _) = try await URLSession.shared.data(from: URL(string: "https://64be4be05ee688b6250c263f.mockapi.io/memo")!)
                return try JSONDecoder().decode(Memos.self, from: data)
            }
            .mapError { _ in Failure() }
            .eraseToEffect()
    })
}
