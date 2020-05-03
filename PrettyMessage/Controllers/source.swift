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
    init(raw: FramesModel){
        var sects = [section]()
        let headers = ["Цели", "Бизнес", "Деньги", "Лист", "Пасха", "Рамки", "Свитки", "Цветы", "Абстракция"]
        
        for name in headers{
            sects.append(section(header: name))
        }
        
        for head in raw{
            switch head.category {
            case "Цели":
                sects[0].content.append(head)
            case "Бизнес":
                sects[1].content.append(head)
            case "Деньги":
                sects[2].content.append(head)
            case "Лист":
                sects[3].content.append(head)
            case "Пасха":
                sects[4].content.append(head)
            case "Рамки":
                sects[5].content.append(head)
            case "Свитки":
                sects[6].content.append(head)
            case "Цветы":
                sects[7].content.append(head)
            case "Абстракция":
                sects[8].content.append(head)
            default:
                continue
            }
        }
        self.sections = sects
    }
    
    init(){
        
    }
}
