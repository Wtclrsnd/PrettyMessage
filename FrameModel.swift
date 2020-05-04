//
//  FrameModel.swift
//  PrettyMessage
//
//  Created by thisdjango on 02.05.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import Foundation

// MARK: - FrameModel
struct FrameModel: Codable, Hashable {
    let category: String
    let uri: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(category)
        hasher.combine(uri)
    }
}

typealias FramesModel = [FrameModel]
