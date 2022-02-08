//
//  ResultInfo.swift
//  Feed The Cat
//
//  Created by Ivan Budovich on 2/6/22.
//

import Foundation

struct ResultInfo {
    let date: Date
    let score: Int
    let player: String
    var isCommited: Bool
}

struct ResultViewModel {
    let result: ResultInfo
    let index: Int
}