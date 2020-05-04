//
//  ViewController.swift
//  PrettyMessage
//
//  Created by Emil Shpeklord on 25.04.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var fillBucket: UIBarButtonItem!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //MARK: - variables
    var mainCollectionView: UICollectionView!
    private var viewModel = TestViewModel()
    private var src = source()
    
    private var dataSource: UICollectionViewDiffableDataSource<section, FrameModel>?

    //photo source - FramesModel.swift
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLayout()
        
        createDataSource()
        
        viewModel.onGetting = {
            if (self.viewModel.framesModel != nil) {
                self.src = self.makingSource(raw: self.viewModel.framesModel!)!
            }
            self.reloadData()
        }
        viewModel.grabData()
    }
    
    func makingSource(raw: FramesModel?) -> source?{
        if raw == nil {
            return nil
        } else {
            let src = source(raw: raw!)
            return src
        }
    }
    
    //MARK: - UI layout
    func addLayout() {
        
        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        mainCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainCollectionView.backgroundColor = .white
        
//        mainCollectionView.delegate = self
//        mainCollectionView.dataSource = self
        
        view.addSubview(mainCollectionView)
        
        mainCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: toolBar.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        
        
        mainCollectionView.register(imageCell.self, forCellWithReuseIdentifier: imageCell.reuseId)
    }
    
    
    //MARK: - DiffableDataSource
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<section, FrameModel>(collectionView: mainCollectionView, cellProvider: { (mainCollectionView, indexPath, image) -> UICollectionViewCell? in
        switch self.src.sections[indexPath.section].header {
        default:
                let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? imageCell
                let myUrl = self.src.sections[indexPath.section].content[indexPath.row].uri
                    let encoded = myUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
                    let urlencoded = URL(string: encoded)
                    cell?.image.kf.setImage(with: urlencoded, placeholder: UIImage(named: "Picture"))
                return cell
            }
        })
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<section, FrameModel>()
        snapshot.appendSections(src.sections)
        
        for sect in src.sections {
            snapshot.appendItems(sect.content, toSection: sect)
        }
        
        dataSource?.apply(snapshot)
    }
    //MARK: - Creating compositional layout
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            let section = self.src.sections[sectionIndex] //нужно изменить это все под получаемые данные как в видосе таймкод 18:28
            
            switch section.header{
            default:
                return self.createAppSection()
            }
        }
        return layout
    }
    
    func createAppSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.326), heightDimension: .fractionalHeight((view.frame.width - 30)/3))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 5, leading: 5, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 30, leading: 10, bottom: 0, trailing: 10) //
        
        return section
        
    }
}


    //MARK: -  Camera and Library actions
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func useUserPhoto(_ sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func takeAPhoto(_ sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Camera is unavilable!", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        
        let _ = image //this is an image for segue
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//this code is useful in layout bro
//
//        //UserData CV
//        let labelYoursWorks: UITextView = {
//        let userHeaderLabel = UITextView()
//        userHeaderLabel.text = "Your own works:"
//        userHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
//        userHeaderLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        userHeaderLabel.isEditable = false
//        return userHeaderLabel
//        }()
//
//        let collectionViewOfOwnWorks: UICollectionView = {
//            let layout = UICollectionViewFlowLayout()
//            layout.scrollDirection = .horizontal
//            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//            let userCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//            userCollectionView.allowsSelection = true
//            userCollectionView.translatesAutoresizingMaskIntoConstraints = false
//            userCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//            return userCollectionView
//        }()
//
//        collectionViewOfOwnWorks.delegate = self
//        collectionViewOfOwnWorks.dataSource = self
//        collectionViewOfOwnWorks.backgroundColor = .white
//
//
//
//        //Makets CV
//        let labelMaketsProduct: UITextView = {
//            let maketsHeaderLabel = UITextView()
//            maketsHeaderLabel.text = "Layouts:"
//            maketsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
//            maketsHeaderLabel.font = UIFont.boldSystemFont(ofSize: 20)
//            maketsHeaderLabel.isEditable = false
//            return maketsHeaderLabel
//        }()
//
//
//        let collectionViewOfMakets: UICollectionView = {
//            let layout = UICollectionViewFlowLayout()
//            layout.scrollDirection = .vertical
//            layout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
//            let mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//            mainCollectionView.allowsSelection = true
//            mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
//            mainCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//
//            return mainCollectionView
//        }()
//
//        collectionViewOfMakets.backgroundColor = .white
//        collectionViewOfMakets.delegate = self
//        collectionViewOfMakets.dataSource = self
//
//
//        mainView.addSubview(labelMaketsProduct)
//        mainView.addSubview(collectionViewOfMakets)
//        mainView.addSubview(labelYoursWorks)
//        mainView.addSubview(collectionViewOfOwnWorks)
//
//        //Constraints
//        labelYoursWorks.anchor(top: mainView.safeAreaLayoutGuide.topAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: collectionViewOfOwnWorks.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 5, bottom: 0, right: 5), size: .init(width: 100, height: 50))
//
//        collectionViewOfOwnWorks.anchor(top: labelYoursWorks.bottomAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: labelMaketsProduct.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 20, right: 5))
//        collectionViewOfOwnWorks.heightAnchor.constraint(equalToConstant: mainView.frame.height/5.5).isActive = true
//
//
//
//        labelMaketsProduct.anchor(top: collectionViewOfOwnWorks.bottomAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: collectionViewOfMakets.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 5, bottom: 0, right: 5), size: .init(width: 100, height: 50))
//
//        collectionViewOfMakets.anchor(top: labelMaketsProduct.bottomAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: toolBar.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))
//    }
//
//}
//
//
//
//    //MARK: - UIView Extension
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
//this shit must go down after adding network. Diffable Data Source will replace it
//extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return src.sections.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return src.sections[section].content.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? imageCell{
//            let myUrl = src.sections[indexPath.section].content[indexPath.row].uri
//            let encoded = myUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
//            let urlencoded = URL(string: encoded)
//            cell.image.kf.setImage(with: urlencoded, placeholder: UIImage(named: "Picture"))
//            cell.backgroundColor = .purple
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//
//}
