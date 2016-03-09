//
//  AssetListViewController.swift
//  ALAssetPicker
//
//  Created by 沙畫 on 15/10/24.
//  Copyright © 2015年 xiaoquxia. All rights reserved.
//  图片列表
//         "日期：\(myAsset.valueForProperty(ALAssetPropertyDate))\n"
//      + "类型：\(myAsset.valueForProperty(ALAssetPropertyType))\n"
//      + "位置：\(myAsset.valueForProperty(ALAssetPropertyLocation))\n"
//      + "时长：\(myAsset.valueForProperty(ALAssetPropertyDuration))\n"
//      + "方向：\(myAsset.valueForProperty(ALAssetPropertyOrientation))"
import UIKit
import AssetsLibrary

let kMainScreenWidth = UIScreen.mainScreen().bounds.width
let kMainScreenHeight = UIScreen.mainScreen().bounds.height
let kColItemCount:CGFloat = 4
let kLineSpacingWH:CGFloat = 1
let textGreenColor = UIColor(red: 9/255, green: 187/255, blue: 7/255, alpha: 1.0)

class AssetListViewController: UICollectionViewController {

    var imagesAssetList:NSMutableArray!     //全部资源图片
    var perviewAssetList:NSMutableArray!    //预览资源图片
    var boxAssetList:NSMutableArray!           //浏览资源图片
    var selectedAssets:NSMutableArray!       //已选图片的集合
    var assetsGroup : ALAssetsGroup!          //资源组
    var bottomToolBar:UIView!                       //底部操作栏
    var sendCountButton:UIButton!                //发送数量Button
    var sendButton:UIButton!                         //发送字样Button
    var bottomSendButton:UIButton!             //底部发送按钮
    var perViewButton:UIButton!                    //预览按钮
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
        fetchAsset()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
        settingSendCountButton()
    }
    
    func backButtonClick(){
       
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setUp(){
        
        perviewAssetList = NSMutableArray()
        selectedAssets = NSMutableArray()
        
        self.title =  assetsGroup.valueForProperty(ALAssetsGroupPropertyName) as? String

        
        var tempframe = self.collectionView!.frame
        tempframe.size.height = tempframe.size.height - 44
        self.collectionView?.frame = tempframe

       let toolBar = UIView(frame: CGRectMake(0, kMainScreenHeight - 44, kMainScreenWidth, 44))
        toolBar.backgroundColor = UIColor.whiteColor()
        let lineView = UIView(frame: CGRectMake(0, 0, kMainScreenWidth,0.5))
        lineView.backgroundColor = UIColor.blackColor()
        lineView.alpha = 0.3
        toolBar.addSubview(lineView)
        //预览按钮
        let perViewButton = UIButton(type: .Custom)
             perViewButton.addTarget(self, action: "perViewButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
             perViewButton.titleLabel?.font = UIFont.systemFontOfSize(14)
             perViewButton.setTitle("预览", forState: UIControlState.Normal)
             perViewButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
             perViewButton.setTitle("预览", forState: UIControlState.Disabled)
             perViewButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Disabled)
             perViewButton.enabled = false
             perViewButton.frame = CGRectMake(10, (toolBar.frame.size.height - 30)/2, 32, 30)
        self.perViewButton = perViewButton
        toolBar.addSubview(perViewButton)

        
        let bottomSendButton = UIButton(type: .Custom)
        bottomSendButton.addTarget(self, action: "sendButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomSendButton.frame = CGRectMake(kMainScreenWidth - 65, (toolBar.frame.size.height - 30)/2, 55, 30)
        self.bottomSendButton = bottomSendButton
        toolBar.addSubview(bottomSendButton)
        
        let sendCountButton = UIButton(type: UIButtonType.Custom)
             sendCountButton.setBackgroundImage(UIImage(named: "FriendsSendsPicturesNumberIcon"), forState: UIControlState.Normal)
             sendCountButton.setTitle("\(selectedAssets.count)", forState: UIControlState.Normal)
             sendCountButton.titleLabel?.font = UIFont.systemFontOfSize(15)
             sendCountButton.adjustsImageWhenHighlighted = false
             sendCountButton.frame = CGRectMake(0, (bottomSendButton.bounds.size.height - 26 )/2, 25, 26)
             sendCountButton.userInteractionEnabled = false
             sendCountButton.alpha = 0.0
        self.sendCountButton = sendCountButton
        
        let sendButton = UIButton(type: UIButtonType.Custom)
             sendButton.setTitle("发送", forState: UIControlState.Normal)
             sendButton.titleLabel?.font = UIFont.systemFontOfSize(14)
             sendButton.setTitleColor(textGreenColor, forState: UIControlState.Normal)
             sendButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Disabled)
             sendButton.frame = CGRectMake(bottomSendButton.bounds.size.width - 30, 0, 30, 30)
             sendButton.userInteractionEnabled = false
             sendButton.enabled = false
        self.sendButton = sendButton
        
        bottomSendButton.addSubview(sendCountButton)
        bottomSendButton.addSubview(sendButton)
        let bottomSendBarButton = UIBarButtonItem(customView: bottomSendButton)
        bottomSendBarButton.enabled  = false

        bottomToolBar = toolBar
        self.view.addSubview(bottomToolBar)

    }
    
    func perViewButtonClick(){
        print("预览")
        perviewAssetList.removeAllObjects()
        for asset in selectedAssets {
            perviewAssetList.addObject(asset)
        }
         boxAssetList = perviewAssetList
        self.performSegueWithIdentifier("showAssetOriginalListVC", sender: 0)
    }
    
    func sendButtonClick(sender:UIButton){
       print("发送")
    }
    
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imagesAssetList.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = AssetViewCell.cellWithCollectionView(collectionView, cellForItemAtIndexPath: indexPath)

        if imagesAssetList.count > 0 && imagesAssetList.count > indexPath.row{
            if let asset = imagesAssetList[indexPath.row] as? Asset {
                cell.index = indexPath.row
                cell.checkOption = checkPictureByAsset
                cell.asset = asset
            }
        }
        return cell
    }

    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        //        return LineSpacingWH
        return kLineSpacingWH
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kLineSpacingWH
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kLineSpacingWH, left: kLineSpacingWH, bottom: kLineSpacingWH, right: kLineSpacingWH)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let WH:CGFloat = ((kMainScreenWidth - 2 * kLineSpacingWH) - (kColItemCount - 1) * kLineSpacingWH ) / kColItemCount
        return CGSizeMake(WH, WH);

    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        boxAssetList = imagesAssetList
        self.performSegueWithIdentifier("showAssetOriginalListVC", sender: indexPath.row)
    }

    
    func fetchAsset(){

           let hud =  MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.labelText = "获取图片"
            self.imagesAssetList = NSMutableArray()
            weak var weakSelf = self

            self.assetsGroup.enumerateAssetsWithOptions(NSEnumerationOptions.Concurrent) { (result, index, stop) -> Void in
                if result != nil {
                        let asset = Asset(item: result)
                        let strongSelf = weakSelf
                        strongSelf!.imagesAssetList.addObject(asset)
                }
                else{
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        let strongSelf = weakSelf
                        strongSelf!.collectionView?.reloadData()
                        let indexPath = NSIndexPath(forItem: strongSelf!.imagesAssetList.count - 1, inSection: 0)
                        strongSelf!.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: false)
                    }
            }
    }
    
    //MARK: - checkPictureByIndex
    func checkPictureByAsset(asset : Asset){

        if  self.selectedAssets.containsObject(asset) {
             self.selectedAssets.removeObject(asset)
        }
        else{
            self.selectedAssets.addObject(asset)
        }
        
        settingSendCountButton()
        
        print("选择图片数量 - > \(self.selectedAssets.count)")
        
    }
    
    //MARK: - 设置发送按钮数
    func  settingSendCountButton(){
        if self.selectedAssets.count > 0 {
            self.perViewButton.enabled = true
            self.sendButton.enabled = true
            self.bottomSendButton.enabled = true
            self.sendCountButton.setTitle("\(selectedAssets.count)", forState: UIControlState.Normal)
            self.sendCountButton.alpha = 1.0
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                
                self.sendCountButton.transform = CGAffineTransformScale(self.sendCountButton.transform, 0.2, 0.2);
                
                }) { (finished) -> Void in
                    UIView.animateWithDuration(0.1) { () -> Void in
                        self.sendCountButton.transform = CGAffineTransformScale(self.sendCountButton.transform, 5, 5);
                    }
            }
        }
        else{
            sendCountButton.setTitle("", forState: UIControlState.Normal)
            sendCountButton.alpha = 0
            self.perViewButton.enabled = false
            self.sendButton.enabled = false
            self.bottomSendButton.enabled = false
        }
    }
    
    
    
    //MARK: - 预览操作
//    func previewSelectedOperation(asset : Asset){
//        if  self.imagesAssetList.containsObject(asset) {
//            for (_,value)  in self.imagesAssetList.enumerate() {
//                let item = value as! Asset
//                if item == asset {
//                    item.isSelected = !item.isSelected
//                }
//            }
//        }
//        else{
//            print("没有找到资源")
//        }
//    }
    
    @IBAction func cancelButtonClick(sender: UIBarButtonItem) {
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    deinit{
        print("图片列表挂了....")
//        imagesAssetList = nil
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }
    

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if  identifier == "showAssetOriginalListVC" {
                let aolVC = segue.destinationViewController as! AssetOriginalListViewController
                aolVC.imagesAssetOriginalList = self.boxAssetList
                aolVC.indexBySelected = sender as! Int
                aolVC.selectedAssets = self.selectedAssets
//                aolVC.previewSelectedOperation = previewSelectedOperation
            }
        }
    }

}
