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
        
        viewModel.onGetting = {
            if (self.viewModel.framesModel != nil) {
                self.src = self.makingSource(raw: self.viewModel.framesModel!)!
            }
            self.mainCollectionView.reloadData()
            self.viewModel.framesModel?.removeAll()
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
        let layout = createCollectionViewLayout()
        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mainCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainCollectionView.backgroundColor = .white
        mainCollectionView.allowsSelection = true
        mainCollectionView.isUserInteractionEnabled = true
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        view.addSubview(mainCollectionView)
        
        mainCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: mainView.safeAreaLayoutGuide.leadingAnchor, bottom: toolBar.topAnchor, trailing: mainView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))
        
        
        mainCollectionView.register(imageCell.self, forCellWithReuseIdentifier: imageCell.reuseId)
        mainCollectionView.register(sectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeader.reuseId)
    }
    
    func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let header = createHeader()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 7, bottom: 30, right: 7)
        let size = CGFloat((view.frame.width - 45) / 3)
        layout.itemSize = CGSize(width: size, height: size)
        return layout
    }
    
    //MARK: - DiffableDataSource
//    func createDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<section, FrameModel>(collectionView: mainCollectionView, cellProvider: { (mainCollectionView, indexPath, image) -> UICollectionViewCell? in
//        switch self.src.sections[indexPath.section].header {
//        default:
//                let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? imageCell
//                let myUrl = self.src.sections[indexPath.section].content[indexPath.row].uri
//                    let encoded = myUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
//                    let urlencoded = URL(string: encoded)
//                    cell?.image.kf.setImage(with: urlencoded, placeholder: UIImage(named: "Picture"))
//                return cell
//            }
//        })
//
//        dataSource?.supplementaryViewProvider = {
//            (mainCollectionView, kind, indexPath) in
//            guard let sectionHeader = mainCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeader.reuseId, for: indexPath) as? sectionHeader
//                else {return nil}
//
//            guard let image = self.dataSource?.itemIdentifier(for: indexPath) else {return nil}
//            guard let section = self.dataSource?.snapshot().sectionIdentifier(containingItem: image) else {return nil}
//            if section.header.isEmpty {
//                return nil
//            }
//            sectionHeader.title.text = section.header
//            return sectionHeader
//        }
//    }
//
//    //MARK: - Snapshots
//
//    open func fullSnap(i: String) {
//        var fullSnapshot = NSDiffableDataSourceSnapshot<section, FrameModel>()
//
//        fullSnapshot.appendSections(src.sections)
//
//        for sect in src.sections {
//            if (sect.content.count < 6) || sect.header == i {
//                fullSnapshot.appendItems(sect.content, toSection: sect)
//            } else {
//                let content = [sect.content[0], sect.content[1], sect.content[2], sect.content[3], sect.content[4], sect.content[5]]
//                fullSnapshot.appendItems(content, toSection: sect)
//            }
//        }
//
//        dataSource?.apply(fullSnapshot, animatingDifferences: true)
//    }
//
//    func cutSnap() {
//        var cutSnapshot = NSDiffableDataSourceSnapshot<section, FrameModel>()
//        cutSnapshot.appendSections(src.sections)
//
//        for sect in src.sections {
//            if sect.content.count < 6 {
//                cutSnapshot.appendItems(sect.content, toSection: sect)
//            } else {
//                let content = [sect.content[0], sect.content[1], sect.content[2], sect.content[3], sect.content[4], sect.content[5]]
//                cutSnapshot.appendItems(content, toSection: sect)
//            }
//        }
//
//        dataSource?.apply(cutSnapshot, animatingDifferences: true)
//    }
//
//    //MARK: - СompositionalLayout
//
//    func createCompositionalLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
//            let section = self.src.sections[sectionIndex]
//
//            switch section.header{
//            default:
//                return self.createAppSection()
//            }
//        }
//        return layout
//    }
//
//    func createAppSection() -> NSCollectionLayoutSection{
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.326), heightDimension: .fractionalHeight((view.frame.width - 30)/3))
//
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets.init(top: 5, leading: 5, bottom: 0, trailing: 0)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1))
//
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 7, bottom: 30, trailing: 7)
//
//        let header = createHeader()
//        section.boundarySupplementaryItems = [header]
//
//        return section
//    }
//
    func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {

        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        return sectionHeader
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


//MARK: - CollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if src.sections[section].content.count < 6 {
            return src.sections[section].content.count
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? imageCell
        let myUrl = self.src.sections[indexPath.section].content[indexPath.row].uri
        let encoded = myUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        let urlencoded = URL(string: encoded)
        
        cell?.image.kf.setImage(with: urlencoded, placeholder: UIImage(named: "Picture"))
        
        return cell ?? UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return src.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 15,bottom: 0,right: 15)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width - 15) / 3
        return CGSize(width: size, height: size)
    }
    
//    func collectionView(layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        let sectionInsets = UIEdgeInsets(top: 10, left: 7, bottom: 30, right: 7)
//        return sectionInsets
//    }
    
    func collectionView(layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
