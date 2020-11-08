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
    @State var messagesDetails = [MessagesDetails]()
    @State var messageLinks: [String] = []
    @State var showEmptyText: Bool = false
    
    @State var showDeleteAlert: Bool = false
    @State var deleteChatId: String = ""
    
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
                            MessagesListView(message: each)
                                .onLongPressGesture
                                {
                                    self.showDeleteAlert = true
                                    self.deleteChatId = each.id
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
        
        .alert(isPresented: self.$showDeleteAlert)
        {
            Alert(title: Text("Delete"), message: Text("Are you sure you want to delete the chat?"), primaryButton: .destructive(Text("Delete")) {
                deleteData(chatId: deleteChatId)
            }, secondaryButton: .cancel())
            //deleteData(chatId: deleteChatId)
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
    
    func deleteData(chatId: String)
    {
        var userOne: String = ""
        var userTwo: String = ""

        messageObserver.fetchList(chatId: chatId)
        { messages in
            userOne = messages.userOne
            userTwo = messages.userTwo
            
            // checking with an if statement before deleting is important here because complition handler runs one extra time and when the data is deleted in the first time it will show error on the second time because the child is empty
            
            // deleting from chat Location
            if messages.id != ""
            {
                let db = Firestore.firestore()
                db.collection("messages").document(messages.id).delete
                { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully Deleted")
                    }
                }
            }
            
            //deleting from each user's location
            if userTwo != ""
            {
                Database.database().reference().child("users").child(userOne).child("messageLinks").child(userTwo).setValue(nil)
            }
            
            if userTwo != ""
            {
                Database.database().reference().child("users").child(userTwo).child("messageLinks").child(userOne).setValue(nil)
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
