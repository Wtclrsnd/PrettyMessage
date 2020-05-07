//
//  fullViewController.swift
//  PrettyMessage
//
//  Created by Emil Shpeklord on 30.04.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class drawViewController: UIViewController {

    var camImage: UIImage?
    var imageUrl: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImageView()
        
        if imageUrl != nil {
            image.kf.setImage(with: imageUrl)
        } else {
            image.image = camImage
        }
        
        view.backgroundColor = .gray
        view.addSubview(image)
        image.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        image.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }
    
}

