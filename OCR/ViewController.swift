//
//  ViewController.swift
//  OCR
//
//  Created by Family Account on 2016/05/08.
//  Copyright © 2016年 Family Account. All rights reserved.
//


import UIKit
import TesseractOCR
import PhotoTweaks
import TTTAttributedLabel

var url2:NSURL!

class ViewController: UIViewController, G8TesseractDelegate ,UINavigationControllerDelegate, UIImagePickerControllerDelegate,PhotoTweaksViewControllerDelegate,TTTAttributedLabelDelegate{
    
    var tesseract: G8Tesseract = G8Tesseract(language: "eng")
    var image:UIImage!
    var picker :UIImagePickerController?
    var first:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        first = true
        tesseract.delegate = self
        

    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        if first == true{
            
        
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
           //  インスタンスの作成
            picker = UIImagePickerController()
            picker!.sourceType = sourceType
            picker!.delegate = self
            picker!.allowsEditing = false
            presentViewController(picker!, animated: true, completion: nil)
            first = false
            
        }
    }
}

    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let photoTweaksViewController: PhotoTweaksViewController = PhotoTweaksViewController(image: info[UIImagePickerControllerOriginalImage] as? UIImage)
        
        photoTweaksViewController.delegate = self
        photoTweaksViewController.autoSaveToLibray = false
        photoTweaksViewController.maxRotationAngle = CGFloat(M_PI_4*2)
        
        picker!.pushViewController(photoTweaksViewController, animated: true)
    }
    
    func photoTweaksController(controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
        
        image = croppedImage
        
        tesseract.image = image
        tesseract.recognize()
        let text = tesseract.recognizedText
        let linkLabel = TTTAttributedLabel(frame: CGRect(x: 0, y: 80, width: self.view.bounds.size.width, height: 490))
        linkLabel.delegate = self
        linkLabel.numberOfLines = 0
        
        // セットした文字列からURLを見つけてくれるように設定
        linkLabel.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        
        // リンクを押しているときのフォントを指定
        linkLabel.activeLinkAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(17.0)]
        
        // 表示する文字列をセット
        linkLabel.setText(text)
        
        // 表示
       // linkLabel.center = self.view.center
        linkLabel.backgroundColor = UIColor(red:0.81, green:0.88, blue:0.92, alpha:1.00)
        linkLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(linkLabel)

        print(tesseract.recognizedText)

        controller.dismissViewControllerAnimated(true, completion: nil)
    
    }
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        // Safariで開く

        
        url2  = url
       self.performSegueWithIdentifier("web", sender: nil)
        
    }
    @IBAction func webview(){
        self.performSegueWithIdentifier("web", sender: nil)

    }
    
    func photoTweaksControllerDidCancel(controller: PhotoTweaksViewController!) {
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraStart(){
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            // インスタンスの作成
            picker = UIImagePickerController()
            picker!.sourceType = sourceType
            picker!.delegate = self
            picker!.allowsEditing = false
            presentViewController(picker!, animated: true, completion: nil)
            first = false
        }
    }
}


