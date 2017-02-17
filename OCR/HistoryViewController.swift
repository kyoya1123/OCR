//
//  HistoryViewController.swift
//  OCR
//
//  Created by Family Account on 2016/09/20.
//  Copyright © 2016年 Family Account. All rights reserved.
//

import UIKit

let HistoryData: UserDefaults = UserDefaults.standard
var URLlist: [String] = []
var timeList: [String] = []

class HistoryViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var table: UITableView!
    @IBOutlet var deleteBtn: UIBarButtonItem!
    
    var reversedURLlist: [String] = []
    var reversedTimelist: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reversedURLlist = URLlist.reversed()
        reversedTimelist = timeList.reversed()
        
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
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if let indexPath = table.indexPathForSelectedRow {
            table.deselectRow(at: indexPath, animated: true)
        }
    }
    func background(){
        let label = UILabel()
        label.frame = CGRect(x: 83, y: 265, width: 155, height: 39)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "System", size: 20)
        label.text = NSLocalizedString("noHistory", comment: "")
        label.textColor = UIColor.lightGray
        table.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.5)
        table.backgroundView = label
        
        deleteBtn.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let confirmAlert = UIAlertController(title: NSLocalizedString("open?", comment: ""), message: "", preferredStyle: UIAlertControllerStyle.alert)
        confirmAlert.addAction(UIAlertAction(title: NSLocalizedString("inApplication", comment: ""), style: UIAlertActionStyle.default, handler: {action in
            
            url2 = NSURL(string: self.reversedURLlist[indexPath.row])
            self.performSegue(withIdentifier: "web2", sender: nil)
        }))
        confirmAlert.addAction(UIAlertAction(title: NSLocalizedString("inSafari", comment: ""), style: UIAlertActionStyle.default, handler: {action in
            let url = NSURL(string: URLlist[indexPath.row])
            if UIApplication.shared.canOpenURL(url as! URL){
                UIApplication.shared.openURL(url as! URL)
            }
            
        }))
        confirmAlert.addAction(UIAlertAction(title: NSLocalizedString("AlertShare", comment: ""),style: UIAlertActionStyle.default, handler: {action in
            self.share(linkString: self.reversedURLlist[indexPath.row])
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
        
        cell.timeLabel.text = reversedTimelist[indexPath.row]
        cell.URLLabel.text = reversedURLlist[indexPath.row]

        return cell
    }
    
    @IBAction func delete(){
        let alert = UIAlertController(title: NSLocalizedString("delete", comment: ""), message: NSLocalizedString("sure?", comment: ""), preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {action in
            timeList.removeAll()
            URLlist.removeAll()
            self.reversedTimelist.removeAll()
            self.reversedURLlist.removeAll()
            HistoryData.removeObject(forKey: "urlHistory")
            HistoryData.removeObject(forKey: "timeHistory")
            HistoryData.synchronize()
            self.table.reloadData()
            self.background()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {action in}))
        present(alert, animated: true, completion: nil)
    }
    
    func share(linkString: String){
        let adText = NSLocalizedString("share",comment: "")
        let shareWebsite = linkString + "\n"
        
        let activityItems = [shareWebsite,adText] as [Any]
        
        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.airDrop,
            UIActivityType.copyToPasteboard
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        
        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)

    }
    
}
