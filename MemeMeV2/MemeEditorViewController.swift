//
//  MemeEditorViewController.swift
//  MemeMeV2
//
//  Created by Dr GJK Marais on 2016/10/18.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var bottonToolbar: UIToolbar!
    @IBOutlet weak var exportButton: UIBarButtonItem!
        
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
        ] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        topText = textFieldInitialise(textfield: topText, content: "TOP", delegate: self)
        bottomText = textFieldInitialise(textfield: bottomText, content: "BOTTOM", delegate: self)
    }
    
    //Clears the default text
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP") || (textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    //Sets textfield attributes
    func textFieldInitialise(textfield: UITextField, content: String, delegate: UITextFieldDelegate) -> UITextField {
        let finalTextfield = textfield
        finalTextfield.delegate = delegate
        finalTextfield.defaultTextAttributes = memeTextAttributes
        finalTextfield.textAlignment = .center
        finalTextfield.text = content
        return finalTextfield
    }
    
    //Dismisses keyboard on return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    //Ensures camera is available before making button useable
    //Subscribes to keyboard notifications allowing appropriate shift of keyboard
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        exportButton.isEnabled = !(imagePicked.image == nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isEditing {
        view.frame.origin.y -= getKeyboardHeight(notification: notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    //Attaches Notification center allowing the shifting of the keyboard appropriately
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
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
    
    //cancel meme creation
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Create meme image from textfields and chosen image
    func generateMemeImage() -> UIImage {
        // Render view to an image
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = false
        
        return memedImage
    }
    
    //Exporting a meme
    @IBAction func exportMeme(_ sender: AnyObject) {
        let image = generateMemeImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }

        }
        self.present(controller, animated: true, completion: nil)
    }
    
    //Adds the created meme to the meme array for access by collection/tableview
    func save() {
        let meme = MemeStruct(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePicked.image!, memeImage: generateMemeImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    //Restarts the meme creation
    @IBAction func clearMeme(_ sender: AnyObject) {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imagePicked.image = nil
        exportButton.isEnabled = false
    }
    
}

