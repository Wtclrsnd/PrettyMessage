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
        var headers = [String]()
        
        for head in raw{
            if !headers.contains(head.category){
                headers.append(head.category)
            }
        }
        
        headers = headers.shuffled()
        
        for name in headers{
            sects.append(section(header: name))
        }
        
        for head in raw{
            for i in 0...(sects.count-1){
                if head.category == sects[i].header{
                    sects[i].content.append(head)
                }
                sects[i].content.sort(by: {$0.uri > $1.uri})
            }
        }
        
        
        self.sections = sects
    }
    
    init(){}
}
