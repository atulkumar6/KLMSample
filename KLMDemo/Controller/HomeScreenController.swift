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
protocol CollectionItemProtocol {
    associatedtype searchItemTextType
    var searchItemNumber:searchItemTextType {get}
    func removeItemNumber()
}
protocol SearchTextProtocol {
    func removeTextSearchBar()
}
protocol HomeScreenProtocol:SearchTextProtocol {
    func reloadCollectionView()
    func filterCollectionItem(itemNumber:Int)
}

class HomeScreenController: UIViewController {
    // UI Outles
    @IBOutlet var topBarView: UIView?
    @IBOutlet var topBarTitleLabel:UILabel?
    @IBOutlet var cancelButton:UIButton?
    @IBOutlet var searchButton:UIButton?
    @IBOutlet var tabBar:UITabBar?
    @IBOutlet var searchBar:UISearchBar?
    @IBOutlet var collectionView:UIView?
    // Class Attributes
    fileprivate var pageMenu:CAPSPageMenu?
    fileprivate var delegate:HomeScreenProtocol?
    var collectionViewController:CollectionViewController?
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
        collectionViewController = Helper.getControllerInstance(Constants.collectionViewControllerId) as? CollectionViewController
        collectionViewController?.collectionView?.reloadData()
        delegate?.reloadCollectionView()
    }
    private func setupPageMenu() {
        var controllerArray : [UIViewController] = []
        let collectionController = Helper.getControllerInstance(Constants.collectionViewControllerId) as? CollectionViewController
        collectionController?.parentController = self
        delegate = collectionController
        collectionController?.title = Constants.collectionViewNavBarTitle
        guard let collectionView = collectionView else{
            return
        }
        collectionController?.view.frame = CGRect(x: 0.0, y:0, width: collectionView.frame.width, height: collectionView.frame.height)
        if let controller = collectionController {
            controllerArray.append(controller)
        }
        let informationController = Helper.getControllerInstance(Constants.informationViewControllerId) as? InformationController
        informationController?.view.frame = CGRect(x: 0.0, y:0, width: collectionView.frame.width, height: collectionView.frame.height)
        informationController?.title = Constants.informationTitle
        if let controller = informationController {
            controllerArray.append(controller)
        }
        let parameters = getPageMenuOptions()
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width:UIScreen.main.bounds.size.width,height:collectionView.frame.height), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        if let view = pageMenu?.view {
            collectionView.addSubview(view);
        }
        addConstraintOnPageMenu()
    }
    private func getPageMenuOptions() -> [CAPSPageMenuOption] {
        return [.menuItemSeparatorWidth(Constants.menuItemSeparatorWidth),
                .scrollMenuBackgroundColor(.whiteColorInstance),
                .viewBackgroundColor(.viewBackgroundColor),
                .bottomMenuHairlineColor(.bottomMenuHairlineColor),
                .selectionIndicatorColor(.selectionIndicatorColor),
                .menuMargin(Constants.menuMargin),
                .menuHeight(Constants.menuHeight),
                .selectedMenuItemLabelColor(.blue),
                .unselectedMenuItemLabelColor(.lightGray),
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
        if let view = pageMenu?.view {
            let horizontalConstraintView = NSLayoutConstraint.constraints(withVisualFormat:"H:|-0-[pageMenuView]-0-|" , options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:["pageMenuView":view])
            let verticalConstraintView = NSLayoutConstraint.constraints(withVisualFormat:"V:|-0-[pageMenuView]-0-|" , options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:["pageMenuView":view])
            NSLayoutConstraint.activate(horizontalConstraintView)
            NSLayoutConstraint.activate(verticalConstraintView)
        }
        if let menuScrollView = pageMenu?.menuScrollView {
            pageMenu?.menuScrollView.translatesAutoresizingMaskIntoConstraints = false;
            let horizontalConstraintScroll = NSLayoutConstraint.constraints(withVisualFormat:"H:|-0-[pageMenuScroll]-0-|" , options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:["pageMenuScroll":menuScrollView])
            let verticalConstraintScroll = NSLayoutConstraint.constraints(withVisualFormat:"V:|-0-[pageMenuScroll]-0@250-|" , options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:["pageMenuScroll":menuScrollView])
            NSLayoutConstraint.activate(horizontalConstraintScroll)
            NSLayoutConstraint.activate(verticalConstraintScroll)
        }
    }
    // MARK: Button Actions
    @IBAction func cancelButtonAction() {
        searchBar?.resignFirstResponder()
        searchBar?.text = Constants.emptyText
        searchBar?.isHidden = true
        cancelButton?.isHidden = true
        delegate?.removeTextSearchBar()
    }
    @IBAction func searchButtonAction() {
        searchBar?.isHidden = false
        cancelButton?.isHidden = false
    }
}
// MARK: PageMenu Delegate
extension HomeScreenController:CAPSPageMenuDelegate {
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        // Swift switch case
        switch index {
        case 0:
            topBarTitleLabel?.text = Constants.collectionViewNavBarTitle
        case 1:
            topBarTitleLabel?.text = Constants.informationTitle
        default:
            break
        }
    }
}
// MARK: SearchBar  Delegate
extension HomeScreenController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == Constants.emptyText {
            delegate?.removeTextSearchBar()
        }
        else {
            delegate?.filterCollectionItem(itemNumber:Int(searchText) ?? Constants.invalidItemTag)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
extension HomeScreenController:UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        pageMenu?.moveToPage(item.tag)
    }
}


