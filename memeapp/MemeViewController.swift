//
//  MemeViewController.swift
//  memeapp
//
//  Created by Khoa on 08/03/2024.
//

import Foundation
import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate,UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextView: UITextField!
    @IBOutlet weak var bottomTextView: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initTextField(topTextView,isTop: true)
        initTextField(bottomTextView,isTop: false)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topTextView.layer.zPosition = 1
        bottomTextView.layer.zPosition = 1
        imagePickerView.layer.zPosition = 0
    }
    func initTextField(_ textView: UITextField,isTop: Bool){
        textView.text = isTop ? "top".uppercased() : "bottom".uppercased()
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -3.5,
        ]
        textView.defaultTextAttributes = memeTextAttributes
        
        textView.textAlignment = .center
        textView.borderStyle = .none
        textView.autocapitalizationType = .words
        textView.textColor = UIColor.white
        
        textView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
#if targetEnvironment(simulator)
        cameraButton.isEnabled = false
#else
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
#endif
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    func pickImage(sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickImage(sourceType: .camera)
    }
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickImage(sourceType: .photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text as NSString? {
            let newText = currentText.replacingCharacters(in: range, with: string)
            
            textField.text = newText.uppercased()
            
            return false
        }
        
        return true
    }
    @objc func keyboardWillShow(_ notification:Notification){
        if bottomTextView.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
        
    }
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        let memedImage = generateMemedImage()

        // Create an instance of UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed){
                self.save(memedImage: memedImage)
                self.dismiss(animated: true,completion: nil)
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: self.topTextView.text!, bottomText: self.bottomTextView.text!, originalImage: self.imagePickerView.image!, memedImage: memedImage)
        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.append(meme)

        // Access UserDefaults
        let userDefaults = UserDefaults.standard

        // Encode the array of Meme objects
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(appDelegate.memes) {
            // Save the encoded data to UserDefaults
            userDefaults.set(encodedData, forKey: "memes")
        } else {
            print("Failed to encode memes array.")
        }
    }
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
}
