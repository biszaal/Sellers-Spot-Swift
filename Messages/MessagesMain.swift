import SwiftUI
import SDWebImageSwiftUI

struct MessagesMain: View
{
    @State private var userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @Binding var hideTabBar: Bool
    
    @ObservedObject var user = UserDataObserver()
    @ObservedObject var messageData = MessagesObserver()
    
    var body: some View
    {
            NavigationView
            {
                List(messageData.messageList)
                {   each in

                    NavigationLink(destination:
                                    ChatBoxView(userId: each.userOne, sendToId: each.userTwo)
                                    // hiding the tab bar while texting
                                    .onAppear()
                                    {
                                            hideTabBar = true
                                    }
                                    
                                    .onDisappear()
                                    {
                                            hideTabBar = false
                                    })
                    {
                        HStack
                        {
                            MessagesListView(userId: each.userOne == userId ? each.userTwo : each.userOne, message: each.message, time: each.time)
                        }
                    }
                }
                .navigationTitle("Messages")
            }
            .onAppear()
            {
                messageData.fetchList()
            }
        
//        Text("😉 Coming Soon...")
//            .font(.largeTitle)
//            .foregroundColor(.yellow) // everytime users sees this will be different color
//
    }
}
