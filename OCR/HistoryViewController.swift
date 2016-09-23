//
//  HistoryViewController.swift
//  OCR
//
//  Created by Family Account on 2016/09/20.
//  Copyright © 2016年 Family Account. All rights reserved.
//

import UIKit
import GoogleMobileAds

let HistoryData: UserDefaults = UserDefaults.standard
var URLlist: [String] = []
var timeList: [String] = []

class HistoryViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,GADBannerViewDelegate {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var deleteBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var bannerView: GADBannerView = GADBannerView()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - bannerView.frame.height)
        bannerView.frame.size = CGSize(width: self.view.frame.width, height: bannerView.frame.height)
        
        bannerView.adUnitID = "ca-app-pub-4998156736658881/4112211858"
        bannerView.delegate = self
        bannerView.rootViewController = self
        let gadRequest: GADRequest = GADRequest()
        #if DEBUG
            gadRequest.testDevices = ["595ac722101c364a0f80a658bcfb8b1b"]//テスト時のみ
        #endif
        bannerView.load(gadRequest)
        self.view.addSubview(bannerView)
        
        
        if URLlist.count == 0{
            self.background()
        }
        
        table.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier:
            "Cell")
        table.delegate = self
        table.dataSource = self
        
        self.table.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = table.indexPathForSelectedRow {
            table.deselectRow(at: indexPath, animated: true)
        }
    }
    func background(){
        let label = UILabel()
        label.frame = CGRect(x: 83, y: 265, width: 155, height: 39)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "System", size: 20)
        label.text = "There are no history"
        label.textColor = UIColor.lightGray
        table.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.5)
        table.backgroundView = label
        
        deleteBtn.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let confirmAlert = UIAlertController(title: "このURLを開きますか？", message: "", preferredStyle: UIAlertControllerStyle.alert)
        confirmAlert.addAction(UIAlertAction(title: "アプリ内で開く", style: UIAlertActionStyle.default, handler: {action in
            
            url2 = NSURL(string: URLlist[indexPath.row])
            self.performSegue(withIdentifier: "web2", sender: nil)
            accessCount += 1
            HistoryData.set(accessCount, forKey: "access")
        }))
        confirmAlert.addAction(UIAlertAction(title: "Safariで開く", style: UIAlertActionStyle.default, handler: {action in
            accessCount += 1
            HistoryData.set(accessCount, forKey: "access")
            let url = NSURL(string: URLlist[indexPath.row])
            if UIApplication.shared.canOpenURL(url as! URL){
                UIApplication.shared.openURL(url as! URL)
            }
            
        }))
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{action in }))
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        present(confirmAlert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return URLlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        var reversedURLlist: Array = URLlist.reversed()
        var reversedTimelist:Array = timeList.reversed()
        cell.timeLabel.text = reversedTimelist[indexPath.row]
        cell.URLLabel.text = reversedURLlist[indexPath.row]

        return cell
    }
    
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func delete(){
        let alert = UIAlertController(title: "履歴を削除します", message: "本当によろしいですか？", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {action in
            timeList.removeAll()
            URLlist.removeAll()
            HistoryData.removeObject(forKey: "urlHistory")
            HistoryData.removeObject(forKey: "timeHistory")
            HistoryData.synchronize()
            self.table.reloadData()
            self.background()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {action in}))
        present(alert, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
