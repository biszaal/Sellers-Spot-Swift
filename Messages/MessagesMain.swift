import SwiftUI
import SDWebImageSwiftUI

struct MessagesMain: View
{
    @State private var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @Binding var hideTabBar: Bool
    
    @ObservedObject var userObserver = UserDataObserver()
    @ObservedObject var messageObserver = MessagesObserver()

    @State var messagesDetails = [MessagesDetails]()
    @State var messageLinks: [String] = []
    
    var body: some View
    {
        NavigationView
        {
            List(messagesDetails, id: \.self)
            { each in
                
                NavigationLink(destination: Text("")
                               //ChatBoxView(userId: each.userOne, sendToId: each.userTwo)
                               // hiding the tab bar while texting
                               //                                    .onAppear()
                               //                                    {
                               //                                            hideTabBar = true
                               //                                    }
                               //
                               //                                    .onDisappear()
                               //                                    {
                               //                                            hideTabBar = false
                               //                                    }
                )
                {
                    HStack
                    {
                        MessagesListView(message: each)
                    }
                }
            }
            .navigationTitle("Messages")
        }
        .onAppear()
        {
            // Getting all the chat box location for my user
            userObserver.getChatLocation(userId: myId)
            { (newmessageLinks) in
                self.messageLinks = newmessageLinks
                
                for each in messageLinks
                {
                    // from evey chat location fetching the text, users ID and time
                    messageObserver.fetchList(chatId: each)
                    { newmessage in
                        let otherPersonId = myId == newmessage.userOne ? newmessage.userTwo : newmessage.userOne
                        
                        // after we got the userID we need to get the user info using that ID
                        userObserver.getUserDetails(id: otherPersonId)
                        { user in
                            messagesDetails.append(MessagesDetails(id: newmessage.id, userName: user.name, userImage: user.image, message: newmessage.message, time: newmessage.time))
                        }
                    }
                }
            }
        }
    }
}

struct MessagesDetails: Hashable
{
    var id: String
    var userName: String
    var userImage: String
    var message: String
    var time: Date
}
