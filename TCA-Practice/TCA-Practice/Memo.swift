//
//  Memo.swift
//  TCA-Practice
//
//  Created by 강창현 on 2023/07/24.
//

import Foundation

// MARK: - WelcomeElement
struct Memo: Codable, Equatable, Identifiable {
    let createdAt: Int
    let title: String
    let viewCount: Int
    let id: String
}

typealias Memos = [Memo]

