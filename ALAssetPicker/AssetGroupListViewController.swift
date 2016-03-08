//
//  AssetGroupListViewController.swift
//  ALAssetPicker
//
//  Created by 沙畫 on 15/10/24.
//  Copyright © 2015年 xiaoquxia. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos

class AssetGroupListViewController: UITableViewController {

    private var albumsList = NSMutableArray()
    private var assetsLibrary:ALAssetsLibrary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !adjustAuthorization() {
            return
        }
        else{
            setUp()
            fetchALAssetsLibraryGroup()
        }
        
    }

    func setUp(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 47/255, green: 53/255, blue: 53/255, alpha: 0.7)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 0.7)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 0.7)]
        
        let backItem = UIBarButtonItem()
             backItem.title = "返回";
        self.navigationItem.backBarButtonItem = backItem;
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.toolbarHidden = true
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "assetsLibraryUpdated:", name: ALAssetsLibraryChangedNotification, object: nil)
    }

    
//    func assetsLibraryUpdated(notification : NSNotification )
//    {
//        //recheck here
//        print("notification - \(notification)")
//    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
//        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return albumsList.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let assetsGroup = self.albumsList[indexPath.row] as! ALAssetsGroup

        cell.textLabel?.text = assetsGroup.valueForProperty(ALAssetsGroupPropertyName) as? String
        cell.detailTextLabel?.text = "(\(assetsGroup.numberOfAssets()))"
        cell.imageView?.image = UIImage(CGImage: assetsGroup.posterImage().takeUnretainedValue())
        
        return cell
    }
    

    func adjustAuthorization() -> Bool{


        
        
        if #available(iOS 8.0, *) {
            
            let  authorizationStatus = PHPhotoLibrary.authorizationStatus()
            if (authorizationStatus == PHAuthorizationStatus.Restricted || authorizationStatus == PHAuthorizationStatus.Denied) {
                
                let mainInfoDictionary  = NSBundle.mainBundle().infoDictionary!
                let appName:String = mainInfoDictionary["CFBundleDisplayName"] as! String
                let tipTextWhenNoPhotosAuthorization = String(format: "请在设备的\"设置-隐私-照片\"选项中，允许【%@】访问你的手机相册", appName)

                let alertController = UIAlertController(title: "温馨提示", message: tipTextWhenNoPhotosAuthorization, preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: nil)
                     alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)

                return false
            }
            
        } else {

            // 获取当前应用对照片的访问授权状态
            let authorizationStatus:ALAuthorizationStatus = ALAssetsLibrary.authorizationStatus()
            // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
            if (authorizationStatus == ALAuthorizationStatus.Restricted || authorizationStatus == ALAuthorizationStatus.Denied) {
                let mainInfoDictionary  = NSBundle.mainBundle().infoDictionary!
                let appName:String = mainInfoDictionary["CFBundleDisplayName"] as! String
                let tipTextWhenNoPhotosAuthorization = String(format: "请在设备的\"设置-隐私-照片\"选项中，允许【%@】访问你的手机相册", appName)
                let alertView = UIAlertView(title: "温馨提示", message: tipTextWhenNoPhotosAuthorization, delegate: nil, cancelButtonTitle: "知道了")
                alertView.show()
                
                return false
            }
            
        }
        
        
        return true
    }
    
    
    //获取相册列表
    func fetchALAssetsLibraryGroup(){
        
         assetsLibrary = ALAssetsLibrary()
         albumsList = NSMutableArray()
        
        weak var weakSelf = self
        assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: { (group:ALAssetsGroup! ,stop) -> Void in
            if (group != nil) {
                group.setAssetsFilter(ALAssetsFilter.allPhotos())
                if group.numberOfAssets() > 0 {
                    // 把相册储存到数组中，方便后面展示相册时使用
                    let strongSelf = weakSelf
                    strongSelf!.albumsList.addObject(group)
                }
            }
            else{
                if self.albumsList.count > 0 {
                    let strongSelf = weakSelf
                    self.tableView.reloadData()
                    let  assetListVC = self.storyboard?.instantiateViewControllerWithIdentifier("AssetListViewController") as! AssetListViewController
                          assetListVC.assetsGroup = strongSelf!.albumsList[0] as! ALAssetsGroup
                    self.navigationController?.pushViewController(assetListVC, animated: false)
                    
                }
                else{
                    MBProgressHUD.showErrorToWindowWithText("没有相册")
                }
            }
            }) { (error) -> Void in
                NSLog("Asset group found! - error \(error)\n");
        }
        
    
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("showAssetListVC", sender:  albumsList[indexPath.row])
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    @IBAction func cancelButtonClick(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "showAssetListVC"{
                let alVC = segue.destinationViewController as? AssetListViewController
                alVC?.assetsGroup = sender as! ALAssetsGroup
            }
        }
    }


}
