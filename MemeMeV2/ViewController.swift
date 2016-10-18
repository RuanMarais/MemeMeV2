//
//  ViewController.swift
//  MemeMeV2
//
//  Created by Dr GJK Marais on 2016/10/18.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
        ] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topText = textFieldInitialise(textfield: topText, content: "TOP", delegate: self)
        bottomText = textFieldInitialise(textfield: bottomText, content: "BOTTOM", delegate: self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP") || (textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldInitialise(textfield: UITextField, content: String, delegate: UITextFieldDelegate) -> UITextField {
        let finalTextfield = textfield
        finalTextfield.delegate = delegate
        finalTextfield.defaultTextAttributes = memeTextAttributes
        finalTextfield.textAlignment = .center
        finalTextfield.text = content
        return finalTextfield
    }
    
    //Ensures camera is available before making button useable
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    //Action to select an image from photo library
    @IBAction func albumOpen(_ sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    //To cancel the image selection view controller
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Select an image from the album and sets it to the main image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePicked.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraOpen(_ sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.camera
        self.present(pickerController, animated: true, completion: nil)
    }
    
}

