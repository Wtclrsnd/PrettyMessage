//
//  sectionModel.swift
//  PrettyMessage
//
//  Created by Григорий Селезнев on 01.05.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import Foundation
import UIKit

struct sectionModel: Hashable {
    let type: String
    let header: String
    let items: [itemModel]
}
