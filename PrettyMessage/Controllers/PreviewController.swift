//
//  PreviewController.swift
//  PrettyMessage
//
//  Created by Григорий Селезнев on 09.06.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import Foundation
import UIKit

class preView: UIViewController{
    var preImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(preImage)
    }
}
