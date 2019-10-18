//
//  WishListVC.swift
//  SMG
//
//  Created by Amzad Khan on 20/10/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//
import UIKit

class WishListVC: UIViewController {
    //no_wish_big
    @IBOutlet weak var tableView: UITableView!
    let errorView   = ErrorView.instanceFromNib()
    let emptyView   = EmptyView.instanceFromNib()
    let loadingView = LoadingView.instanceFromNib()
    
    fileprivate var state = APIState<[WishListItem]>.loading {
        didSet {
            self.updateTableFooter()
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        emptyView.viewType = .emptyData(#imageLiteral(resourceName: "no_wish_big.png") , "")
        emptyView.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiLoadwhishListItems()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK: - setup View
extension WishListVC {
    
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
        self.title = "WISHLIST"
        self.configureTopBar(left: [.leftMenu])

    }
    
    func removeListItem(item:WishListItem) {
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
extension WishListVC : UITableViewDataSource {
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
extension WishListVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { print(indexPath.row) }
    
}
import GMStepper
extension WishListVC : OrderCellDelegate {
    func didTapDelete(cell: UITableViewCell, sender: Any) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            if let items = self.state.data {
                //var mutableItems = items
                var item  = items[indexPath.row]
                self.apiRemoveWishListItem(item: item)
                
        
            }
        }
    }
    
    func didTapAddToCart(cell: UITableViewCell, sender: Any) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            if let items = self.state.data {
                //var mutableItems = items
                var item  = items[indexPath.row]
                self.apiAddToCartItem(item: item)
            }
        }
    }
    
    func didChangeQantity(cell: UITableViewCell, sender: Any) {}
}

// MARK : - Edit Profile APIs
extension WishListVC {
    
    func apiAddToCartItem(item:WishListItem) {
        let data = ["product_id" : item.productID ?? "0", "wishlist_id" : item.wishlistID ?? "", "sku" : item.sku ?? ""]
        if let request = API.whichListCart.request(method: .get, with: data) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.whichListCart.validatedResponse(response, success: { [weak self] (jsonObject) in
                    if let data = jsonObject?["msg"] as? String {
                        Global.showAlert(message:data )
                    }
                    Constants.kAppDelegate.apiLoadUserData()
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
    // removeWhichListItem    = "remove_wishlist_item" //?user_id=4&product_id=733&wishlist_id=63
   // whichListCart          = "wishlist_product_add_to_cart" //?user_id=4&product_id=731&wishlist_id=64&sku=CL0089VDY"
    
    func apiRemoveWishListItem(item:WishListItem) {
        let params = ["product_id" : item.productID ?? "0", "wishlist_id" : item.wishlistID ?? ""]
        if let request = API.removeWhichListItem.request(method: .get, with: params) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.removeWhichListItem.validatedResponse(response, success: { [weak self] (jsonObject) in
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
    
    func apiLoadwhishListItems() {
        if let request = API.whishList.request(method: .get, with: [:]) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.whishList.validatedResponse(response, success: { [weak self] (jsonObject) in
                    guard let strongSelf = self else { return }
                    if let data = jsonObject?["product_info"] as? [[String:Any]], let jsonStringData = data.json().data(using: .utf8) {
                        do {
                            let decoder = JSONDecoder()
                            let products = try decoder.decode([WishListItem].self, from: jsonStringData)
                            
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
