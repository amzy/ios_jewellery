//
//  BannerView.swift
//  EzyParent
//
//  Created by Himanshu Parashar on 28/12/16.
//  Copyright © 2016 SyonInfomedia. All rights reserved.
//

import UIKit

extension String : BannerDataItem {
    var urlString: String {
        return self
    }
}
extension URL : BannerDataItem {
    var urlString: String {
        return self.absoluteString
    }
}


protocol BannerDelegate:NSObjectProtocol {
    func didTapItem(indexPath:IndexPath)
}
protocol BannerDataItem {
    var urlString:String {get}
}
class BannerView: CardView {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var lastContentOffset = CGPoint()
    weak var delegate:BannerDelegate?
    
    static func nibInstance() -> BannerView {
        let nib     = UINib(nibName: "BannerView", bundle: Bundle.main)
        let nView   = nib.instantiate(withOwner: self, options: nil)[0] as! BannerView
        //nView.translatesAutoresizingMaskIntoConstraints = false
        return nView
    }
    var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - ((insets.left) + (insets.right))
    }

    var banners:[BannerDataItem]! {
        didSet{
            pageControl.numberOfPages = banners?.count ?? 0
            self.collectionView.reloadData()
        }
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    /// Configure Collection View
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
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView.contentOffset = CGPoint.zero
        flowLayout.sectionHeadersPinToVisibleBounds = false
        
        
        //flowLayout.itemSize = CGSize(width: Constants.kScreenWidth , height: 184)
    }
}

//MARK: UIScrollViewDelegate
extension BannerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if abs(lastContentOffset.x - scrollView.contentOffset.x) < abs(lastContentOffset.y - scrollView.contentOffset.y) {
            //"Scrolled Vertically
        }
        else {
            //Scrolled Horizontally
            pageControl.currentPage = Int((scrollView.contentOffset.x + contentWidth / 2) / contentWidth)
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension BannerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentWidth , height: collectionView.frame.size.height)
    }
}
// MARK:- UICollectionViewDelegate
extension BannerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapItem(indexPath: indexPath)
    }
}

// MARK:- UICollectionViewDataSource
extension BannerView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (banners?.count ?? 0) == 0 {
            collectionView.setBackgroundMessage("Data not available!")
        } else {
            collectionView.setBackgroundMessage(nil)
        }
        return banners?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.kBannerCell, for: indexPath) as? BannerCell else {
            return UICollectionViewCell()
        }
        //cell.image.image =  #imageLiteral(resourceName: "account_banner")
         guard let url = banners[indexPath.row].urlString.makeURL() else {
            cell.image.image = nil
            return cell
         }
        cell.image.imageWithURL(url: url, placeholder: #imageLiteral(resourceName: "noImg"), handler: nil)
        return cell
    }
}
extension BannerView {
    func layoutHeaderView(_ offset: CGPoint) {
        
        /*
        
        let frame: CGRect = imageScrollView.frame
        if offset.y > 0 {
            frame.origin.y = max(offset.y * kParallaxDeltaFactor, 0)
            imageScrollView.frame = frame
            bluredImageView.alpha = 1 / kDefaultHeaderFrame.size.height * offset.y * 2
            clipsToBounds = true
        } else {
            var delta: CGFloat = 0.0
            let rect: CGRect = kDefaultHeaderFrame
            delta = CGFloat(fabs(min(0.0, offset.y)))
            rect.origin.y -= delta
            rect.size.height += delta
            imageScrollView.frame = rect
            clipsToBounds = false
            if let aDelta = 1 as? delta {
                headerTitleLabel.alpha = 1 - Int(aDelta / kMaxTitleAlphaOffset)
            }
        }
 */
    }
}
