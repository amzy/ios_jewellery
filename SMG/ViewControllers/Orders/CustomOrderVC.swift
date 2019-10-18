//
//  CustomOrderVC.swift
//  SMG
//
//  Created by Amzad Khan on 20/09/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit

class CustomOrderVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var orderDescription: CustomTextView!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var photos = [Media]()
    
    var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - ((insets.left) + (insets.right))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CUSTOM ORDER"
        self.configureTopBar(left: [.leftMenu], right: [.cart])
        orderDescription.placeholder = ""
        self.configureCollectionView()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateCart), name: .kDidUpdateCart, object: nil)
    }
    @objc func didUpdateCart() {
        guard let user  = Constants.kAppDelegate.user else {return}
        let cartCount  = Int(any:user.cartCount ?? "0")
        if cartCount > 0 {
            self.cartBtn.setBadge(text: user.cartCount)
        }else {
            self.cartBtn.setBadge(text: "")
        }
    }
    @IBAction func didTapAddToCart(_ sender: Any) {
        if self.photos.count < 1 {
            Global.showAlert(message: "Please add a photo.")
        }else if let text = orderDescription.text, text.trim().length < 1 {
            Global.showAlert(message: "Please write something about item.")
        }else {
            self.apiUploadCustomOrder(message: orderDescription.text.trim(), files: self.photos)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnAddToCart.applyLinearGradient(colors: [ #colorLiteral(red: 0.9144535661, green: 0.2558653057, blue: 0.09014534205, alpha: 1), #colorLiteral(red: 0.8880044818, green: 0.7457256913, blue: 0.401170522, alpha: 1)])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK:- UICollectionViewDelegateFlowLayout
extension CustomOrderVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentWidth/4 , height: collectionView.frame.size.height)
    }
}
// MARK:- UICollectionViewDelegate
extension CustomOrderVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.photos.count {
            #if DEBUG
                self.openImageGalley(sender: self)
            #else
                UIViewController.openImagePicker(sender: self)
                //self.openCamera(sender: self)
            #endif
        }else {
            self.openCamera(sender: self)
        }
    }
}

extension CustomOrderVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("PickerInfo:\((info as NSDictionary))")
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            
            if mediaType == "public.image" {
                print("Image Selected")
                if let selectedImage = UIImage.from(info: info)?.fixOrientation() {
                    // I am happy :)
                    //let image  = Media(selectedImage)
                    self.photos.append(Media(selectedImage))
                    self.collectionView.reloadData()
                    dismiss(animated: false) {}
                    
                } else {
                    // I am sad :(
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- UICollectionViewDataSource
extension CustomOrderVC: UICollectionViewDataSource {
    
    func configureCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        let bannerCellNib = UINib(nibName: Identifiers.kBannerCell, bundle: Bundle.main)
        collectionView.register(bannerCellNib, forCellWithReuseIdentifier: Identifiers.kBannerCell)
        flowLayout.scrollDirection      = .horizontal
        flowLayout.minimumLineSpacing   = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset         = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView.contentInset     = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView.contentOffset    = CGPoint.zero
        flowLayout.sectionHeadersPinToVisibleBounds = false
        //flowLayout.itemSize = CGSize(width: Constants.kScreenWidth , height: 184)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photos.count == 5 {
            return 5
        } else {
            return photos.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.kBannerCell, for: indexPath) as? BannerCell else {
            return UICollectionViewCell()
        }
        cell.gradientImage?.isHidden = true
        if indexPath.row == self.photos.count {
            cell.image.image            = #imageLiteral(resourceName: "ic_add").imageWithTintColor(UIColor.lightGray)
            cell.image.contentMode      = .scaleAspectFit
            cell.image.backgroundColor  = UIColor(hex:"EEEEEE")
        }else {
            guard let image = photos[indexPath.row].uploadData as? UIImage else {
                cell.image.image = nil
                return cell
            }
            cell.image.contentMode      = .scaleToFill
            cell.image.image = image
        }
        //cell.image.image =  #imageLiteral(resourceName: "account_banner")
        
        return cell
    }
}

extension CustomOrderVC {
    func apiUploadCustomOrder(message:String, files:[Media]) {
        let images  = files.map { (media) -> UIImage in
            return media.uploadData as! UIImage
        }
        let params = ["message":message]
        Global.showLoadingSpinner(sender: self.view)
        
        API.createCustomOrder.requestUpload(with: params, files: ["images":images], success: { (json) in
            Global.dismissLoadingSpinner(self.view)
            if let data = json?["msg"] as? String {
                Global.showAlert(message: data, handler: { (okay) in
                    self.orderDescription.text = ""
                    self.photos.removeAll()
                    self.collectionView.reloadData()
                })
            }else {
                self.orderDescription.text = ""
                self.photos.removeAll()
                self.collectionView.reloadData()
            }
            
        }) { (error, json) in
            Global.dismissLoadingSpinner(self.view)
            if let errorObj = error {
               Global.showAlert(message: errorObj.localizedDescription )
            }
        }
    }
}
