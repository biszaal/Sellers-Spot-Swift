import SwiftUI
import SDWebImageSwiftUI

struct MessagesMain: View
{
    @State private var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var userImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
    @Binding var hideTabBar: Bool
    
    @ObservedObject var userObserver = UserDataObserver()
    @ObservedObject var messageObserver = MessagesObserver()
    
    @State var messageConnection: [String] = []
    @State var messagesDetails = [MessagesDetails]()
    @State var messageLinks: [String] = []
    @State var showEmptyText: Bool = false
    
    var body: some View
    {
        NavigationView
        {
            Group
            {
                if messagesDetails.isEmpty
                {
                    if showEmptyText
                    {
                        Button(action:
                                {
                            showEmptyText = false
                        })
                        {
                            Text("Empty 🔄")
                                .foregroundColor(.primary)
                        }
                    }
                    else
                    {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .font(.largeTitle)
                                .onAppear()
                                {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5)
                                    {
                                        showEmptyText = true
                                    }
                                }
                    }
                }
                else
                {
                    List(messagesDetails, id: \.self)
                    { each in
                        NavigationLink(destination: ChatBoxView(chatId: each.id)
                                        //hiding the tab bar while texting
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
                                MessagesListView(message: each)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Messages")
        }
        .onAppear()
        {
            self.loadData()
        }
    }
    
    func loadData()
    {
        // Getting all the chat box locations for my user
        userObserver.getUserDetails(id: myId)
        { user in
            self.messageLinks = user.messageId ?? []
            self.messageConnection = user.messageConnection ?? []
            for each in messageLinks.indices
            {
                // from evey chat location fetching the text, users ID and time
                messageObserver.fetchList(chatId: messageLinks[each])
                { newmessage in
                        //after we got the userID we need to get the user info using that ID
                        userObserver.getUserDetails(id: messageConnection[each])
                        { user in
                            messagesDetails.append(MessagesDetails(id: newmessage.id, userName: user.name, userImage: user.image, message: newmessage.message, time: newmessage.time))
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
