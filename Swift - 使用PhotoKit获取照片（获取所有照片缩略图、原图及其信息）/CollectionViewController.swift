//
//  CollectionViewController.swift
//  hangge_1233
//
//  Created by hangge on 16/6/15.
//  Copyright © 2016年 hangge. All rights reserved.
//

import UIKit
import Photos

class CollectionViewController: UICollectionViewController {
    
    ///取得的资源结果，用了存放的PHAsset
    var assetsFetchResults:PHFetchResult!
    
    ///缩略图大小
    var assetGridThumbnailSize:CGSize!
    
    /// 带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //根据单元格的尺寸计算我们需要的缩略图大小
        let scale = UIScreen.mainScreen().scale
        let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        assetGridThumbnailSize = CGSizeMake( cellSize.width*scale , cellSize.height*scale)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //则获取所有资源
        let allPhotosOptions = PHFetchOptions()
        //按照创建时间倒序排列
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
            ascending: false)]
        //只获取图片
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                 PHAssetMediaType.Image.rawValue)
        assetsFetchResults = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image,
                                                              options: allPhotosOptions)
        
        // 初始化和重置缓存
        self.imageManager = PHCachingImageManager()
        self.resetCachedAssets()
    }
    
    //重置缓存
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }
    
    
    // CollectionView行数
    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults.count
    }
    
    // 获取单元格
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath)
        -> UICollectionViewCell {
            // storyboard里设计的单元格
            let identify:String = "DesignViewCell"
            // 获取设计的单元格，不需要再动态添加界面元素
            let cell = (self.collectionView?.dequeueReusableCellWithReuseIdentifier(
                identify, forIndexPath: indexPath))! as UICollectionViewCell
            
            let asset = self.assetsFetchResults[indexPath.row] as! PHAsset
            
            //获取缩略图
            self.imageManager.requestImageForAsset(asset, targetSize: assetGridThumbnailSize,
                                                   contentMode: PHImageContentMode.AspectFill,
                                                   options: nil) { (image, nfo) in
                                                    (cell.contentView.viewWithTag(1) as! UIImageView).image = image
                                                    print(image)
            }
            return cell
    }
    
    // 单元格点击响应
    override func collectionView(collectionView: UICollectionView,
                                 didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let myAsset = self.assetsFetchResults[indexPath.row] as! PHAsset
        
        //这里不使用segue跳转（建议用segue跳转）
        let detailViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewControllerWithIdentifier("detail")
            as! ImageDetailViewController
        detailViewController.myAsset = myAsset
        
        // navigationController跳转到detailViewController
        self.navigationController!.pushViewController(detailViewController,
                                                      animated:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
