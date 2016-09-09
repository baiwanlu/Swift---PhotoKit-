import UIKit
import Photos

class ImageDetailViewController: UIViewController {
    //选中的图片资源
    var myAsset:PHAsset!
    //用于显示图片信息
    @IBOutlet weak var textView: UITextView!
    //用于显示原图
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取文件名
        PHImageManager.defaultManager().requestImageDataForAsset(myAsset, options: nil,
                                                                 resultHandler: {
                                                                    _, _, _, info in
                                                                    self.title = (info!["PHImageFileURLKey"] as! NSURL).lastPathComponent
        })
        
        //获取图片信息
        textView.text = "日期：\(myAsset.creationDate!)\n"
            + "类型：\(myAsset.mediaType.rawValue)\n"
            + "位置：\(myAsset.location)\n"
            + "时长：\(myAsset.duration)\n"
        
        //获取原图
        PHImageManager.defaultManager().requestImageForAsset(myAsset,
                                                             targetSize: PHImageManagerMaximumSize , contentMode: .Default,
                                                             options: nil, resultHandler: {
                                                                (image, _: [NSObject : AnyObject]?) in
                                                                self.imageView.image = image
                                                                print(image)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}