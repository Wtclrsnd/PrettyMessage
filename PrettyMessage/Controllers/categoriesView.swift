//
//  categoriesView.swift
//  PrettyMessage
//
//  Created by Григорий Селезнев on 07.05.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//
import UIKit
import iOSPhotoEditor
import Kingfisher

class categoriesView: UIViewController {
    
    var openedSectionInt: Int?
    var openedSection: section?
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLayout()
    }
    
//MARK: - UI Layout
    func addLayout() {
        let layout = createCollectionViewLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        collectionView.register(imageCell.self, forCellWithReuseIdentifier: imageCell.reuseId)
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .systemBlue
        title = openedSection?.header
    }
    
    func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 7, bottom: 40, right: 7)
        return layout
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ImageCache.default.clearMemoryCache()
    }
    
    deinit {
        openedSectionInt = nil
        openedSection = nil
        collectionView = nil
        print ("full is deinit")
    }
}



//MARK: - CollectionView
extension categoriesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (openedSection?.content.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? imageCell
        if openedSection != nil{
            let myUrl = openedSection!.content[indexPath.row].uri
            let encoded = myUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
            let urlencoded = URL(string: encoded)
            cell?.image.kf.indicatorType = .activity
            cell?.image.kf.setImage(with: urlencoded)
        }

        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = openedSection!.content[indexPath.item].uri
               let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
               let urlencoded = URL(string: encoded)
               do {
                   let data = try Data(contentsOf: urlencoded! as URL)
                   let img = UIImage(data: data)
                   if img != nil{
                       callingEditor(img!)
                   }
               } catch {
                   print("Unable to load data: \(error)")
               }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width - 45) / 3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

//MARK: - Photo Editor
extension categoriesView: PhotoEditorDelegate {
    
    func doneEditing(image: UIImage) {
         UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
        
    func canceledEditing() {
        print("Canceled")
    }
    
    func callingEditor(_ image: UIImage){
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
            photoEditor.photoEditorDelegate = self
            photoEditor.image = image
            
            photoEditor.modalPresentationStyle = UIModalPresentationStyle.currentContext
            present(photoEditor, animated: true, completion: nil)
        
        for i in 0...10 {
        photoEditor.stickers.append(UIImage(named: i.description )!)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Ошибка сохранения", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Сохранено!", message: "Фото было загружено в библиотеку.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

