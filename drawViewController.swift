//
//  fullViewController.swift
//  PrettyMessage
//
//  Created by Emil Shpeklord on 30.04.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import UIKit
import iOSPhotoEditor

class drawViewController: UIViewController {

    var imageUrl: URL?
    var camImage: UIImage?
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imageUrl != nil {
            imageView.kf.setImage(with: imageUrl)
        } else {
            imageView.image = camImage
        }

        
        view.backgroundColor = .gray
        view.addSubview(imageView)
        imageView.center = view.center
        imageView.contentMode = .scaleAspectFill
        imageView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        imageView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150).isActive = true
    }
    
}

//extension drawViewController: PhotoEditorDelegate {
//    
//    func doneEditing(image: UIImage) {
//            imageView.image = image
//        }
//        
//        func canceledEditing() {
//            print("Canceled")
//        }
//}
