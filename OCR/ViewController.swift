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
    
    @IBOutlet var linkLabel: TTTAttributedLabel!
    @IBOutlet var label2:UILabel!
    
    let delayTime = DispatchTime.now() + Double(Int64(0 * Double(NSEC_PER_SEC)))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        first = true
        tesseract.delegate = self
        

    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

        if first == true{
            
        
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
           //  インスタンスの作成
            picker = UIImagePickerController()
            picker!.sourceType = sourceType
            picker!.delegate = self
            picker!.allowsEditing = false
            present(picker!, animated: true, completion: nil)
            first = false
            
        }
    }
}

    private func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let photoTweaksViewController: PhotoTweaksViewController = PhotoTweaksViewController(image: info[UIImagePickerControllerOriginalImage] as? UIImage)
        
        photoTweaksViewController.delegate = self
        photoTweaksViewController.autoSaveToLibray = false
        photoTweaksViewController.maxRotationAngle = CGFloat(M_PI_4*2)
        
        picker!.pushViewController(photoTweaksViewController, animated: true)
    }
    
    func photoTweaksController(_ controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
        
        image = croppedImage
        
        tesseract.image = image
        tesseract.recognize()
        let text: String! = tesseract.recognizedText
//        let linkLabel = TTTAttributedLabel(frame: CGRect(x: 0, y: 80, width: self.view.bounds.size.width, height: 490))
        linkLabel.delegate = self
        linkLabel.numberOfLines = 0
        
        // セットした文字列からURLを見つけてくれるように設定
        linkLabel.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        
        // リンクを押しているときのフォントを指定
        linkLabel.activeLinkAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 17.0)]
        
        // 表示する文字列をセット
        linkLabel.setText(text)
        
        // 表示
       // linkLabel.center = self.view.center
        linkLabel.backgroundColor = UIColor(red:0.81, green:0.88, blue:0.92, alpha:1.00)
        linkLabel.adjustsFontSizeToFitWidth = true
       // self.view.addSubview(linkLabel)
        print(linkLabel.text!)
        
        controller.dismiss(animated: true, completion: nil)
        //linkLabel.text = String(linkLabel.activeLink.result.URL)
        
    }
    private func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        // Safariで開く

        
        url2  = url
       self.performSegue(withIdentifier: "web", sender: nil)
        
    }
    @IBAction func webview(){
        self.performSegue(withIdentifier: "web", sender: nil)

    }
    
    func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController!) {
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraStart(){
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            // インスタンスの作成
            picker = UIImagePickerController()
            picker!.sourceType = sourceType
            picker!.delegate = self
            picker!.allowsEditing = false
            present(picker!, animated: true, completion: nil)
            first = false
        }
    }
}


