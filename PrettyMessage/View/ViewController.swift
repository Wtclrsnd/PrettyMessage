//
//  ViewController.swift
//  PrettyMessage
//
//  Created by Emil Shpeklord on 25.04.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fillBucket: UIBarButtonItem!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!

   
    
    let labelYoursWorks: UITextView = {
        let textView = UITextView()
        textView.text = "Your own works:"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.isEditable = false
        return textView
    }()
    
    let labelMaketsProduct: UITextView = {
        let textView = UITextView()
        textView.text = "Already done:"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.isEditable = false
        return textView
    }()
    
    let first: UIStackView = {
        var stack = UIStackView()
        for i in Range(1 ... 6){
            let image = UIView()
            if i % 3 == 1{
                image.backgroundColor = .red
            }
            else if i % 3 == 2{
                image.backgroundColor = .blue
            }
            else{
                image.backgroundColor = .green
            }
            stack.addArrangedSubview(image)
        }
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let second: UIStackView = {
        var stack = UIStackView()
        for i in Range(1 ... 6){
            let media = UIView()
            if i % 3 == 1{
                media.backgroundColor = .purple
            }
            else if i % 3 == 2{
                media.backgroundColor = .white
            }
            else{
                media.backgroundColor = .gray
            }
            stack.addArrangedSubview(media)
        }
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
     
    fileprivate let collectionViewOfOwnWorks: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    fileprivate let collectionViewOfMakets: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        first.distribution = .fillEqually
        
        mainView.addSubview(labelYoursWorks)
        mainView.addSubview(collectionViewOfOwnWorks)
        mainView.addSubview(labelMaketsProduct)
        mainView.addSubview(collectionViewOfMakets)
        
        collectionViewOfOwnWorks.backgroundColor = .white
        collectionViewOfMakets.backgroundColor = .white
        collectionViewOfOwnWorks.delegate = self
        collectionViewOfOwnWorks.dataSource = self
        collectionViewOfMakets.delegate = self
        collectionViewOfMakets.dataSource = self
        
        labelYoursWorks.anchor(top: mainView.safeAreaLayoutGuide.topAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: collectionViewOfOwnWorks.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 5, bottom: 0, right: 5), size: .init(width: 100, height: 50))
        
        collectionViewOfOwnWorks.anchor(top: labelYoursWorks.bottomAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: labelMaketsProduct.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 20, right: 5))
        collectionViewOfOwnWorks.heightAnchor.constraint(equalToConstant: mainView.frame.height/5.5).isActive = true
        
        labelMaketsProduct.anchor(top: collectionViewOfOwnWorks.bottomAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: collectionViewOfMakets.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 5, bottom: 0, right: 5), size: .init(width: 100, height: 50))

        collectionViewOfMakets.anchor(top: labelMaketsProduct.bottomAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: toolBar.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))

        
    }


}


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


extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
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

