//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Guadoo on 2021/5/24.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}
