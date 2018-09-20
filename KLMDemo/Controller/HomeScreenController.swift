//
//  ViewController.swift
//  KLMDemo
//
//  Created by Atul Kumar on 9/11/18.
//  Copyright © 2018 Atul Kumar. All rights reserved.
//

import UIKit
import myPod
import CoreData

// MARK: Custom Protocol
protocol HomeScreenProtocol {
    func reloadCollectionView()
    func filterCollectionItem(itemNumber:Int)
    func clearTextSearchBar()
}
class HomeScreenController: UIViewController {
    // UI Outles
    @IBOutlet var vwTopBar: UIView?
    @IBOutlet var lblTopBarTitle:UILabel?
    @IBOutlet var btnCancel:UIButton?
    @IBOutlet var btnSearch:UIButton?
    @IBOutlet var tabBar:UITabBar?
    @IBOutlet var searchBar:UISearchBar?
    @IBOutlet var vwCollection:UIView?
    // Class Attributes
    fileprivate var pageMenu:CAPSPageMenu?
    fileprivate var delegate:HomeScreenProtocol?
    var collectionCntrl:CollectionViewController?
    // MARK: ViewLifeCycle
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupPageMenu()
    }
    //2
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //3
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        collectionCntrl = Helper.getControllerInstance(Constants.collectionViewControllerId) as? CollectionViewController
        collectionCntrl?.vwCollection?.reloadData()
        delegate?.reloadCollectionView()
    }
    private func setupPageMenu() {
        var controllerArray : [UIViewController] = []
        let collectionCntrl = Helper.getControllerInstance(Constants.collectionViewControllerId) as? CollectionViewController
        collectionCntrl?.parentNav = self
        delegate = collectionCntrl
        collectionCntrl?.title = Constants.collectionViewNavBarTitle
        collectionCntrl?.view.frame = CGRect(x: 0.0, y:0, width: (vwCollection?.frame.width) ?? 0, height: (vwCollection?.frame.height) ?? 0)
        controllerArray.append(collectionCntrl ?? UIViewController())
        let informationController = Helper.getControllerInstance(Constants.informationViewControllerId) as? InformationController
        informationController?.view.frame = CGRect(x: 0.0, y:0, width: (vwCollection?.frame.width) ?? 0, height: (vwCollection?.frame.height) ?? 0)
        informationController?.title = Constants.informationTitle
        controllerArray.append(informationController ?? UIViewController())
        let parameters = getPageMenuOptions()
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0, width:UIScreen.main.bounds.size.width, height: (vwCollection?.frame.height) ?? 0), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        vwCollection?.addSubview((pageMenu?.view) ?? UIView());
        addConstraintOnPageMenu()
    }
    private func getPageMenuOptions() -> [CAPSPageMenuOption] {
        return [.menuItemSeparatorWidth(Constants.menuItemSeparatorWidth),
            .scrollMenuBackgroundColor(UIColor.whiteColorInstance),
            .viewBackgroundColor(UIColor.viewBackgroundColor),
            .bottomMenuHairlineColor(UIColor.bottomMenuHairlineColor),
            .selectionIndicatorColor(UIColor.selectionIndicatorColor),
            .menuMargin(Constants.menuMargin),
            .menuHeight(Constants.menuHeight),
            .selectedMenuItemLabelColor(UIColor.blue),
            .unselectedMenuItemLabelColor(UIColor.lightGray),
            .menuItemFont(UIFont(name:Constants.helvitica, size: Constants.menuItemFontSize) ?? UIFont()),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges(false),
            .selectionIndicatorHeight(Constants.selectionIndicatorHeight),
            .menuItemSeparatorPercentageHeight(Constants.menuItemSeparatorPercentageHeight)
        ]
        
    }
    private func addConstraintOnPageMenu() {
        pageMenu?.view.translatesAutoresizingMaskIntoConstraints = false;
        // adding constraints programmaticaly.
        let dictPageMenuView:[String:UIView] = ["pageMenuVw":pageMenu?.view ?? UIView()];
        let horizontalConstraintVw = NSLayoutConstraint.constraints(withVisualFormat:"H:|-0-[pageMenuVw]-0-|" , options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:dictPageMenuView)
        let verticalConstraintVw = NSLayoutConstraint.constraints(withVisualFormat:"V:|-0-[pageMenuVw]-0-|" , options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:dictPageMenuView)
        NSLayoutConstraint.activate(horizontalConstraintVw)
        NSLayoutConstraint.activate(verticalConstraintVw)
        pageMenu?.menuScrollView.translatesAutoresizingMaskIntoConstraints = false;
        let dictPageMenuScroll:[String:UIView] = ["pageMenuScroll":pageMenu?.menuScrollView ?? UIView()];
        let horizontalConstraintScroll = NSLayoutConstraint.constraints(withVisualFormat:"H:|-0-[pageMenuScroll]-0-|" , options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:dictPageMenuScroll)
        let verticalConstraintScroll = NSLayoutConstraint.constraints(withVisualFormat:"V:|-0-[pageMenuScroll]-0@250-|" , options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:dictPageMenuScroll)
        NSLayoutConstraint.activate(horizontalConstraintScroll)
        NSLayoutConstraint.activate(verticalConstraintScroll)
    }
}
// MARK: PageMenu Delegate
extension HomeScreenController:CAPSPageMenuDelegate {
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        // Swift switch case
        switch index {
        case 0:
            lblTopBarTitle?.text = Constants.collectionViewNavBarTitle
        case 1:
            lblTopBarTitle?.text = Constants.informationTitle
        default:
            break
        }
    }
}
// MARK: SearchBar  Delegate
extension HomeScreenController:UISearchBarDelegate {
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == Constants.emptyText {
            delegate?.clearTextSearchBar()
        }
        else {
        delegate?.filterCollectionItem(itemNumber:Int(searchBar.text ?? String(Constants.invalidItemTag)) ?? Constants.invalidItemTag)
        }
     }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
     @IBAction func btnCancelClicked() {
        searchBar?.resignFirstResponder()
        searchBar?.text = Constants.emptyText
        searchBar?.isHidden = true
        btnCancel?.isHidden = true
        delegate?.clearTextSearchBar()
    }
    @IBAction func btnSearchClicked() {
        searchBar?.isHidden = false
        btnCancel?.isHidden = false
    }
}
extension HomeScreenController:UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        pageMenu?.moveToPage(item.tag)
    }
}


