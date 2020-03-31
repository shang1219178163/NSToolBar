//
//  AppDelegate.swift
//  Swift-NSToolBar
//
//  Created by shang on 31/3/20.
//  Copyright (c) 2020 Knowstack. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    lazy var window: NSWindow = {
        let screenSize = NSScreen.main?.frame
        let window = NSWindow(contentRect: NSMakeRect(0, 0, screenSize!.width*0.5, screenSize!.height*0.5),
                        styleMask: [.titled, .resizable, .miniaturizable, .closable, .fullSizeContentView],
                        backing: .buffered,
                        defer: false)
        // 设置最小尺寸
        window.minSize = window.frame.size
        // 打开显示在屏幕的中心位置
        window.center()

        return window
    }()

    var toolbar: NSToolbar!

    let toolbarItems: [[String: String]] = [
        ["title": "irrelevant :)", "icon": "", "identifier": "NavigationGroupToolbarItem"],
        ["title": "Share", "icon": NSImage.shareTemplateName, "identifier": "ShareToolbarItem"],
        ["title": "Add", "icon": NSImage.addTemplateName, "identifier": "AddToolbarItem"],
        ["title": "Departments",
         "icon": "NSPreferencesGeneral",
         "identifier": "DepartmentViewController"],
        ["title": "Accounts",
         "icon": "NSFontPanel",
         "identifier": "AccountViewController"],
        ["title": "Employees",
         "icon": "NSAdvanced",
         "identifier": "EmployeeViewController"],
        ["title": "", "icon": "", "identifier": "NNUserInfoView"],
    ]

    var toolbarTabsIdentifiers: [NSToolbarItem.Identifier] {
        var list = toolbarItems.compactMap { $0["identifier"] }.map{ NSToolbarItem.Identifier(rawValue: $0) }
        list.insert(NSToolbarItem.Identifier.flexibleSpace, at: 3)
        list.insert(NSToolbarItem.Identifier.flexibleSpace, at: list.count - 1)
//        list.append(NSToolbarItem.Identifier.flexibleSpace)
        return list
    }
    
    var currentVC: NSViewController!

    var currentIdentifier = ""

    // MARK: -lifecycle
    func applicationDidFinishLaunching(_ notification: Notification) {
        window.makeKeyAndOrderFront(nil)
        NSApplication.shared.mainWindow?.title = "Swift-NSToolBar"

        // 设置 contentViewController
        let contentViewController = DepartmentViewController() // or ViewController(nibName:nil, bundle: nil)
        window.contentViewController = contentViewController
        
        toolbar = NSToolbar(identifier:"TheToolbarIdentifier")
        toolbar.allowsUserCustomization = true
        toolbar.delegate = self
        window.toolbar = toolbar
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag == false {
            window.makeKeyAndOrderFront(self)
            return true
        }
        return false;
    }
    
    // MARK: -funtions
    @objc func handleSegmentSelected(_ sender: NSSegmentedControl){
        print("\(#function):\(sender.selectedSegment)")

    }
    
    @objc func handleBtnSelected(_ sender: NSButton){
        print("\(#function):\(sender)")

    }
    
    @objc func handleItemSelected(_ sender: NSToolbarItem){
        print("\(#function):\(sender.itemIdentifier.rawValue)_\(sender.label)")
        loadViewWithIdentifier(itemIdentifier: sender.itemIdentifier.rawValue, withAnimation: true)

    }
    
    @objc func handleViewSelected(_ sender: NNUserInfoView){
        print("\(#function):\(sender)")

    }
    
    func loadViewWithIdentifier(itemIdentifier: String, withAnimation shouldAnimate:Bool){
        let VCIdentifiers: [String] = ["DepartmentViewController", "AccountViewController", "EmployeeViewController"]
        if VCIdentifiers.contains(itemIdentifier) == false {
            return
        }
        
//        print("\(#function):\(itemIdentifier)")
        if (currentIdentifier == itemIdentifier){
            return
        }
        currentIdentifier = itemIdentifier
        
        guard let itemDict: [String : String] = toolbarItems.filter({ $0["identifier"] == itemIdentifier }).first
            else { return }

        if (itemIdentifier == "DepartmentViewController"){
            currentVC = DepartmentViewController()

        }
        else if (itemIdentifier == "AccountViewController"){
            currentVC = AccountViewController()

        }
        else if (itemIdentifier == "EmployeeViewController"){
            currentVC = EmployeeViewController()
        }
                
//        print(currentVC as Any)
        let newView = currentVC.view
        
        let windowRect = window.frame
        let currentViewRect = newView.frame
        
//        print(windowRect as Any)
        
        let originY = windowRect.origin.y + (windowRect.size.height - currentViewRect.size.height)
        let newFrame = NSMakeRect(windowRect.origin.x, originY, currentViewRect.size.width, currentViewRect.size.height)

        window.title = currentVC.title ?? itemDict["title"]!;
        window.contentView = newView
        window.setFrame(newFrame, display: true, animate: shouldAnimate)
    }

}


