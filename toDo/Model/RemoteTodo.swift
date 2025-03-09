//
//  Untitled.swift
//  toDo
//
//  Created by Salman Abdullayev on 09.03.25.
//

import SwiftUI

struct RemoteTodo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
