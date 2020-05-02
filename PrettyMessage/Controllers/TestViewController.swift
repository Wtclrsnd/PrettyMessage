//
//  TestViewController.swift
//  PrettyMessage
//
//  Created by thisdjango on 02.05.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import UIKit
import Kingfisher

class TestViewController: UIViewController {

    private var viewModel = TestViewModel()
    
    private var imageView: UIImageView = {
        let imV = UIImageView()
        imV.contentMode = .scaleAspectFit
        imV.image = UIImage(named: "Picture")
        imV.translatesAutoresizingMaskIntoConstraints = false
        return imV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        viewModel.onGetting = { [weak self] in
            print("kekkk")
        }
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        viewModel.grabData()
    }
    
}
