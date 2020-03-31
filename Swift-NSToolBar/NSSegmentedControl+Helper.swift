//
//  NSSegmentedControl+Helper.swift
//  Swift-NSToolBar
//
//  Created by Bin Shang on 2020/3/31.
//  Copyright © 2020 Knowstack. All rights reserved.
//

import Cocoa

@available(OSX 10.12, *)
public extension NSSegmentedControl {

    static func create(_ rect: NSRect, items: [Any]) -> Self {
        let control = Self.init(frame: rect)
        control.segmentStyle = .texturedRounded
        control.trackingMode = .momentary
        
        control.segmentCount = items.count
        
        let width: CGFloat = rect.width/CGFloat(control.segmentCount)
        for e in items.enumerated() {
            if e.element is NSImage {
                control.setImage((e.element as! NSImage), forSegment: e.offset)
            } else {
                control.setLabel(e.element as! String, forSegment: e.offset)
            }
            control.setWidth(width, forSegment: e.offset)
        }
        return control;
    }
}
