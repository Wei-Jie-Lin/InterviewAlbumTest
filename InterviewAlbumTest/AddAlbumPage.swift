//
//  AddAlbumPage2.swift
//  InterviewAlbumAPP
//
//  Created by 林暐潔 on 2017/1/19.
//  Copyright © 2017年 林暐潔. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker

class AddAlbumPage: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var addDate: UITextField!
    @IBOutlet weak var addTitle: UITextField!
    
    
    //完成的按鈕。
    @IBAction func finishButton(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    var myDatePicker: UIDatePicker! = UIDatePicker()
    
    @IBAction func getPhoto(_ sender: Any) {
        //建立AlertController
        let alertController = UIAlertController(title: "Take Picture!!", message: "請選擇方式輸入照片", preferredStyle: .actionSheet)
        //建立一個按鈕，『拍照』
        let takePicture = UIAlertAction(title: "拍照", style: .default) { (UIAlertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        //建立一個按鈕，『相簿』
        let album = UIAlertAction(title: "相簿", style: .default) { (UIAlertAction) in
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
        }
        //建立一個按鈕，『取消』
        let cancel = UIAlertAction(title: "取消", style: .default) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        //將按鈕加入AlertController
        alertController.addAction(takePicture)
        alertController.addAction(album)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion:nil)
    }
    
    //取得照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print("info \(info)")
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
    }

    // 按空白處會隱藏編輯狀態
    func hideKeyboard(_ tapG: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    //dataPicker值改變執行的方法
    func datePickerChanged(datePicker:UIDatePicker) {
        // 設置要顯示在鍵盤 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        // 更新 UITextField 的內容
        addDate.text = formatter.string(from: datePicker.date)
    }

    //初始值
    func initial() {

        //TextField的Placeholder變更顏色 , 調整TextField 高度
        var titleFrameRect = addTitle.frame
        titleFrameRect.size.height = 38
        addTitle.frame = titleFrameRect
        addTitle.attributedPlaceholder = NSAttributedString(string:"請輸入標題",attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName:UIFont.boldSystemFont(ofSize: 17)])
        
        var dateFrameRect = addDate.frame
        dateFrameRect.size.height = 38
        addDate.frame = dateFrameRect
        addDate.attributedPlaceholder = NSAttributedString(string:"請選擇日期",attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName:UIFont.boldSystemFont(ofSize: 17)])

        //設定DatePicker初始值
        //設定目前時間
        let now = NSDate()
        //改變鍵盤輸入模式
        addDate.inputView = myDatePicker
        // 設置 UIDatePicker 格式
        myDatePicker.datePickerMode = .dateAndTime
        // 選取時間時的分鐘間隔 這邊以 15 分鐘為一個間隔
        myDatePicker.minuteInterval = 15
        // 設置預設時間為現在時間
        myDatePicker.date = Date()
        // 設置 Date 的格式
        let formatter = DateFormatter()
        // 設置時間顯示的格式
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        //預設現在時間顯示在TextField上
        addDate.text = formatter.string(from: now as Date)
        // 可以選擇的最早日期時間
        let fromDateTime = formatter.date(from: "2016/01/02 18:08")
        // 設置可以選擇的最早日期時間
        myDatePicker.minimumDate = fromDateTime
        // 可以選擇的最晚日期時間
        let endDateTime = formatter.date(from: "2017/12/25 10:45")
        // 設置可以選擇的最晚日期時間
        myDatePicker.maximumDate = endDateTime
        // 設置顯示的語言環境
        myDatePicker.locale = Locale(identifier: "zh_TW")
        // 設置改變日期時間時會執行動作的方法
        myDatePicker.addTarget(self, action: #selector(AddAlbumPage.datePickerChanged), for: .valueChanged)
        
        
        // 增加一個觸控事件，收鍵盤。
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddAlbumPage.hideKeyboard(_:)))
        // 加在最基底的 self.view 上
        self.view.addGestureRecognizer(tap)
    }

    
    
    // MARK: ---Collection---
    // 必須實作的方法：每一組有幾個 cell
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionViewLayout: UICollectionViewFlowLayout!
    
    var imageArray = [String]()
    let layout = UICollectionViewFlowLayout()

    func collectionInitial() {
        
        // 設置 section 的間距 四個數值分別代表 上、左、下、右 的間距
        imageCollectionViewLayout.sectionInset = UIEdgeInsetsMake(2, 1, 2, 1);
        
        // 設置每一行的間距
        imageCollectionViewLayout.minimumLineSpacing = 8
        
        // 設置每個 cell 的尺寸
        imageCollectionViewLayout.itemSize = CGSize(width: CGFloat(imageCollectionView.bounds.size.width)/4  , height: CGFloat(imageCollectionView.bounds.size.width)/4  )
        
        //CollectionView
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        self.imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

    }
    
    
    // 有幾個 section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 依據前面註冊設置的識別名稱 "Cell" 取得目前使用的 cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "aa") as! ViewController
//        controller.selectImageArray = imageArray
        
        for image in imageArray {
//            cell.imageView.image = image
        }
        
        
        
        
        // 設置 cell 內容 (即自定義元件裡 增加的圖片與文字元件)
//        cell.imageView.image = UIImage(named: "0\(indexPath.item + 1).jpg")
//        cell.titleLabel.text = "0\(indexPath.item + 1)"
        
        return cell
    }
    
    
    
    // 點選 cell 後執行的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("你選擇了第 \(indexPath.section + 1) 組的")
//        print("第 \(indexPath.item + 1) 張圖片")
    }

    
    
    //讀取紀錄位址的photoArray
    func loadFile(){
        let fileManager = FileManager.default
        let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent("photoArray.txt")
        
        if let array = NSArray(contentsOf: url!){
            imageArray = array as! [String]
        }

        print("AddArray:\(imageArray)")
        
        imageCollectionView.reloadData()
    }

//    //接收通知
//    func roleIntroduction(noti:Notification) {
//        
//        imageArray = noti.userInfo!["PASS"] as! [UIImage]
//        
//    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //接收通知
//        let notificationName = Notification.Name("Finish")
//        NotificationCenter.default.addObserver(self, selector: #selector(roleIntroduction(noti:)), name: notificationName, object: nil)
        
         loadFile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initial()
        
        collectionInitial()
        
       
        

        //MainPage點選＋相簿選好的照片給本頁的imageView
//        addImage.image = albumPhoto
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
