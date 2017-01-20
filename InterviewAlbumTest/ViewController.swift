//
//  ViewController.swift
//  InterviewAlbumTest
//
//  Created by 林暐潔 on 2017/1/19.
//  Copyright © 2017年 林暐潔. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker

class ViewController: UIViewController {
    
    var selectImageArray = [String]()
    
    @IBAction func goAlbum(_ sender: Any) {
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 6
        vc.takePhotoIcon = UIImage(named: "chat")
        
        vc.albumButton.tintColor = UIColor.white
        vc.cancelButton.tintColor = UIColor.white
        vc.doneButton.tintColor = UIColor.white
        
        vc.navigationBar.barTintColor = UIColor.black
        
        vc.selectionCharacter = "✓"
        vc.selectionFillColor = UIColor.clear
        vc.selectionStrokeColor = UIColor.green
        vc.selectionShadowColor = UIColor.red
        vc.selectionTextAttributes[NSForegroundColorAttributeName] = UIColor.green
        vc.cellsPerRow = {(verticalSize: UIUserInterfaceSizeClass, horizontalSize: UIUserInterfaceSizeClass) -> Int in
            switch (verticalSize, horizontalSize) {
            case (.compact, .regular): // iPhone5-6 portrait
                return 4
            case (.compact, .compact): // iPhone5-6 landscape
                return 4
            case (.regular, .regular): // iPad portrait/landscape
                return 4
            default:
                return 4
            }
        }
        
        bs_presentImagePickerController(vc, animated: true, select: { (asset: PHAsset) -> Void in
            
            
            print("Selected: \(asset)")
        }, deselect: { (asset: PHAsset) -> Void in
            
            
            print("Deselected: \(asset)")
        }, cancel: { (assets: [PHAsset]) -> Void in
            
            
            print("Cancel: \(assets)")
        }, finish: { (assets: [PHAsset]) -> Void in
            

            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            
            for asset in assets {
                manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                    
                    thumbnail = result!

                    
//                    //設定目前時間
//                    let now = NSDate()
//                    // 設置 Date 的格式
//                    let formatter = DateFormatter()
//                    // 設置時間顯示的格式
//                    formatter.dateFormat = "yyyy_MM_dd-HH_mm_ss"
//                    //預設現在時間顯示在TextField上
//                    let name = "\(formatter.string(from: now as Date)).jpg"
                    //儲存圖片。
                    let fileManager = FileManager.default
                    let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                    let docUrl = docUrls.first
                    let interval = Date.timeIntervalSinceReferenceDate
                    let name = "\(interval).jpg"
                    let url = docUrl?.appendingPathComponent(name)
                    let data = UIImageJPEGRepresentation(thumbnail, 0.9)
                    try! data?.write(to: url!, options: .atomic)
                    self.selectImageArray.append(name)
                })
            }
            
            self.saveFile()
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddAlbumPage") as! AddAlbumPage
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(controller, animated: true)

//            print("Finish: \(assets)")

        }, completion: nil)
    }

    //儲存紀錄位址的photoArray
    func saveFile(){

        let fileManager = FileManager.default
        
        let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent("photoArray.txt")
        let array = selectImageArray
        (array as NSArray).write(to: url!, atomically: true)
        
        print("Array:\(array)")
        print(url!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

