//
//  camera.swift
//  ios1
//
//  Created by Set on 2017/10/9.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit

class camera: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoImage: UIImageView!//顯示相片的圖片
    
    //開啟相機
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    //開啟相簿
    @IBAction func photoLibraryPressed(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    //拍照功能
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            photoImage.image = image
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        dismiss(animated:true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

