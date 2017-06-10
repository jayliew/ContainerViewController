//
//  MenuViewController.swift
//  ContainerViewController
//
//  Created by Jay Liew on 6/1/17.
//  Copyright © 2017 Jay Liew. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var activeViewContainer: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(inactiveViewController: oldValue)
            updateActiveViewController()
        } // didSet
    } // var activeViewController

    private var viewControllerArray: [UIViewController] = [] // DO NOT CHANGE THIS DIRECTLY
    // USE accessor var viewControllers
    
    var viewControllers: [UIViewController]  { // THIS IS THE ACCESSOR to private var viewControllerArray
        get { // getter returns read only copy
            let immutableCopy = viewControllerArray
            print("-- viewControllers (accessor): getting current array. Count is: \(viewControllerArray.count)")
            return immutableCopy
        } // get
        
        set {
            viewControllerArray = newValue
            print("-- viewControllers (accessor): setting new array. Count is: \(viewControllerArray.count)")
            
            // set the active view controller to the first one in the new array if the current one is not in there
            if activeViewController == nil || viewControllerArray.index(of:activeViewController!) == nil {
                activeViewController = viewControllerArray.first
                print("-- viewControllers (accessor): setting active VC to viewControllerArray with title: \(viewControllerArray.first!.title!)")
            }
        } // set
    } // var viewControllers
    
    required init(coder aDecoder: NSCoder) {
        print("-- init(coder aDecoder: NSCoder)")
        super.init(nibName: "MenuViewController", bundle: nil)
    } // init

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!){
        print("-- init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!)")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    } // init
        
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if isViewLoaded {
            print("-- removeInactiveViewController: view is loaded")
            if let inActiveVC = inactiveViewController {
                print("-- removeInactiveViewController: inactiveVC != nil, therefore inactiveViewController willMove, removeFromSuperView, removeFromParentViewController")
                inActiveVC.willMove(toParentViewController: nil)
                inActiveVC.view.removeFromSuperview()
                inActiveVC.removeFromParentViewController()
            }
        }else{
            print("-- removeInactiveViewController: view is NOT loaded")
        }
    } // removeInactiveViewController
    
    private func updateActiveViewController() {
        if isViewLoaded {
            print("-- updateActiveViewController: view is loaded")
            if let activeVC = activeViewController {
                print("-- updateActiveViewController: activeViewController != nil, therefore addChildViewController, addSubview, didMove")
                addChildViewController(activeVC)
                activeVC.view.frame = activeViewContainer.bounds
                activeViewContainer.addSubview(activeVC.view)
                navItem.title = activeVC.title
                activeVC.didMove(toParentViewController: self)
            } // activeViewController != nil
        }else{
            print("-- updateActiveViewController: view is NOT loaded")
        }
    } // updateActiveViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.rowHeight =  50
        // menu is hidden to start
        self.tableViewHeightConstraint.constant = 0

/*
        // initialize these view controllers here if not done from inside AppDelegate
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        let vc3 = UIViewController()
        vc1.title = "First"
        vc2.title = "Second"
        vc3.title = "Third"
        vc1.view.backgroundColor = UIColor.blue
        vc2.view.backgroundColor = UIColor.green
        vc3.view.backgroundColor = UIColor.yellow
        viewControllers = [vc1, vc2, vc3]
 */
        updateActiveViewController()
        
    } // viewDidLoad
    
    @IBAction func didTapMenuButton(_ sender: Any) {
        print("-- didTapMenuButton")
        if (tableViewHeightConstraint.constant == 0) {
            showMenu()
        } else {
            hideMenu()
        }
    } // didTapMenuButton
    
    private func hideMenu() {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.tableViewHeightConstraint.constant = 0
            self.tableView.layoutIfNeeded()
        });
        print("-- hideMenu self.tableViewHeightConstraint.constant: \(self.tableViewHeightConstraint.constant)" )
    } // hideMenu
    
    private func showMenu() {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            let totalHeight = self.tableView.rowHeight * CGFloat(self.tableView.numberOfRows(inSection: 0))
            self.tableViewHeightConstraint.constant = totalHeight
            self.tableView.layoutIfNeeded()
        });
        print("-- showMenu self.tableViewHeightConstraint.constant: \(self.tableViewHeightConstraint.constant)" )
    } // showMenu
    
    // MARK: UITableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("-- numberOfRowsInSection: \(viewControllerArray.count)")
        return viewControllerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = viewControllerArray[indexPath.row].title
        print("-- cellForRowAt indexPath.row: \(indexPath.row)")
        print("-- cellForRowAt title: \(String(describing: viewControllerArray[indexPath.row].title))")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("-- didDeselectRowAt indexPath.row: \(indexPath.row)")
        activeViewController = viewControllerArray[indexPath.row]
        hideMenu()
    } // didDeselectRowAt
    
} // MenuViewController
