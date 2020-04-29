//
//  ViewController.swift
//  PrettyMessage
//
//  Created by Emil Shpeklord on 25.04.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class mainCollectionViewController: UIViewController {

    var mainCollectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        addCollection()
    }

    func addCollection() {
        let layout = UICollectionViewLayout()
        self.mainCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        mainCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "imageCollectionViewCell")
        mainCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(mainCollectionView)
    }

}

 //MARK: - CollectionView
extension mainCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as? imageCollectionViewCell {
            imageCell.titleImage = UIImage(imageLiteralResourceName: "testImage")
            return imageCell
        }
        return UICollectionViewCell()
    }
    
    
}

