//
//  ImageUtils.swift
//  RooMate
//
//  Created by Ron Hirsch on 15/05/2020.
//  Copyright © 2020 Ron Hirsch. All rights reserved.
//

import Foundation
import UIKit

class ImageUtils: UIViewController, UIImagePickerControllerDelegate
{
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage
    {

        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)

        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

        return image
    }
    
    public func saveImage(imageName: String, image: UIImage, folderPath: String)
    {
        // guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // let fileName = imageName
        // let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let fullPath = folderPath + imageName + ".jpeg"
        let fileURL = URL(fileURLWithPath: fullPath)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        
        do {
            // try data.write(to: fileURL)
            // let dir = URL(fileURLWithPath: "/Users/ronhirsch/Desktop/debug.jpeg")
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        
    }
    
    /*func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = UIImage(data: data)
            }
        }
    }*/
}
