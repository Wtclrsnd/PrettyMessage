//
//  TestViewModel.swift
//  PrettyMessage
//
//  Created by thisdjango on 02.05.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import Foundation
import Moya

class TestViewModel: TestViewModelProtocol {
    
    var framesModel: FramesModel?
    
    var onGetting: (() -> Void)?
    
    private let provider = MoyaProvider<Target>()
    
    func grabData() {
        _ = provider.rx.request(.frames)
            .filterSuccessfulStatusCodes()
            .subscribe { [weak self] event in
                switch event {
                case let .success(response):
                    guard let model = try? response.map(FramesModel.self) else { return }
                    self?.framesModel = model
                    self?.onGetting?()
                case .error:
                    print(event)
                    self?.onGetting?()
                }
            }
    }
}

