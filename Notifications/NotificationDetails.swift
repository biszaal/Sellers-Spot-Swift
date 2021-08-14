//
//  NotificationDetails.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 09/08/2021.
//  Copyright © 2021 Bishal Aryal. All rights reserved.
//

import Foundation

struct NotificationDetails: Identifiable
{
    var id: String
    var event: String
    var postId: String
    var time: Date
    var uid: String
}
