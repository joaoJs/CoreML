//
//  ViewController.swift
//  Seafood
//
//  Created by Joao Campos on 8/23/20.
//  Copyright © 2020 Joao Campos. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        // imagePicker.sourceType = .photolibrary if wanna use library pics
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}

        imageView.image = userPickedImage
        
        guard let ciimage = CIImage(image: userPickedImage) else {return}
        
        detect(image: ciimage)
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {return}
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {return}
            
//            print(results)
            guard let firstResult = results.first else {return}
            if firstResult.identifier.contains("poncho") {
                self.navigationItem.title = "Is Poncho!"
            } else {
                self.navigationItem.title = "Is not Poncho..."
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print("error handling request")
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

