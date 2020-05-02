//
//  FrameModel.swift
//  PrettyMessage
//
//  Created by thisdjango on 02.05.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import Foundation

// MARK: - FrameModel
struct FrameModel: Codable {
    let category: String
    let uri: String
}

typealias FramesModel = [FrameModel]
