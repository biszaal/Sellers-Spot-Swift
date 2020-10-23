//
//  ChatBoxView.swift
//  Sellers Spot
//
//  Created by Bishal Aryal on 20/9/10.
//

import SwiftUI

struct ChatBoxView: View
{
    
    var userId: String
    var sendToId: String
    
    @State var myImage: String = ""
    @State var senderImage:String = ""
    
    @State var typedMessage: String = ""
    @ObservedObject var message = MessagesObserver()
    @ObservedObject var user = UserDataObserver()
    
    @State var value: CGFloat = 0
    @State var numberOfMessages: Int = 10
    @State var showSeeMore: Bool = true
    @State var openingViewFirstTime: Bool = false
    
    var body: some View
    {
        ScrollViewReader
        {   reader in
            
            VStack
            {
                ScrollView(showsIndicators: false)
                {
                        Button(action:
                                {
                                    numberOfMessages += 3
                                    message.fetchData(numberOfMessages, firstId: userId, secondId: sendToId)
                                })
                        {
                            Text("See more...")
                                .font(.caption)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(30)
                        }
                    
                    ForEach(message.messages)
                    { each in
                            MessageRow(userId: each.id, sendToId: each.sendToId, message: each.message)
//                        Text(each.message)
                    }
                    .onAppear()
                    {
                        if openingViewFirstTime
                        {       // scroll to the bottom when open
                            reader.scrollTo(message.messages.last!.id, anchor: .bottom)
                            openingViewFirstTime = false
                        }
                    }
                }
                .onAppear()
                {
                    openingViewFirstTime = true
                    message.fetchData(numberOfMessages, firstId: userId, secondId: sendToId)
                }
                
                Spacer()
                
                HStack
                {
                    
                    TextEditor(text: $typedMessage)
                        .frame(height: 40)
                        .padding(.horizontal, 15)
                        .overlay(Capsule().stroke(Color.secondary, lineWidth: 2))
                    
                    Button(action: {
                        self.message.addMessage(userId: userId, SendToId: sendToId, message: typedMessage)
                        self.typedMessage = ""
                        reader.scrollTo(message.messages.last?.id, anchor: .bottom)
                        message.fetchData(numberOfMessages, firstId: userId, secondId: sendToId)
                    })
                    {
                        Text("Send")
                    }
                }
                .navigationBarTitle(Text(sendToId), displayMode: .inline)
                
                .onTapGesture
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
                    {
                        withAnimation
                        {
                            reader.scrollTo(message.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
