//
//  DepartmentViewController.swift
//  Swift-NSToolBar
//
//  Created by shang on 5/2/15.
//  Copyright (c) 2020 Knowstack. All rights reserved.
//

import Cocoa

class DepartmentViewController: NSViewController {
    override func loadView() {
        // 设置 ViewController 大小同 mainWindow
        guard let windowRect = NSApplication.shared.mainWindow?.frame else { return }
        view = NSView(frame: windowRect)
        view.wantsLayer = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.layer?.backgroundColor = NSColor.yellow.cgColor
        
        preferredContentSize = CGSize(width: NSScreen.main!.frame.width*0.4, height: NSScreen.main!.frame.height*0.4)

    }
    
}


class AccountViewController: NSViewController {
    override func loadView() {
        // 设置 ViewController 大小同 mainWindow
        guard let windowRect = NSApplication.shared.mainWindow?.frame else { return }
        view = NSView(frame: windowRect)
        view.wantsLayer = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        view.layer?.backgroundColor = NSColor.red.cgColor
        
        preferredContentSize = CGSize(width: NSScreen.main!.frame.width*0.5, height: NSScreen.main!.frame.height*0.5)

    }
    
}

class EmployeeViewController: NSViewController {
    override func loadView() {
        // 设置 ViewController 大小同 mainWindow
        guard let windowRect = NSApplication.shared.mainWindow?.frame else { return }
        view = NSView(frame: windowRect)
        view.wantsLayer = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.layer?.backgroundColor = NSColor.green.cgColor
        
        preferredContentSize = CGSize(width: NSScreen.main!.frame.width*0.6, height: NSScreen.main!.frame.height*0.6)

    }
    
}
