//
//  ViewController.swift
//  PrettyMessage
//
//  Created by Emil Shpeklord on 25.04.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    //MARK: - outlets
    @IBOutlet weak var fillBucket: UIBarButtonItem!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!

   
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        addLayout()
    }
    
    
    
    //MARK: - UI layout
    func addLayout() {
        //UserData CV
        let labelYoursWorks: UITextView = {
        let userHeaderLabel = UITextView()
        userHeaderLabel.text = "Your own works:"
        userHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        userHeaderLabel.font = UIFont.boldSystemFont(ofSize: 20)
        userHeaderLabel.isEditable = false
        return userHeaderLabel
        }()
        
        let collectionViewOfOwnWorks: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let userCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            userCollectionView.allowsSelection = true
            userCollectionView.translatesAutoresizingMaskIntoConstraints = false
            userCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            return userCollectionView
        }()
        
        collectionViewOfOwnWorks.delegate = self
        collectionViewOfOwnWorks.dataSource = self
        collectionViewOfOwnWorks.backgroundColor = .white
        
        //Makets CV
        let labelMaketsProduct: UITextView = {
            let maketsHeaderLabel = UITextView()
            maketsHeaderLabel.text = "Layouts:"
            maketsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
            maketsHeaderLabel.font = UIFont.boldSystemFont(ofSize: 20)
            maketsHeaderLabel.isEditable = false
            return maketsHeaderLabel
        }()
        
        let collectionViewOfMakets: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            mainCollectionView.allowsSelection = true
            mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
            mainCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            
            return mainCollectionView
        }()
        
        collectionViewOfMakets.backgroundColor = .white
        collectionViewOfMakets.delegate = self
        collectionViewOfMakets.dataSource = self
        
        
        mainView.addSubview(labelMaketsProduct)
        mainView.addSubview(collectionViewOfMakets)
        mainView.addSubview(labelYoursWorks)
        mainView.addSubview(collectionViewOfOwnWorks)
        
        //Constraints
        labelYoursWorks.anchor(top: mainView.safeAreaLayoutGuide.topAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: collectionViewOfOwnWorks.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 5, bottom: 0, right: 5), size: .init(width: 100, height: 50))
        
        collectionViewOfOwnWorks.anchor(top: labelYoursWorks.bottomAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: labelMaketsProduct.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 20, right: 5))
        collectionViewOfOwnWorks.heightAnchor.constraint(equalToConstant: mainView.frame.height/5.5).isActive = true

        
        
        labelMaketsProduct.anchor(top: collectionViewOfOwnWorks.bottomAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: collectionViewOfMakets.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 5, bottom: 0, right: 5), size: .init(width: 100, height: 50))
        
        collectionViewOfMakets.anchor(top: labelMaketsProduct.bottomAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: toolBar.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))
    }

}



    //MARK: - adding constraints
extension UIView {
    
    
    func anchor(top: NSLayoutYAxisAnchor?,
                leading:NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        guard let top = top,
            let leading = leading,
            let bottom = bottom,
            let trailing = trailing
            else { return }
        
        topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}



    //MARK:- CollectionView
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainView.frame.width/3 - 10, height: collectionView.frame.width/3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}

