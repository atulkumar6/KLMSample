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
}
class HomeScreenController: UIViewController {
    // UI Outles
    @IBOutlet var vwTopBar: UIView?
    @IBOutlet var lblTopBarTitle:UILabel?
    @IBOutlet var btnMenuFlip:UIButton?
    @IBOutlet var btnSearch:UIButton?
    @IBOutlet var tabBar:UITabBar?
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
        
        collectionCntrl = Helper.getControllerInstance("CollectionView") as? CollectionViewController
        collectionCntrl?.vwCollection?.reloadData()
        delegate?.reloadCollectionView()
    }
    private func setupPageMenu() {
        var controllerArray : [UIViewController] = []

        let collectionCntrl = Helper.getControllerInstance("CollectionView") as? CollectionViewController
        collectionCntrl?.parentNav = self
        self.delegate = collectionCntrl

        collectionCntrl?.title = "Collection"
        collectionCntrl?.view.frame = CGRect(x: 0.0, y:0, width: (self.vwCollection?.frame.width) ?? 0, height: (self.vwCollection?.frame.height) ?? 0)
        
        
        controllerArray.append(collectionCntrl ?? UIViewController())
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha: 1.0)),
            .viewBackgroundColor(UIColor(red: 252.0/255.0, green: 252.0/255.0, blue: 252.0/255.0, alpha: 1.0)),
            .bottomMenuHairlineColor(UIColor(red: 255.0/255.0, green: 196.0/255.0, blue: 0/255.0, alpha: 1.0)),
            .selectionIndicatorColor(UIColor(red: 153.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)),
            .menuMargin(20),
            .menuHeight(40),
            .selectedMenuItemLabelColor(UIColor.blue),
            .unselectedMenuItemLabelColor(UIColor(red: 196.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.8)),
            .menuItemFont(UIFont(name:Constants.helvitica, size: 13.0) ?? UIFont()),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorRoundEdges(false),
            .selectionIndicatorHeight(2.0),
            .menuItemSeparatorPercentageHeight(0.1)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0, width:UIScreen.main.bounds.size.width, height: (self.vwCollection?.frame.height) ?? 0), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        self.vwCollection?.addSubview((pageMenu?.view) ?? UIView());
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
            lblTopBarTitle?.text = "Collection"
        case 1:
            lblTopBarTitle?.text = "NextPage"
        default:
            break
        }
        
    }
}

