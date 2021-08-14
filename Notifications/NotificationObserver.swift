//
//  NotificationObserver.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 09/08/2021.
//  Copyright © 2021 Bishal Aryal. All rights reserved.
//

import Firebase

class NotificationObserver: ObservableObject
{
    var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    var dateFormatter = DateFormatter()
    
    func fetchData(notificationData: [NotificationDetails], completionHandler: @escaping (_ messages: [NotificationDetails]) -> ())
    {
        let db = Firestore.firestore()
        let lastNotification = notificationData.first
        var queryData: Query
        
        if lastNotification == nil
        {
            queryData = db.collection("users").document(myId).collection("notifications").order(by: "time").limit(toLast: 20)
        }
        else
        {
            let lastTimeStamp = lastNotification!.time.description
            queryData = db.collection("users").document(myId).collection("notifications").order(by: "time").end(at: [lastTimeStamp]).limit(toLast: 20)
        }
        
        queryData.addSnapshotListener
        { (snap, err) in
            
            var tempNotification = [NotificationDetails]()
            
            if err != nil
            {
                print((err?.localizedDescription)!)
            }
            
            guard let snap = snap else {
                return
            }
            
            for i in snap.documentChanges
            {
                if i.type == .added
                {
                    let id = i.document.documentID as String
                    let event = i.document.get("event") as? String ?? ""
                    let postId = i.document.get("postId") as? String ?? ""
                    let time = i.document.get("time") as? String ?? ""
                    let uid = i.document.get("uid") as? String ?? ""
                    
                    if id != lastNotification?.id
                    {
                        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        let time = self.dateFormatter.date(from:String(time)) ?? Date()
                        
                        tempNotification.insert(NotificationDetails(id: id, event: event, postId: postId, time: time, uid: uid), at: 0)
                    }
                }
            }
            return(completionHandler(tempNotification))
        }
    }
}
