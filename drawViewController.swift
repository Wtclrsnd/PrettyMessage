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
    var camImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImageView()
        image.kf.setImage(with: imageUrl)

        if imageUrl != nil {
            image.kf.setImage(with: imageUrl)
        } else {
            image.image = camImage
        }

        
        view.backgroundColor = .gray
        view.addSubview(image)
        image.center = view.center
        image.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        image.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        image.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        image.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150).isActive = true
    }
    
}

