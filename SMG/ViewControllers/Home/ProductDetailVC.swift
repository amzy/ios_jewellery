//
//  ProductDetailVC.swift
//  SMG
//
//  Created by Amzad Khan on 06/09/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit


import GMStepper

struct CartData {
    
    var productID:Int?
    var quantity:String?
    var purity:String?
    var weight:String?
    var size:String?
    var sizeKey:String?
    var userID:String?
    var remark:String?
    var sku:String?
    
    var data:[String:Any] {
        return ["user_id" : userID ?? "", "product_id" : "\(productID ??  0)", "qty" : quantity ?? "", "purity" : purity ?? "", "weight" : weight ?? "", "size" : "\(sizeKey ?? "")", "sku" : sku ?? "", "remark" : remark ?? ""]
    }
}

enum ProductType: String {
    case new     = "new"
    case update  = "update"
}
class ProductDetailVC: UIViewController {
    
    var type:ProductType = ProductType.new
    var productID:Int = 0
    var cartData = CartData()
    var cartItem:CartItem!
    
    @IBOutlet weak var lblBangles: UILabel!
    @IBOutlet weak var lblNetWeight: UILabel!
    @IBOutlet weak var lblGrossWeight: UILabel!
    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var bannerView: BannerView!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var txtCarrot: CustomTextField!
    @IBOutlet weak var txtSize: CustomTextField!
    @IBOutlet weak var btnUpdateCart: UIButton!
    @IBOutlet weak var btnAddToWhishlist: UIButton!
    @IBOutlet weak var textRemark: CustomTextView!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cardViewHeight: NSLayoutConstraint!
    fileprivate var state = APIState<ProductDetail>.loading {
        didSet {
           self.updateData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.bannerView.delegate = self
        //bannerView.banners = [[:], [:], [:]]
        self.cartData.productID = self.productID
        self.cartData.userID    = Constants.kAppDelegate.user?.id ?? ""
        self.cartData.quantity  = "1"
        
        self.apiProductDetail(productID: self.productID)
        // Do any additional setup after loading the view.
        textRemark?.placeholder = "Remark"
        NotificationCenter.default.addObserver(self, selector: #selector(adjustTextViewHeight), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        if self.type == .new {
            self.btnUpdateCart.isHidden = true
            self.btnUpdateCart.isUserInteractionEnabled = false
        
        }else if self.type == .update {
            self.bottomBar.isHidden = true
            self.bottomBar.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func didTapAddToCart(_ sender: Any) {
        if (User.isUserLogin() != nil) {
            self.apiAddToCart(data: self.cartData)
        }else {
             redirectToAuth()
        }
        
    }
    @IBAction func didTapUpdateCart(_ sender: Any) {
        if (User.isUserLogin() != nil) {
            self.apiUpdateCartItem(data: self.cartData)
        }else {
            redirectToAuth()
        }
    }
    
    @IBAction func didTapWhishlist(_ sender: Any) {
        if let text = textRemark?.text.trim() {
            self.cartData.remark = text
        }
        if (User.isUserLogin() != nil) {
           self.apiAddToWhishList(data: self.cartData)
        }else {
            redirectToAuth()
        }
    }
    @IBAction func didChangeQuantity(_ sender: Any) {
        if let stepper = sender as? GMStepper {
            cartData.quantity = "\(Int(stepper.value))"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnUpdateCart?.applyLinearGradient(colors: [ #colorLiteral(red: 0.9144535661, green: 0.2558653057, blue: 0.09014534205, alpha: 1), #colorLiteral(red: 0.8880044818, green: 0.7457256913, blue: 0.401170522, alpha: 1)])
        self.btnAddToCart?.applyLinearGradient(colors: [ #colorLiteral(red: 0.9144535661, green: 0.2558653057, blue: 0.09014534205, alpha: 1), #colorLiteral(red: 0.8880044818, green: 0.7457256913, blue: 0.401170522, alpha: 1)])
        self.btnAddToWhishlist?.applyLinearGradient(colors: [ #colorLiteral(red: 0.9144535661, green: 0.2558653057, blue: 0.09014534205, alpha: 1), #colorLiteral(red: 0.8880044818, green: 0.7457256913, blue: 0.401170522, alpha: 1)])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func adjustTextViewHeight() {
        guard let textRemark = self.textRemark else {return}
        cartData.remark = textRemark.text
        let fixedWidth = textRemark.frame.size.width
        let newSize = textRemark.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let difference = newSize.height - 23 //new line
        //self.textHeightConstraint?.constant = newSize.height
        self.cardViewHeight?.constant    = 316 + difference //new line
        self.contentViewHeight?.constant = 627 + difference
        self.view.layoutIfNeeded()
    }
    
    func redirectToAuth() {
        
        let alert = UIAlertController(title: Constants.kAppDisplayName, message: "Please Login/Register to place an order", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (action) in
            let vc = AppStoryboard.authentication.initialViewController() as! UINavigationController
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true) {
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - setup View
extension ProductDetailVC {
    
    func setupView(){
        /*self.tblView.estimatedRowHeight = 200 , self.tblView.rowHeight = UITableViewAutomaticDimension*/
        // headerContentView.banners = [[:],[:],[:]]
        self.configureTopBar(left: [.back], right: [.cart, .call])
        self.title = "Detail"
        txtCarrot.textInputType = .picker
        txtSize.textInputType   = .picker
        
        
        if let picker = self.txtCarrot.picker {
            picker.dataSource = self
            picker.delegate = self
        }
        if let picker = self.txtSize.picker {
            picker.dataSource = self
            picker.delegate = self
        }
        self.stepper.buttonsFont    = UIFont(name: "AvenirNext-Bold", size: 26.0)!
        self.stepper.labelFont      = UIFont(name: "AvenirNext-Bold", size: 16.0)!
        
        txtCarrot.updateAppearance()
        txtSize.updateAppearance()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateCart), name: .kDidUpdateCart, object: nil)
        self.didUpdateCart()
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
    func updateData() {
        
        if self.type == .new {
            guard let product = self.state.data else {return}
            if let images = product.galleryImageURL {
                self.bannerView.banners = images
            }else if let image = product.featuredImgURL {
                self.bannerView.banners = [image]
            }
            
            if let picker = self.txtCarrot.picker {
                picker.reloadAllComponents()
            }
            if let picker = self.txtSize.picker {
                picker.reloadAllComponents()
            }
            self.lblDeliveryTime.text   = "\(product.deliveryTime ?? "")"
            self.lblCode?.text          = "\(product.sku ?? "")"
            self.lblBrand?.text         = "\(product.brandName ?? "")"
            self.cartData.sku = product.sku
        
            if let sizes = product.size, sizes.count > 0 {
                
                let filteredSize = sizes.filter { (obj) -> Bool in
                    return obj.termID == 23
                }
                if filteredSize.count > 0 {
                    self.txtSize.text = filteredSize.first!.name
                    self.cartData.size = filteredSize.first!.name
                    self.cartData.sizeKey = "\(String(describing: filteredSize.first!.termID))"
                }else {
                    self.txtSize.text = sizes.first!.name
                    self.cartData.size = sizes.first!.name
                    self.cartData.sizeKey = "\(String(describing: sizes.first!.termID))"
                }
                
            }
            
            if let priority = product.priority, priority.count > 0 {
                
                let filteredPriority = priority.filter { (obj) -> Bool in
                    return obj.termID == 49
                }
                if filteredPriority.count > 0 {
                    self.txtCarrot.text =  filteredPriority.first!.name
                    self.cartData.purity = txtCarrot.text
                }else {
                    self.txtCarrot.text =  priority.first!.name
                    self.cartData.purity = txtCarrot.text
                }
            
            }
            
            if let carrots = product.brandCarrot {
                let filteredCatrot = carrots.filter { (obj) -> Bool in
                    return obj.grossWeight != nil
                }
                if filteredCatrot.count > 0 {
                    self.lblGrossWeight?.text = carrots.last!.grossWeight
                    self.lblNetWeight?.text = carrots.last!.val
                    self.cartData.weight = lblNetWeight.text
                    self.lblBangles?.text = carrots.last!.bangles ?? "2"
                }
            }
            
        }else if self.type == .update {
            
            guard let cartItem = self.cartItem else {return}
            stepper.value = Double(any:cartItem.qty)
            
            self.cartData.sku           = cartItem.sku
            self.lblCode?.text          = "\(cartItem.sku ?? "")"
            self.lblBrand?.text         = "\(cartItem.title ?? "")"
            self.lblDeliveryTime.text   = "\(cartItem.deliveryTime ?? "")"
            
            self.textRemark.text    = cartItem.remark ?? ""

            self.lblNetWeight.text  = cartItem.weight ?? ""
            self.cartData.purity    = txtCarrot.text
            self.cartData.weight    = lblNetWeight.text

            self.txtSize.text = cartItem.size ?? ""
            self.cartData.size = txtSize.text
            
    
            guard let product = self.state.data else {return}
            if let sizes = product.size {
                for size in sizes {
                    if size.name == cartItem.size {
                        self.cartData.sizeKey = "\(size.termID)"
                    }
                }
            }
            let firstTwo = (cartItem.purity ?? "22").prefix(2)
            
            if let priority = product.priority, priority.count > 0 {
                
                let filteredPriority = priority.filter { (obj) -> Bool in
                    return (obj.name ?? "").hasPrefix(firstTwo)
                }
                if filteredPriority.count > 0 {
                    self.txtCarrot.text =  filteredPriority.first!.name
                    self.cartData.purity = txtCarrot.text
                }else {
                    self.txtCarrot.text =  priority.first!.name
                    self.cartData.purity = txtCarrot.text
                }
                
            }
            
            self.lblBrand?.text         = "\(product.brandName ?? "")"
            if let images = product.galleryImageURL {
                self.bannerView.banners = images
            }else if let image = product.featuredImgURL {
                self.bannerView.banners = [image]
            }
            
            if let carrots = product.brandCarrot {
                let filteredCatrot = carrots.filter { (obj) -> Bool in
                    return obj.grossWeight != nil
                }
                if filteredCatrot.count > 0 {
                    self.lblGrossWeight?.text = carrots.last!.grossWeight
                    self.lblBangles?.text = carrots.last!.bangles ?? "2"
                }
            }
            
            if let picker = self.txtCarrot.picker {
                picker.reloadAllComponents()
            }
            if let picker = self.txtSize.picker {
                picker.reloadAllComponents()
            }
        }
    }
}

extension ProductDetailVC : BannerDelegate {
    func didTapItem(indexPath:IndexPath) {
        
        guard User.isUserLogin() != nil else {return}
        guard let cell = self.bannerView.collectionView.cellForItem(at: indexPath) as? BannerCell else {return}
        guard let product = self.state.data else {return}
        var imageURLs = [String]()
        if let images = product.galleryImageURL {
            imageURLs = images
        }else if let image = product.featuredImgURL {
            imageURLs = [image]
        }
        if imageURLs.count > 0 {
            //Load Prview
            var photos = [Photo]()
            for url in imageURLs {
                if let imageURL = URL(string: url) {
                    let phot0 = Photo(imageURL)
                    photos.append(phot0)
                }
            }
            self.presentGallery(imageView: cell.image, indexPath: indexPath, media: photos)
        }
    }
}

// MARK : - Edit Profile APIs
extension ProductDetailVC {
    
    func apiAddToCart(data:CartData) {
        if let request = API.addToCart.request(method: .post, with: data.data) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.addToCart.validatedResponse(response, success: { [weak self] (jsonObject) in
                    guard let strongSelf = self else { return }
                    if let data = jsonObject?["msg"] as? String {
                      Global.showAlert(message:data )
                    }
                    Constants.kAppDelegate.apiLoadUserData()
                    strongSelf.navigationController?.popViewController(animated: true)
                    }, failed: { [weak self] (error, json) in
                        guard let strongSelf = self else { return }
                        if let errorObj = error {
                            strongSelf.state = .error(errorObj)
                        }
                })
            }
        }
        
    }
    func apiUpdateCartItem(data:CartData) {
        var itemData = data.data
        itemData["cart_id"] = self.cartItem.cartID ?? ""
        if let request = API.updateCartProduct.request(method: .get, with: itemData) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.updateCartProduct.validatedResponse(response, success: { [weak self] (jsonObject) in
                    guard let strongSelf = self else { return }
                    if let data = jsonObject?["msg"] as? String {
                        Global.showAlert(message:data )
                    }
                    Constants.kAppDelegate.apiLoadUserData()
                    strongSelf.navigationController?.popViewController(animated: true)
                    }, failed: { [weak self] (error, json) in
                        guard let strongSelf = self else { return }
                        if let errorObj = error {
                            strongSelf.state = .error(errorObj)
                        }
                })
            }
        }
        
    }
    func apiAddToWhishList(data:CartData) {
        
        if let request = API.addToWhishList.request(method: .get, with: self.cartData.data) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.addToWhishList.validatedResponse(response, success: { [weak self] (jsonObject) in
                    guard let strongSelf = self else { return }
                    if let data = jsonObject?["msg"] as? String {
                        Global.showAlert(message:data )
                    }
                    strongSelf.navigationController?.popViewController(animated: true)
                    }, failed: { [weak self] (error, json) in
                        guard let strongSelf = self else { return }
                        if let errorObj = error {
                            strongSelf.state = .error(errorObj)
                        }
                })
            }
        }
        
    }
    
    func apiProductDetail(productID:Int) {
        if let request = API.productDetail.request(method: .get, with: ["product_id": "\(productID)"]) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
    
                API.productDetail.validatedResponse(response, success: { [weak self] (jsonObject) in
                    guard let strongSelf = self else { return }
                    if let data = jsonObject?["product_data"] as? [String:Any], let jsonStringData = data.json().data(using: .utf8) {
                        do {
                            let decoder = JSONDecoder()
                            let product = try decoder.decode(ProductDetail.self, from: jsonStringData)
                            strongSelf.state = .loaded(product)
                        } catch let err {
                            print("Err", err)
                            strongSelf.state = .error(err)
                        }
                    }
                    
                    }, failed: { [weak self] (error, json) in
                        guard let strongSelf = self else { return }
                        if let errorObj = error {
                            strongSelf.state = .error(errorObj)
                        }
                })
            }
        }
    }
}

extension ProductDetailVC : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        guard let product = self.state.data else {return 0}
        
        if let picker = self.txtSize.picker, picker == pickerView {
            guard let sizes = product.size else {return 0}
            return sizes.count > 0 ? 1 : 0
        }else if let picker = self.txtCarrot.picker, picker == pickerView {
            guard let carrots = product.priority else {return 0}
            return carrots.count > 0 ? 1 : 0
        }else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let product = self.state.data else {return 0}
        
        if let picker = self.txtSize.picker, picker == pickerView {
            guard let sizes = product.size else {return 0}
            return sizes.count
        }else if let picker = self.txtCarrot.picker, picker == pickerView {
            guard let carrots = product.priority else {return 0}
            return carrots.count
        }else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let product = self.state.data else {return ""}
        
        if let picker = self.txtSize.picker, picker == pickerView {
            guard let sizes = product.size else {return ""}
            return sizes[row].name
        }else if let picker = self.txtCarrot.picker, picker == pickerView {
            guard let carrots = product.priority else {return ""}
            return carrots[row].name
        }else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let product = self.state.data else {return }
  
        if let picker = self.txtSize.picker, picker == pickerView {
            guard let sizes = product.size else {return }
            let selectedObj =  sizes[row]
            self.cartData.size = selectedObj.name
            self.cartData.sizeKey = "\(selectedObj.termID)"
            self.txtSize.text = selectedObj.name
        }else if let picker = self.txtCarrot.picker, picker == pickerView {
            guard let carrots = product.priority else {return }
            
            let selectedObj = carrots[row]
            self.cartData.purity = selectedObj.name
            self.txtCarrot.text = selectedObj.name

        }else {
            return
        }
    }
}
/*
extension String :MediaViewable {
    public var url: URL? {
        return URL(string: self)
    }
    
    public var thumb: URL? {
        return nil
    }
    
    public var dataType: MediaContentType? {
        return .image
    }
}
 */
