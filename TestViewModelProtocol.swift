//
//  TestViewModelProtocol.swift
//  PrettyMessage
//
//  Created by thisdjango on 02.05.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import Foundation

protocol TestViewModelProtocol {
    
    var onGetting: (()->Void)? { get set }
    
    func grabData()
    
    var framesModel: FramesModel? { get set }

}
