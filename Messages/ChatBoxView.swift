//
//  ChatBoxView.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/10.
//

import SwiftUI

struct ChatBoxView: View
{
    
    @State var typedMessage: String = ""
    var username = ""
    var userImage = ""
    @ObservedObject var message = MessagesObserver()
    
    var body: some View
    {
        VStack
            {
                ScrollView(showsIndicators: false)
                    {
                        ForEach(message.messages)
                        { each in
                            if each.name == self.username
                            {
                                MessageRow(userImage: each.image, myMessage: true, message: each.message)
                            }
                            else
                            {
                                MessageRow(userImage: each.image, myMessage: false, message: each.message)
                            }
                        }
                }
                
                
                Spacer()
                
                HStack
                    {
                        
                        TextField("Type Here", text: $typedMessage)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            self.message.addMessage(message: self.typedMessage, user: self.username, image: self.userImage)
                            self.typedMessage = ""
                        })
                        {
                            Text("Send")
                        }
                }
                .navigationBarTitle(Text(username), displayMode: .inline)
        }
        .padding()
    }
}
