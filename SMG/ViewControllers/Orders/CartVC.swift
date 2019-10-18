//
//  CartVC.swift
//  SMG
//
//  Created by Amzad Khan on 20/09/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit

class CartVC: UIViewController {
    
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let errorView   = ErrorView.instanceFromNib()
    let emptyView   = EmptyView.instanceFromNib()
    let loadingView = LoadingView.instanceFromNib()
    
    fileprivate var state = APIState<[CartItem]>.loading {
        didSet {
            self.updateTableFooter()
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        emptyView.viewType = .emptyData(#imageLiteral(resourceName: "cart_img.png") , "")
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.btnCheckout.applyLinearGradient(colors: [ #colorLiteral(red: 0.9144535661, green: 0.2558653057, blue: 0.09014534205, alpha: 1), #colorLiteral(red: 0.8880044818, green: 0.7457256913, blue: 0.401170522, alpha: 1)])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiLoadCartItems()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapCheckout(_ sender: Any) {
        guard let item  = self.state.data?.first else {return}
        self.apiPlaceOrder(cartID: item.cartID ?? "")
    }
    
}
// MARK: - setup View
extension CartVC {
    
    func updateTableFooter() {
        switch self.state {
        case .error(let error):
            errorView.errorLabel.text = error.localizedDescription
            tableView.tableFooterView = errorView
        case .loading:
            tableView.tableFooterView = loadingView
        case .empty:
            
            tableView.tableFooterView = emptyView
        case .loaded(_):
            tableView.tableFooterView = nil
        }
    }
    
    func setupView(){
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.title = "MY CART"
        self.configureTopBar(left: [.dismiss], right:[.call])
        
    }
    
    func removeListItem(item:CartItem) {
        guard let items = self.state.data, items.count > 0 else {return}
        var mutableItems  = items
        if let index  = mutableItems.firstIndex(of:item) {
            mutableItems.remove(at: index)
        }
        
        if mutableItems.count > 0 {
            self.state = .loaded(mutableItems)
        }else {
            self.state = .empty
        }
    }
}


// MARK : - TableviewDatasource
extension CartVC : UITableViewDataSource {
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {if section != 0 {return categories[section]}else {return ""}}*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        /*return categories.count*/
        if self.state.data != nil {
            return 1
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items  = self.state.data else {
            return 0
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.kCartCell, for: indexPath) as! CartCell
        
        if let items = self.state.data {
            let item  = items[indexPath.row]
            cell.configureCell(data: item)
        }
        cell.delegate = self
        
        //cell.collectionView.isPagingEnabled = false
        return cell
    }
}

// MARK : - TableviewDelegate
extension CartVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        guard let item = self.state.data?[indexPath.row] else {return}
        
        let vc = ProductDetailVC.instantiate(fromAppStoryboard: .home)
        vc.type = .update
        vc.productID = Int(item.productID ?? "0")!
        vc.cartItem = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
import GMStepper
extension CartVC : OrderCellDelegate {
    func didTapDelete(cell: UITableViewCell, sender: Any) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            if let items = self.state.data {
                var mutableItems = items
                var item  = items[indexPath.row]
                self.apiRemoveCartItem(item: item)
            
            }
        }
    }
    
    func didTapAddToCart(cell: UITableViewCell, sender: Any) {}
    
    func didChangeQantity(cell: UITableViewCell, sender: Any) {
        if let indexPath = self.tableView.indexPath(for: cell), let stepper = sender as? GMStepper {
            if let items = self.state.data {
                var mutableItems = items
                var item  = items[indexPath.row]
                item.qty = String(Int(stepper.value))
                self.apiUpdateCartItem(item: item)
                mutableItems[indexPath.row] = item
                self.state = .loaded(mutableItems)
            }
        }
    }
}

// MARK : - Edit Profile APIs
extension CartVC {
    
    func apiRemoveCartItem(item:CartItem) {
        let params = ["product_id" : item.productID ?? "0", "cart_id" : item.cartID ?? ""]
        if let request = API.removeCartItem.request(method: .post, with: params) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.removeCartItem.validatedResponse(response, success: { [weak self] (jsonObject) in
                    if let data = jsonObject?["msg"] as? String {
                        Global.showAlert(message:data )
                    }
                    self?.removeListItem(item: item)
                    }, failed: { [weak self] (error, json) in
                        guard let strongSelf = self else { return }
                        if let errorObj = error {
                            strongSelf.state = .error(errorObj)
                        }
                })
            }
        }
    }
    
    func apiUpdateCartItem(item:CartItem) {
        var data = item.data
        if let request = API.updateCartItemQuantity.request(method: .post, with: data) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.updateCartItemQuantity.validatedResponse(response, success: { (jsonObject) in
                    if let data = jsonObject?["msg"] as? String {
                        Global.showAlert(message:data )
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
    func apiPlaceOrder(cartID:String) {
    
        let params  = [String:Any]()
        if let request = API.createOrder.request(method: .post, with: params) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.createOrder.validatedResponse(response, success: { [weak self] (jsonObject) in
                    if let data = jsonObject?["msg"] as? String {
                        Global.showAlert(message:data )
                    }
                    self?.state = .error(APIError.emptyDataError)
                    }, failed: { [weak self] (error, json) in
                        guard let strongSelf = self else { return }
                        if let errorObj = error {
                            strongSelf.state = .error(errorObj)
                        }
                })
            }
        }
    }
    
    func apiLoadCartItems() {
        if let request = API.cartList.request(method: .get, with: [:]) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.cartList.validatedResponse(response, success: { [weak self] (jsonObject) in
                    guard let strongSelf = self else { return }
                    if let data = jsonObject?["product_info"] as? [[String:Any]], let jsonStringData = data.json().data(using: .utf8) {
                        do {
                            let decoder = JSONDecoder()
                            let products = try decoder.decode([CartItem].self, from: jsonStringData)
                            if products.count == 0 {
                                strongSelf.state = .empty
                            }else {
                                strongSelf.state = .loaded(products)
                            }
                        } catch let err {
                            print("Err", err)
                            strongSelf.state = .error(err)
                        }
                        
                    }else {
                        strongSelf.state = .error(APIError.invalidData)
                    }
                    
                    }, failed: { [weak self] (error, json) in
                        guard let strongSelf = self else { return }
                        if json != nil {
                            strongSelf.state = .empty
                        }else if let errorObj = error {
                            strongSelf.state = .error(errorObj)
                        }
                })
            }
        }
    }
}
