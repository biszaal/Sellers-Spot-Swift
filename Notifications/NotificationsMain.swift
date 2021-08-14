//
//  FriendsMain.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on २०/१०/१२.
//  Copyright © 2020 Bishal Aryal. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine
import Firebase

struct NotificationsMain: View
{
    @ObservedObject var notificationObserver = NotificationObserver()
    @ObservedObject var userObserver = UserDataObserver()
    
    @State var notifications: [NotificationDetails] = [NotificationDetails]()
    
    var body: some View
    {
        NavigationView
        {
            
            ScrollView
            {
                ForEach(notifications)
                { notification in
                    EachNotification(notification: notification)
                    
                }
            }
            .navigationTitle("Notifications")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear()
        {
            notificationObserver.fetchData(notificationData: notifications)
            { notifications in
                self.notifications.insert(contentsOf: notifications, at: 0)
            }
        }
    }
}
