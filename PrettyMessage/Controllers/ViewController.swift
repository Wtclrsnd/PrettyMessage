//
//  ViewController.swift
//  PrettyMessage
//
//  Created by Emil Shpeklord on 25.04.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import UIKit
import Kingfisher
import PhotoEditorSDK

class ViewController: UIViewController {
    
//MARK: - variables
    var mainCollectionView: UICollectionView!
    private var viewModel = TestViewModel()
    private var src = source()
    private var allTitles: [String] = []
    private var targetSection: Int?
    private var camImage: UIImage?
    private var refreshControl = UIRefreshControl()

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLayout()
        DispatchQueue.main.async {
            self.viewModel.onGetting = { [weak self] in
                if let framesModel = self?.viewModel.framesModel {
                    if let source = self?.makingSource(raw: framesModel) { self?.src = source }
                } else {
                    self?.errorScreen()
                }
                ImageCache.default.clearMemoryCache()
                self?.mainCollectionView.reloadData()
                self?.mainCollectionView.refreshControl?.endRefreshing()
            }
        }
        mainCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        viewModel.grabData()
        viewModel.framesModel?.removeAll()
    }
    
    @objc private func refreshData(_ sender: Any) {
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
        if #available(iOS 13.0, *) {
            mainCollectionView.backgroundColor = .systemBackground
        } else {
            mainCollectionView.backgroundColor = .white
        }
        mainCollectionView.allowsSelection = true
        mainCollectionView.isUserInteractionEnabled = true
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        view.addSubview(mainCollectionView)
        
        mainCollectionView.register(imageCell.self, forCellWithReuseIdentifier: imageCell.reuseId)
        mainCollectionView.register(sectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeader.reuseId)
        
        title = "Шаблоны"
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.tintColor = .systemBackground
        } else {
            navigationController?.navigationBar.tintColor = .white
        }
        navigationController?.navigationBar.isTranslucent = false
        
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.organize, target: self, action: #selector(useUserPhoto))
        let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(takeAPhoto))
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = rightItem
        navigationController?.navigationBar.tintColor = .systemBlue
        
        let photoRec = UISwipeGestureRecognizer(target: self, action: #selector(photoRecognizer))
        photoRec.direction = .left
        let albumRec = UISwipeGestureRecognizer(target: self, action: #selector(photoRecognizer))
        albumRec.direction = .right
        
        
        view.addGestureRecognizer(photoRec)
        view.addGestureRecognizer(albumRec)
    }
    
    func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 7, bottom: 40, right: 7)
        return layout
    }

    func errorScreen() {
        let errorText = UILabel()
        errorText.text = "Необходимо подключение к интернету!"
        errorText.numberOfLines = 3
        errorText.textAlignment = .center
        errorText.textColor = UIColor(named: "textColor")
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.font = UIFont(name: "Helvetica Neue", size: 40)
        view.addSubview(errorText)
        NSLayoutConstraint.activate([
            errorText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorText.widthAnchor.constraint(equalToConstant: 300)
        ])
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
        imagePickerController.delegate = self
        
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
    
    @objc func photoRecognizer(_ recognizer: UISwipeGestureRecognizer){
        switch recognizer.direction {
        case .left:
            print("camera!")
            takeAPhoto()
        case .right:
            print("album!")
            useUserPhoto()
        default:
            print("oops")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let img = info[.originalImage] as? UIImage else { return }
        self.camImage = img

        picker.dismiss(animated: true, completion: nil)
        
        let photo = Photo(image: img)
        
        let photoEditViewController = PhotoEditViewController(photoAsset: photo)
        photoEditViewController.delegate = self

        present(photoEditViewController, animated: true, completion: nil)
        
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
        cell?.image.kf.indicatorType = .activity
        cell?.image.kf.setImage(with: urlencoded)
    
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
                let photo = Photo(image: img!)

                let photoEditViewController = PhotoEditViewController(photoAsset: photo)
                photoEditViewController.delegate = self

                present(photoEditViewController, animated: true, completion: nil)
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
        header?.title.text = " " + text
        if src.sections[indexPath.section].content.count >= 6{
            header?.button.isHidden = false
        } else {
            header?.button.isHidden = true
        }
        
        header?.button.addTarget(self, action: #selector(btnDo(_ :)), for: .touchUpInside)
        header?.button.tag = indexPath.section
        return header!
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return src.sections.count
    }
    
    @objc func btnDo(_ sender: UIButton) {
        let nextView = categoriesView()
        nextView.openedSectionInt = sender.tag
        nextView.openedSection = src.sections[sender.tag]
        navigationController?.pushViewController(nextView, animated: true)
    }
}



//MARK: - Photo Editor
extension ViewController: PhotoEditViewControllerDelegate {
    func photoEditViewController(_ photoEditViewController: PhotoEditViewController, didSave image: UIImage, and data: Data) {
        let previewController = preView()
      if let navigationController = photoEditViewController.navigationController {
        navigationController.popViewController(animated: true)
      } else {
        navigationController?.pushViewController(previewController, animated: true)
        previewController.preImage = image
        dismiss(animated: true, completion: nil)
      }
    }

    func photoEditViewControllerDidFailToGeneratePhoto(_ photoEditViewController: PhotoEditViewController) {
      if let navigationController = photoEditViewController.navigationController {
        navigationController.popViewController(animated: true)
      } else {
        dismiss(animated: true, completion: nil)
      }
    }

    func photoEditViewControllerDidCancel(_ photoEditViewController: PhotoEditViewController) {
      if let navigationController = photoEditViewController.navigationController {
        navigationController.popViewController(animated: true)
      } else {
        dismiss(animated: true, completion: nil)
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
