//
//  ImagePicker.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/20.
//  Copyright © 2020 Bishal Aryal. All rights reserved.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable
{
    @Binding var images: [UIImage]
    @Binding var picker: Bool
    
    func makeCoordinator() -> Coordinator
    {
        return ImagePicker.Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController
    {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5 - self.images.count
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context)
    {
        
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate
    {
        var parent: ImagePicker
        
        init(parent: ImagePicker)
        {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult])
        {
            // closing picker
            self.parent.picker.toggle()
            
            for img in results
            {
                if img.itemProvider.canLoadObject(ofClass: UIImage.self)
                {
                    img.itemProvider.loadObject(ofClass: UIImage.self)
                    { (image, err) in
                        guard let image = image else
                        {
                            print((err?.localizedDescription)!)
                            return
                        }
                        
                        withAnimation(.easeIn)
                        {
                            self.parent.images.append(image as! UIImage)
                        }
                    }
                }
                else
                {
                    print("cannot be loaded")
                }
            }
        }
    }
}
