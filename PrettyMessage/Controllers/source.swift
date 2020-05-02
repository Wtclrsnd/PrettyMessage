//
//  source.swift
//  PrettyMessage
//
//  Created by Emil Shpeklord on 02.05.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import Foundation

struct source{
    var sections = [section]()
    
    //making all data to structured
    init(raw: [FrameModel]){
        var sects = [section]()
        let headers = ["Абстракция", "Бизнес", "Деньги", "Лист", "Пасха", "Рамки", "Свитки", "Цветы", "Цели"]
        
        
        for name in headers{
            sects.append(section(header: name))
        }
        for var head in sects {
            head.content = raw.filter({$0.category == head.header})
        }
        self.sections = sects
    }
}
