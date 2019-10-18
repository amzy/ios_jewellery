//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import MBProgressHUD
import SlideMenuControllerSwift

enum LeftMenu: String {
    
    case home           = "Home"
    case editProfile    = "Edit Profile"
    case orders         = "My Orders"
    case customOrder    = "Custom Order"
    //case notification   = "Notifications"
    case wishList       = "Wishlist"
    //case signOut        = "Sign Out"
    
    var image: UIImage {
        switch self {
        case .home:
            return #imageLiteral(resourceName: "ic_home")
        case .editProfile:
            return #imageLiteral(resourceName: "ic_edit")
        case .orders:
            return #imageLiteral(resourceName: "ic_reorder")
        case .customOrder:
            return #imageLiteral(resourceName: "ic_business_center")
        case .wishList:
            return #imageLiteral(resourceName: "ic_wishlist.png")
       // case .notification:
            return #imageLiteral(resourceName: "ic_notifications")
        //case .signOut:
            return #imageLiteral(resourceName: "ic_exit_to_app")
        }
    }
}

protocol LeftMenuProtocol : class {
    func changeController(to menu: LeftMenu)
}

class LeftNavigationVC : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var gradientLayer           : CAGradientLayer!
    var currentColorSet         : Int!
    var colorSets               = [[CGColor]]()
    var userProfile: User!
    
    var home            : UINavigationController!
    var profile         : UINavigationController!
    var notification    : UINavigationController!
    var orders          : UINavigationController!
    var customOrder     : UINavigationController!
    var menus           = [LeftMenu]()
    var wishList        : UINavigationController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
        if let header = self.tableView?.tableHeaderView as? LeftMenuHeader, let user =  Constants.kAppDelegate.user {
            header.configureHeader(data: user)
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configureTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.tableView.reloadData), name: .kUpdateLeftMenu, object: nil)
        
        menus = [.home, .editProfile, .orders, .customOrder, .wishList/*, .notification, .signOut*/]
        home = UINavigationController(rootViewController: HomeVC.instantiate(fromAppStoryboard: .home))
        notification = UINavigationController(rootViewController: NotificationVC.instantiate(fromAppStoryboard: .home))
        profile = UINavigationController(rootViewController: ProfileVC.instantiate(fromAppStoryboard: .authentication))
        orders = UINavigationController(rootViewController: OrderVC.instantiate(fromAppStoryboard: .home))
        customOrder = UINavigationController(rootViewController: CustomOrderVC.instantiate(fromAppStoryboard: .home))
        wishList = UINavigationController(rootViewController: WishListVC.instantiate(fromAppStoryboard: .home))
        
        
        /*
        let testVC = TestListVC.storyboardInstance()
        testVC.type = .allTest
        allTest = UINavigationController(rootViewController: testVC)
        let commonTestVC = TestListVC.storyboardInstance()
        commonTestVC.type = .commonTest
        commonTest = UINavigationController(rootViewController: commonTestVC)
        quickGuide = UINavigationController(rootViewController: QuickGuideVC.storyboardInstance())
        feedback = UINavigationController(rootViewController: FeedbackVC.storyboardInstance())
        notification = UINavigationController(rootViewController: NotificationVC.storyboardInstance())
        contectInfo = UINavigationController(rootViewController: ContactInfoVC.storyboardInstance())
        settings = UINavigationController(rootViewController: SettingsVC.storyboardInstance())
        faqs = UINavigationController(rootViewController: FAQsVC.storyboardInstance())
        memos = UINavigationController(rootViewController: MemosVC.storyboardInstance())
        aboutUs = UINavigationController(rootViewController: AboutUsVC.storyboardInstance())
 */
        
    }
    
}

// MARK: - UITableViewDataSource
extension LeftNavigationVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.removeMargins()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.kLeftMenuCell) as! LeftMenuCell
        cell.selectionStyle = .none
        cell.title?.text = menus[indexPath.row].rawValue
        //cell.title?.font = UIFont.init(.title)
        cell.icon?.image = menus[indexPath.row].image
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LeftNavigationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        changeController(to: menus[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55//UITableViewAutomaticDimension
    }
}

// MARK: - LeftMenuProtocol
extension LeftNavigationVC: LeftMenuProtocol {
    func logoutUser() {
        let alert = UIAlertController(title: "Signout", message: "Are you sure you want to Signout?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
           Constants.kAppDelegate.logout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeController(to menu: LeftMenu) {
        self.slideMenuController()?.closeLeft()
        switch menu {
        case .home:
            self.home.popToRootViewController(animated: false)
            self.slideMenuController()?.changeMainViewController(self.home, close: true)
        
        case .editProfile:
            self.profile.popToRootViewController(animated: false)
            self.slideMenuController()?.changeMainViewController(self.profile, close: true)
        case .orders:
            self.orders.popToRootViewController(animated: false)
            self.slideMenuController()?.changeMainViewController(self.orders, close: true)
        case .customOrder:
            self.customOrder.popToRootViewController(animated: false)
            self.slideMenuController()?.changeMainViewController(self.customOrder, close: true)
        case .wishList:
            self.wishList.popToRootViewController(animated: false)
            self.slideMenuController()?.changeMainViewController(self.wishList, close: true)
        /*case .notification:
            self.notification.popToRootViewController(animated: false)
            self.slideMenuController()?.changeMainViewController(self.notification, close: true)
        case .signOut:
            Constants.kAppDelegate.logout()
        default: return*/
        }
    }
}

// MARK: Configuration
extension LeftNavigationVC  {
    /// Registers for all types of characteristic cells.
    private func registerReuseIdentifiers() {
        let nib = UINib(nibName: Identifiers.kLeftMenuCell, bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: Identifiers.kLeftMenuCell)
    }
    
    /// Configure Table View
    fileprivate func configureTableView() {
        registerReuseIdentifiers()
        self.tableView.estimatedRowHeight = 44
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let nibs  = Bundle.main.loadNibNamed("LeftMenuHeader", owner: nil, options: nil)
        if let header = nibs?.first as? LeftMenuHeader {
            self.tableView.tableHeaderView = header
        }
    }
}


// MARK: Left Menu Header
class LeftMenuHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var imageVw: UIImageView?
    weak var delegate: LeftMenuProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews() {
        imageVw?.makeCircular()
        imageVw?.layer.borderWidth = 1
        imageVw?.layer.borderColor = UIColor.green.cgColor
    }
    
    @IBAction func didTapHeader(_ sender: UIButton) {
        
    }
    
    func configureHeader(data: User) {
        
        title?.text = "Hello" + ", \(String(describing: data.name ?? ""))"
        subTitle?.text = data.firmName
        if let image = data.avatar?.image {
            imageVw?.image = image
        }else{
            guard let url = data.avatar?.url else {return}
            imageVw?.imageWithURL(url: url, placeholder: #imageLiteral(resourceName: "man_avatar"), handler: nil)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupViews()
    }
}

// MARK: Left Menu Cell
class LeftMenuCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        
    }
}

// MARK: Left Menu Cell
class LogOutCell: UITableViewCell {
    @IBOutlet weak var titleLogOut: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    func setupViews() {
    }
}