extension AppDelegate: NSToolbarDelegate{
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {

        guard let itemDict: [String : String] = toolbarItems.filter({ $0["identifier"] == itemIdentifier.rawValue }).first
            else { return nil }

        let toolbarItem: NSToolbarItem

        if itemIdentifier.rawValue == "NavigationGroupToolbarItem" {

            let group = NSToolbarItemGroup(itemIdentifier: itemIdentifier)

            let itemA = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "PrevToolbarItem"))
            itemA.label = "Prev"
            let itemB = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "NextToolbarItem"))
            itemB.label = "Next"

//            let segmented = NSSegmentedControl(frame: NSRect(x: 0, y: 0, width: 85, height: 40))
//            segmented.segmentStyle = .texturedRounded
//            segmented.trackingMode = .momentary
//
//            segmented.segmentCount = 2
//            // Don't set a label: these would appear inside the button
//            segmented.setImage(NSImage(named: NSImage.goBackTemplateName)!, forSegment: 0)
//            segmented.setWidth(40, forSegment: 0)
//            segmented.setImage(NSImage(named: NSImage.goForwardTemplateName)!, forSegment: 1)
//            segmented.setWidth(40, forSegment: 1)
            let items: [Any] = [NSImage(named: NSImage.goBackTemplateName)!, NSImage(named: NSImage.goForwardTemplateName)!, ]
            let segmented = NSSegmentedControl.create(NSRect(x: 0, y: 0, width: items.count*40, height: 40), items: items)
            segmented.target = self
            segmented.action = #selector(handleSegmentSelected(_:))

            // `group.label` would overwrite segment labels
            group.paletteLabel = "Navigation"
            group.subitems = [itemA, itemB]
            group.view = segmented

            toolbarItem = group
        } else if ["ShareToolbarItem", "AddToolbarItem"].contains(itemIdentifier.rawValue) {


            let iconImage = NSImage(named: itemDict["icon"]!)
            let button = NSButton(frame: NSRect(x: 0, y: 0, width: 40, height: 40))
            button.title = ""
            button.image = iconImage
            button.bezelStyle = .texturedRounded
            button.target = self
            button.action = #selector(handleBtnSelected(_:))
            
            toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.label = itemDict["title"]!
            toolbarItem.view = button
            
        } else if ["NNUserInfoView", ].contains(itemIdentifier.rawValue) {
            
           let userView = NNUserInfoView(frame: NSRect(x: 0, y: 0, width: 160, height: 50))
            userView.name = "SoaringHeart"
            userView.desc = "装逼或者被装逼。"
            userView.delegate = self
           
           toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
           toolbarItem.label = itemDict["title"]!
           toolbarItem.target = self
           toolbarItem.action = #selector(handleViewSelected(_:))
           toolbarItem.view = userView
               
        }  else {
            let iconImage = NSImage(named: itemDict["icon"]!)
            
            toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.label = itemDict["title"]!
            toolbarItem.image = iconImage
            toolbarItem.target = self
            toolbarItem.action = #selector(handleItemSelected(_:))
        }
        return toolbarItem
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.toolbarTabsIdentifiers;
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.toolbarDefaultItemIdentifiers(toolbar)
    }

    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.toolbarDefaultItemIdentifiers(toolbar)
    }

    func toolbarWillAddItem(_ notification: Notification) {
        print("toolbarWillAddItem", (notification.userInfo?["item"] as? NSToolbarItem)?.itemIdentifier ?? "")
    }

    func toolbarDidRemoveItem(_ notification: Notification) {
        print("toolbarDidRemoveItem", (notification.userInfo?["item"] as? NSToolbarItem)?.itemIdentifier ?? "")
    }
    
}


extension AppDelegate: NSToolbarItemValidation{
    
    func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
        return true
    }
}


extension AppDelegate: NNUserInfoViewDelegate{

    func userInfoView(_ userView: NNUserInfoView, state: NSResponder.MouseState, event: NSEvent) {
        switch state {
        case .entered:
            print("\(#function):进入区域")
        case .exited:
            print("\(#function):离开区域")
        case .down:
            print("\(#function):点击")
        case .up:
            print("\(#function):抬起")
        default:
            break
        }
    }
}
