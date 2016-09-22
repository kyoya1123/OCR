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
import GoogleMobileAds
import SVProgressHUD


var url2:NSURL!

var date :String!
class ViewController: UIViewController, G8TesseractDelegate ,UINavigationControllerDelegate, UIImagePickerControllerDelegate,PhotoTweaksViewControllerDelegate,TTTAttributedLabelDelegate,UITextFieldDelegate,GADBannerViewDelegate,GADInterstitialDelegate{
    
    var tesseract: G8Tesseract = G8Tesseract(language: "eng")
    var image:UIImage!
    var picker :UIImagePickerController?
    var first:Bool!
    var linkString:String!
    let delayTime = DispatchTime.now() + Double(Int64(0 * Double(NSEC_PER_SEC)))
    var count: Int = 0
    @IBOutlet var linkLabel: TTTAttributedLabel!
    

    
 //   let interstitial = GADInterstitial(adUnitID: "ca-app-pub-4998156736658881/9926903055")
 //   let request = GADRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if HistoryData.object(forKey: "urlHistory") != nil {
        
        URLlist = HistoryData.object(forKey: "urlHistory") as! [String]
        timeList = HistoryData.object(forKey: "timeHistory") as! [String]
        }
        first = true
        tesseract.delegate = self
        
        //広告
        var bannerView: GADBannerView = GADBannerView()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - bannerView.frame.height)
        bannerView.frame.size = CGSize(width: self.view.frame.width, height: bannerView.frame.height)
        
        bannerView.adUnitID = "ca-app-pub-4998156736658881/3439717453"
        bannerView.delegate = self
        bannerView.rootViewController = self
        let gadRequest: GADRequest = GADRequest()
        gadRequest.testDevices = ["595ac722101c364a0f80a658bcfb8b1b"]//テスト時のみ
        bannerView.load(gadRequest)
        self.view.addSubview(bannerView)
        
        
        
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
    
    
    func time() -> String{
        let now = NSDate() // 現在日時の取得
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: now as Date)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let photoTweaksViewController: PhotoTweaksViewController = PhotoTweaksViewController(image: info[UIImagePickerControllerOriginalImage] as? UIImage)
        
        photoTweaksViewController.delegate = self
        photoTweaksViewController.autoSaveToLibray = false
        photoTweaksViewController.maxRotationAngle = CGFloat(M_PI_4*2)
        
        picker.pushViewController(photoTweaksViewController, animated: true)
        
    }
    
    func photoTweaksController(_ controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
        
    
        SVProgressHUD.show(withStatus: "Loading...")
       
                
        dispatch_async_global {
        
        self.image = croppedImage
        self.tesseract.image = self.image
        self.tesseract.recognize()
        let text: String! = self.tesseract.recognizedText
        self.linkLabel.delegate = self
        self.linkLabel.numberOfLines = 0
        
        // セットした文字列からURLを見つけてくれるように設定
        self.linkLabel.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        // リンクを押しているときのフォントを指定
        self.linkLabel.activeLinkAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 17.0)]
        self.linkLabel.adjustsFontSizeToFitWidth = true
        
        print(self.linkLabel.text!)
        
        
        controller.dismiss(animated: true, completion: nil)
        
        
        let URLstring = self.pickUpURLFromString(string: text) as! [String]
        if URLstring.count > 0 {
            self.linkLabel.setText(URLstring[0])
            self.linkString = URLstring[0]
            
        }else{
            let alertView = UIAlertController(title: "", message: "URLが検出されませんでした", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in
                self.openPicker()
            }))
            self.present(alertView, animated: true, completion: nil)
        }
            self.dispatch_async_main {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func dispatch_async_main(block: @escaping () -> ()) {
        DispatchQueue.main.async(execute: block)
    }
    
    func dispatch_async_global(block: @escaping () -> ()) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }

    
    
    func pickUpURLFromString(string: String) -> NSArray {
        
        let URLPattern: String = "(http://|https://){1}[\\w\\.\\-/:]+"
        var regularExpressionForPickOut = NSRegularExpression()
        //= try as NSRegularExpression(pattern: URLPattern, options: NSRegularExpressionOptions(rawValue: 0))
        
        do {
            regularExpressionForPickOut = try NSRegularExpression(pattern: URLPattern, options: NSRegularExpression.Options(rawValue: 0))
        } catch _ as NSError {
            // エラー処理
        }
        
        // 検索対象の文字列の中から正規表現にマッチした件数分の結果を取得
        let matchesInString: NSArray = regularExpressionForPickOut.matches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count)) as NSArray
        
        // 検索結果を配列に入れる
        var strings: [String] = [String]()
        for i in 0..<matchesInString.count {
            let checkingResult = matchesInString[i] as! NSTextCheckingResult
            let range = checkingResult.rangeAt(0)
            if range.location != NSNotFound {
                let matchString = (string as NSString).substring(with: range) as String
                if !matchString.isEmpty {
                    strings.append(matchString)
                }
            }
            //            let expressionPattern = string.substringWithRange(range) as String
            //            strings.append(expressionPattern)
        }
        
        print(strings)
        return strings as NSArray
        //    NSString *expressionPattern = [string substringWithRange:[checkingResult rangeAtIndex:0]];
    }
    
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        
        let confirmAlert = UIAlertController(title: "このURLでよろしいですか？", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        confirmAlert.addAction(UIAlertAction(title: "アプリ内で開く", style: UIAlertActionStyle.default, handler: {action in
            url2 = NSURL(string: (confirmAlert.textFields?[0].text)!)
            timeList.append(self.time())
            URLlist.append((confirmAlert.textFields?[0].text)!)
            HistoryData.set(URLlist, forKey: "urlHistory")
            HistoryData.set(timeList, forKey: "timeHistory")
            
            
            self.performSegue(withIdentifier: "web", sender: nil)
            
        }))
        confirmAlert.addAction(UIAlertAction(title: "Safariで開く", style: UIAlertActionStyle.default, handler: {action in
            let url = NSURL(string: (confirmAlert.textFields?[0].text)!)
            timeList.append(self.time())
            URLlist.append((confirmAlert.textFields?[0].text)!)
            HistoryData.set(URLlist, forKey: "urlHistory")
            HistoryData.set(timeList, forKey: "timeHistory")
            if UIApplication.shared.canOpenURL(url as! URL){
                UIApplication.shared.openURL(url as! URL)
            }

        }))
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {action in }))
        confirmAlert.addTextField(configurationHandler: {(textField:UITextField!) -> Void in
            textField.text = self.linkString
        })
        present(confirmAlert, animated: true, completion: nil)
        
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
        }
    }
    @IBAction func help(){
        let helpAlert = UIAlertController(title: "撮影時の注意点", message: "・影が入らないようにしてください\n・平らな場所で撮影してください\n・正面、真上から撮影してください", preferredStyle: UIAlertControllerStyle.alert)
        helpAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in}))
        present(helpAlert, animated: true, completion: nil)
    }
    
    func openPicker(){
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            // インスタンスの作成
            picker = UIImagePickerController()
            picker!.sourceType = sourceType
            picker!.delegate = self
            picker!.allowsEditing = false
            present(picker!, animated: true, completion: nil)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    
}
