//
//  SearchVC.swift
//  SMG
//
//  Created by Amzad Khan on 11/09/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit
enum VCSearchType {
    case keyword, range
}
class SearchVC: UIViewController {
    var type:VCSearchType = .keyword
    var minSize:String?
    var maxSize:String?
    
    let errorView   = ErrorView.instanceFromNib()
    let emptyView   = EmptyView.instanceFromNib()
    let loadingView = LoadingView.instanceFromNib()
    
    @IBOutlet weak var collectionView: UICollectionView!
    let searchController:UISearchController  = UISearchController(searchResultsController: nil)
    var query = ""
    var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - ((insets.left) + (insets.right))
    }
    
    fileprivate var state = APIState<[Product]>.loading {
        didSet {
            self.updateCollectionView()
            self.collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        //self.configureTopBar(left: [.dismiss])
        
        self.navigationItem.leftBarButtonItem = self.dismisButton()
        self.collectionView.register(UINib(nibName:Identifiers.kProductCell, bundle: Bundle.main), forCellWithReuseIdentifier: Identifiers.kProductCell)
        // Do any additional setup after loading the view.
        
        if self.type == .keyword {
            self.customizeSearchController()
        }else {
            self.apiLoadProduct(keyword: "", min: self.minSize ?? "", max: self.maxSize ?? "")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchController.searchBar.becomeFirstResponder()
        self.searchController.isActive = true
    }
    func updateCollectionView() {
        switch state {
        case .error(let error):
            errorView.errorLabel.text = error.localizedDescription
            collectionView.backgroundView =  errorView
        case .loading:
            collectionView.backgroundView =  loadingView
        case .empty:
            collectionView.backgroundView =  emptyView
        case .loaded(_):
            collectionView.backgroundView = nil
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func dismisButton() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.tintColor = UIColor.white
        button.setImage(#imageLiteral(resourceName: "dismiss"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(self.didTapTag(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    @objc func didTapTag(_ sender:Any)  {
        self.searchController.isActive = false
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: UICollectionViewDataSource
extension SearchVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rows = self.state.data?.count ?? 0
        if rows == 0 {
            collectionView.setBackgroundMessage("There is currently no collections.")
        } else {
            collectionView.setBackgroundMessage(nil)
        }
        return rows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.kProductCell, for: indexPath) as? ProductCell
        
        let product = self.state.data![indexPath.row]
        cell?.configureCell(data: product)
        
        return cell ?? UICollectionViewCell()
    }
    
}

// MARK: UICollectionViewDelegate
extension SearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = self.state.data?[indexPath.row] else {return}
        
        let vc = ProductDetailVC.instantiate(fromAppStoryboard: .home)
        vc.productID = item.productID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK:- UICollectionViewDelegateFlowLayout
extension SearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Load More Cell
        let cellPadding: CGFloat = 4
        var numberOfColumns = CGFloat(2.0)
        if let data = self.state.data, data.count == 1 {
            numberOfColumns = 1
        }
        if collectionView.isPagingEnabled {
            numberOfColumns = CGFloat(1.0)
        }
        let width = (contentWidth - (cellPadding * (numberOfColumns + 1))) / numberOfColumns
        let height:CGFloat = width * 1.45
        return CGSize(width: width, height: height)
    }
}
extension SearchVC {
    func customizeSearchController(){
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            //collectionView.he = searchController.searchBar
        }
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.navigationController?.navigationBar.tintColor = UIColor.white
        searchController.searchBar.searchBarStyle               = .minimal
        searchController.dimsBackgroundDuringPresentation       = false
        searchController.obscuresBackgroundDuringPresentation   = false
        searchController.searchBar.placeholder = NSLocalizedString("Enter keyword (e.g. test)", comment: "")
        searchController.searchBar.showsCancelButton    = false
        
        searchController.searchResultsUpdater           = self
        
        searchController.searchBar.delegate     = self
        definesPresentationContext              = true
        collectionView.keyboardDismissMode           = .onDrag
        
        
        let searchBarTextAttributes: [String: Any] = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.appNavigation, NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: CGFloat(UIFont.systemFontSize))]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
        UITextField.appearance(whenContainedInInstancesOf:[UISearchBar.self]).attributedPlaceholder = NSAttributedString(string:"Search by keyword", attributes:[NSAttributedStringKey.foregroundColor:UIColor.gray])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.appNavigation
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.white
        UILabel.appearance(whenContainedInInstancesOf: [UITextField.self]).tintColor = UIColor.gray
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white], for: .normal)
        
        
        
        if #available(iOS 11.0, *) {
            
            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {
                    
                    // Background color
                    backgroundview.backgroundColor = UIColor.white
                    
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
        }
    }
}
extension SearchVC : UISearchResultsUpdating, UISearchBarDelegate {
    
    //UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        self.view.isHidden = false
        guard let text = searchController.searchBar.text, text != "", text != query  else {return}
        query = searchController.searchBar.text ?? ""
        self.filterContent(forSearchText: query)
        //self.apiEvents(isSearching: true, query: query, page: 1)
    }
    
    //UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        //self.dismiss(animated: true, completion: nil)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            print("UISearchBar.text cleared!")
            query = ""
            self.filterContent(forSearchText: query)
        }
    }
}

extension SearchVC {
    func filterContent(forSearchText searchText: String?) {
        guard let keyword = searchText, keyword.count > 0 else {return}
        self.apiLoadProduct(keyword: keyword, min: "", max: "")
        //get_search_product?max_weight=&posts_per_page=50&user_id=4&min_weight=&sku=smg
    }
}
extension SearchVC {
    func apiLoadProduct(keyword:String, min:String, max:String) {
        var prams = ["posts_per_page":"50"]
        if keyword.count > 0 {
            prams["sku"] = keyword
        }
        if min.count > 0 || max.count > 0 {
            prams["min_weight"] = Int(any:min) <= 0 ? "1" : min
            prams["max_weight"] = max
        }
        
        if let request = API.searchProduct.request(method: .get, with: prams) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.searchProduct.validatedResponse(response, success: { [weak self] (jsonObject) in
                    guard let strongSelf = self else { return }
                    if let data = jsonObject?["products"] as? [[String:Any]], let jsonStringData = data.json().data(using: .utf8) {
                        do {
                            let decoder = JSONDecoder()
                            let products = try decoder.decode([Product].self, from: jsonStringData)
                            strongSelf.state = .loaded(products)
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
