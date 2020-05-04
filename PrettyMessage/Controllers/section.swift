//
//  section.swift
//  PrettyMessage
//
//  Created by Emil Shpeklord on 02.05.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import Foundation

//часть необходимой для работы структуры данных
struct section {
    var header = String()
    var content = [FrameModel]()
    
    init(header: String) {
        self.header = header
    }
}

extension section: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(header)
        hasher.combine(content)
    }
    
}
