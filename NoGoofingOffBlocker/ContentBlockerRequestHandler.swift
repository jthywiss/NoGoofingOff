//
//  ContentBlockerRequestHandler.swift
//  NoGoofingOffBlocker
//
//  Created by John Thywissen on 2018/10/18.
//  Copyright © 2018 John Thywissen. All rights reserved.
//

import Foundation

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {

        let userCal = Calendar.autoupdatingCurrent
        let currTime = Date()
        let currHour = userCal.component(.hour, from: currTime)
        let currMinute = userCal.component(.minute, from: currTime)
        let surfAllowable =
            (currHour == 7 && currMinute > 12) ||
            (currHour == 12 && currMinute < 48) ||
            (currHour == 20 && currMinute > 48) ||
            (currHour > 20 && currHour < 22) ||
            (currHour == 22 && currMinute < 48)
//        NSLog("surfAllowable=\(surfAllowable)")

        if (surfAllowable) {
            let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "blockerListAllow", withExtension: "json"))!
            
            let item = NSExtensionItem()
            item.attachments = [attachment]
            
            context.completeRequest(returningItems: [item], completionHandler: nil)
        } else {
            let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "blockerListBlock", withExtension: "json"))!
            
            let item = NSExtensionItem()
            item.attachments = [attachment]
            
            context.completeRequest(returningItems: [item], completionHandler: nil)
        }
    }
    
}
