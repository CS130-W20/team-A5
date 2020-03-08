//
//  CameraController.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/19/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import SwiftUI

class CameraController: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: Image?
    @Binding var pic_url: String
    
    init(isShown: Binding<Bool>, image: Binding<Image?>, pic_url: Binding<String>) {
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
        _pic_url = pic_url
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let uniqueName = UUID().uuidString
        imageInCoordinator = Image(uiImage: unwrapImage)
        isCoordinatorShown = false
        // here is where one would upload file to firebase
        if let data = unwrapImage.pngData(){
            FirebaseStorageManager().uploadImageData(data: data, serverFileName: uniqueName , completionHandler: { (isSuccess, add) in if isSuccess {self.pic_url = add!} else {print("reallydidnt work") }   })
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
}

