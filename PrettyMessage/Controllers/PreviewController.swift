//
//  PreviewController.swift
//  PrettyMessage
//
//  Created by Григорий Селезнев on 09.06.2020.
//  Copyright © 2020 Бизнес в стиле .RU. All rights reserved.
//

import Foundation
import UIKit

class preView: UIViewController{
    
    var preImage: UIImage?
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        let preImageView = UIImageView()
        preImageView.image = preImage
        preImageView.contentMode = .scaleAspectFit
        
        view.addSubview(preImageView)
        preImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        navigationController?.isToolbarHidden = false
        if #available(iOS 13.0, *) {
            navigationController?.toolbar.backgroundColor = .systemBackground
            view.backgroundColor = .systemBackground
        } else {
            navigationController?.toolbar.backgroundColor = .white
            view.backgroundColor = .white
        }
        toolbarItems = [UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))]
        toolbarItems?.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        toolbarItems?.append(UIBarButtonItem(image: UIImage(named: "Share"), style: .plain, target: self, action: #selector(share(_ :))))
        
    }
    
    @objc func save() {
        let img = self.preImage!
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func share(_ sender: UIBarButtonItem) {
        let activity = UIActivityViewController(
          activityItems: ["Отправить Изображение", preImage!],
          applicationActivities: nil
        )
        activity.popoverPresentationController?.barButtonItem = sender

        // 3
        present(activity, animated: true, completion: nil)
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
