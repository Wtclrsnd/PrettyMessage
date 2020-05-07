//
//  fullViewController.swift
//  PrettyMessage
//
//  Created by Emil Shpeklord on 30.04.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class drawViewController: UIViewController {

    var imageUrl: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImageView()
        image.kf.setImage(with: imageUrl)
        
        view.backgroundColor = .gray
        view.addSubview(image)
        image.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: .init(width: view.frame.width, height: view.frame.height / 2))
    }
    
}

