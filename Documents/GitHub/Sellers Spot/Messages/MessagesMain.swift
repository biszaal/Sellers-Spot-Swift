import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct MessagesMain: View
{
    @State private var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var userImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
    @Binding var hideTabBar: Bool
    
    @ObservedObject var userObserver = UserDataObserver()
    @ObservedObject var messageObserver = MessagesObserver()

    @State var messageConnection: [String] = []
    @State var messageLink: [String] = []
    @State var showEmptyText: Bool = false
    
    @State var showDeleteAlert: Bool = false
    @State var deleteIndex: Int = -1
    
    var body: some View
    {
        NavigationView
        {
            Group
            {
                if messageConnection.isEmpty
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
                    List
                    {
                        ForEach(messageLink.indices, id: \.self)
                        { each in
                            NavigationLink(destination:
                                            ChatBoxView(theirId: messageConnection[each], chatId: messageLink[each])
                                            //hiding the tab bar while texting
                                            .onAppear()
                                            {
                                                withAnimation
                                                {
                                                    hideTabBar = true
                                                }
                                            }
                                            
                                            .onDisappear()
                                            {
                                                withAnimation
                                                {
                                                    hideTabBar = false
                                                }
                                            })
                            {
                                MessagesListView(theirId: messageConnection[each], chatId: messageLink[each])
                            }
                        }.onDelete
                        { index in
                            self.deleteIndex = index.first!
                            self.showDeleteAlert = true
                        }
                    }
                }
            }
            .navigationTitle("Messages")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        .onAppear()
        {
            self.loadData()
        }
        
        .alert(isPresented: self.$showDeleteAlert)
        {
            Alert(title: Text("Delete"), message: Text("Are you sure you want to delete the chat?"), primaryButton: .destructive(Text("Delete")) {
                deleteData(chatId: self.messageLink[deleteIndex])
            }, secondaryButton: .cancel())
        }
    }
    
    func loadData()
    {
        // Getting all the chat box locations for my user
        messageObserver.getMessageLink(userId: myId)
        { messageLink, messageConnection in
            self.messageLink = messageLink
            self.messageConnection = messageConnection
        }
    }
    
    func deleteData(chatId: String)
    {
        Database.database().reference().child("users").child(myId).child("messageLink").child(chatId).removeValue()
        Database.database().reference().child("users").child(messageConnection[deleteIndex]).child("messageLink").child(chatId).removeValue()
    }
}
