//
//  SafariExtensionHandler.swift
//  NoGoofingOffTimerSafariExt
//
//  Created by John Thywissen on 2018/10/18.
//  Copyright © 2018 John Thywissen. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    class func reloadOurContentBlocker() {
        UserDefaults.standard.set(Date(), forKey: "lastReloadedDate")
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: "org.thywissen.john.NoGoofingOff.NoGoofingOffBlocker") {error in
            guard error == nil else {
                NSLog("SFContentBlockerManager.reloadContentBlocker: error: "+error.debugDescription)
                return
            }
        }
    }
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            if (messageName == "NoGoofingOffTimerSafariExtPeriodicMessage") {
                let lastReloadedDate = UserDefaults.standard.object(forKey: "lastReloadedDate") as? Date
                if (lastReloadedDate == nil) {
                    SafariExtensionHandler.reloadOurContentBlocker()
                } else {
                    let userCal = Calendar.autoupdatingCurrent
                    let currTime0Sec = userCal.nextDate(after: Date(), matching: DateComponents(second: 0), matchingPolicy: .strict, direction: .backward)!
                    let currMinuteOfDay = userCal.component(Calendar.Component.minute, from: currTime0Sec) + userCal.component(Calendar.Component.hour, from: currTime0Sec) * 60
                    let tickIntervalMinutes = 1
                    let minutesToLastTick = currMinuteOfDay % tickIntervalMinutes
                    let lastTick = currTime0Sec.addingTimeInterval(Double(minutesToLastTick) * -60.0)
                    if ((lastReloadedDate!) < lastTick) {
                        SafariExtensionHandler.reloadOurContentBlocker()
                    }
                }
            }
        }
    }

}
