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
    var preImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let preImageView = UIImageView()
        preImageView.image = preImage
        preImageView.contentMode = .scaleAspectFit
        view.addSubview(preImageView)
        preImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
}
