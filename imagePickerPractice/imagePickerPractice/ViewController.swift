//
//  ViewController.swift
//  imagePickerPractice
//
//  Created by Joel on 4/9/16.
//  Copyright © 2016 Joel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var imageToolbar: UIToolbar!
    @IBOutlet weak var shareNavBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var introMeme: UIImageView!
    @IBOutlet weak var selectImagePrompt: UILabel!
   
   
    
    var memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "impact", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
// Gives sets up initial text in textfields
    func textSetup (){
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        if topText.text == ""{
            topText.text = "TOP"
        }
        if bottomText.text == ""{
        bottomText.text = "BOTTOM"
        }
        
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        
        self.topText.delegate = self
        self.bottomText.delegate = self
    }
    
// Clears textfields when user begins editing
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textSetup()
        
        selectImagePrompt.text = "Choose an Image to Make Your Meme"
        selectImagePrompt.textColor = UIColor.whiteColor()
        
        view.backgroundColor = UIColor.blackColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        shareButton.enabled = imagePickerView.image != nil
        cancelButton.enabled = imagePickerView.image != nil
        selectImagePrompt.hidden = imagePickerView.image != nil
        introMeme.hidden = imagePickerView.image != nil
        
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }

// Subribes to keyboard notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }

// unsubcribes from keyboard notifications
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }

// Shows keyboard
    func keyboardWillShow(notification: NSNotification) {
        if self.bottomText.isFirstResponder(){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
// Hides keyboard
    func keyboardWillHide (notification: NSNotification){
        if self.bottomText.isFirstResponder(){
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
// Gets keyboard height for showing and hiding it without blocking bottom textfield
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
// Dismisses keyboard when return is pressed
    func textFieldShouldReturn(topText: UITextField) -> Bool {
        topText.resignFirstResponder()
        bottomText.resignFirstResponder()
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

// Allows user to choose imag from album
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
// Allows user to choose image from camera
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
// Allows user to choose font
    @IBAction func choooseFontType (sender: AnyObject){
        
        func changeFontName (fontNameChosen: String) {
            let fontType: String = fontNameChosen
            self.memeTextAttributes[NSFontAttributeName] = UIFont(name: fontType, size: 40)!
            self.textSetup()
        }
        
        let alertController = UIAlertController(title: "Pick Your Meme Font", message: "", preferredStyle: .ActionSheet)
        
        let defaultFontAction = UIAlertAction(title: "Impact (Default)", style: .Default, handler: {
            action in
            
            changeFontName("Impact")
            
            }
        )
        
        alertController.addAction(defaultFontAction)
        
        let timesNewRomanAction = UIAlertAction(title: "Times New Roman", style: .Default, handler: {
            action in
            
            changeFontName("Times New Roman")
            }
        )
        
        alertController.addAction(timesNewRomanAction)
        
        let helveticaAction = UIAlertAction(title: "Helvetica Neue", style: .Default, handler: {
            action in
            
            changeFontName("Helvetica Neue")
            }
        )
        
        alertController.addAction(helveticaAction)


        let markerFeltAction = UIAlertAction(title: "Marker Felt", style: .Default, handler: {
            action in
            
            changeFontName("Marker Felt")
            }
        )
        
        alertController.addAction(markerFeltAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
// Saves Meme object
    func save(newMemedImage : UIImage) {

        _ = Meme( memeTopText: topText.text!, memeBottomText: bottomText.text!, image: imagePickerView.image, memedImage: newMemedImage)
    }
        

// Creates a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        
        imageToolbar.hidden = true
        shareNavBar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageToolbar.hidden = false
        shareNavBar.hidden = false
        return memedImage
    }
    
// Allows user to share created Meme
    @IBAction func shareMemeImage(sender: UIBarButtonItem) {

        let memeToShare = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memeToShare as UIImage], applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { (activty, completed, items, error) in
            if completed{
                self.save(memeToShare)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    
// Returns user to home screen
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imagePickerView.image = nil
        shareButton.enabled = false
        cancelButton.enabled = false
        selectImagePrompt.hidden = false
        introMeme.hidden = false
        
    }
    
    
   
}

