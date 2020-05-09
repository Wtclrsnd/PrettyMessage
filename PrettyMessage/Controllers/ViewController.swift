//
//  ViewController.swift
//  PrettyMessage
//
//  Created by Emil Shpeklord on 25.04.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import UIKit
import iOSPhotoEditor

class ViewController: UIViewController {

//MARK: - variables
    var mainCollectionView: UICollectionView!
    private var viewModel = TestViewModel()
    private var src = source()
    private var allTitles: [String] = []
    private var buttonTapped = false
    private var buttonAction: (()->Void)?
    private var targetSection: Int?
    private var camImage: UIImage?
    private var titleOnChange: (()->Void)?
    
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
        mainCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        mainCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainCollectionView.backgroundColor = .white
        mainCollectionView.allowsSelection = true
        mainCollectionView.isUserInteractionEnabled = true
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        view.addSubview(mainCollectionView)
        
        mainCollectionView.register(imageCell.self, forCellWithReuseIdentifier: imageCell.reuseId)
        mainCollectionView.register(sectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeader.reuseId)
        
        title = "Шаблоны"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.organize, target: self, action: #selector(useUserPhoto))
        let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(takeAPhoto))
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = rightItem
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 7, bottom: 40, right: 7)
        return layout
    }

}



//MARK: -  Camera and Library actions
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func useUserPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    @objc func takeAPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.showsCameraControls = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Camera is unavilable!", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let img = info[.originalImage] as? UIImage else { return }
        self.camImage = img

        picker.dismiss(animated: true, completion: nil)
        
        callingEditor(img)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



//MARK: - UIView Extension
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
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if src.sections[section].content.count < 6 || buttonTapped && targetSection == section {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = src.sections[indexPath.section].content[indexPath.item].uri
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeader.reuseId, for: indexPath) as? sectionHeader
        let text = src.sections[indexPath.section].header
        if allTitles.count <= collectionView.numberOfSections {
            allTitles.append(text)
        } else {
        }
        header?.mySection = indexPath.section
        header?.title.text = " " + text
        if src.sections[indexPath.section].content.count >= 6{
            header?.button.isHidden = false
        } else {
            header?.button.isHidden = true
        }
        header?.buttonAction = { [weak self] targetSection in
            self?.targetSection = targetSection
            self?.buttonTapped = header?.buttonTapped ?? false
            print("booom")
            DispatchQueue.main.async {
                self?.mainCollectionView.reloadData()
            }
        }
        header?.button.tag = indexPath.section
        return header!
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return src.sections.count
    }
    
}



//MARK: - Photo Editor
extension ViewController: PhotoEditorDelegate {
    
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

