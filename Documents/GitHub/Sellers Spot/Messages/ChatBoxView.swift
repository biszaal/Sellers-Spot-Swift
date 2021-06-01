import SwiftUI
import Combine

struct ChatBoxView: View
{
    var theirId: String
    var chatId: String
    
    @State var messagesData = [MessagesDataType]()
    
    @State var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    @State var myImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
    @State var theirImage: String = ""
    @State var theirName: String = ""
    
    @State var typedMessage: String = ""
    @ObservedObject var messageObserver = MessagesObserver()
    @ObservedObject var userObserver = UserDataObserver()
    
    @State var value: CGFloat = 0
    @State var showSeeMore: Bool = true
    @State var keyboardHeight: CGFloat = 0
    @State var keyboardOn: Bool = false     // check if keyboard is appeared or not
    @State var isScrolled: Bool = false
    
    var body: some View
    {
        ScrollViewReader
        { reader in
            
            VStack
            {
                ScrollView(showsIndicators: false)
                {
                    Button(action:
                            {
                                batchFetching(seeMore: true)
                            })
                    {
                        Text("See more...")
                            .font(.caption)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(30)
                    }
                    
                    ForEach(self.messagesData, id: \.self)
                    { each in
                        MessageRow(userId: each.userId, message: each.message, userImage: self.theirImage)
                            .id(each.id)
                    }.onChange(of: self.messagesData.count, perform:
                                { value in
                                        withAnimation
                                        {
                                            reader.scrollTo(self.messagesData.last!.id,anchor: .bottom)
                                        }
                    })
                    
                    .onAppear()
                    {
                        // scorlling for the first time it opens
                        if !isScrolled
                        {
                            withAnimation
                            {
                                reader.scrollTo(self.messagesData.last!.id,anchor: .bottom)
                                isScrolled = true
                            }
                        }
                    }
                }
                
                // when keyboard appear scroll
                .onChange(of: self.keyboardOn)
                { keyBoardState in
                    if keyBoardState
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
                        {
                            withAnimation
                            {
                                reader.scrollTo(self.messagesData.last!.id,anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            HStack
            {
                
                TextEditor(text: $typedMessage)
                    .frame(height: 40)
                    .padding(.horizontal, 15)
                    .overlay(Capsule().stroke(Color.secondary, lineWidth: 2))
                    .onReceive(Just(typedMessage))
                    { (newValue: String) in
                        self.typedMessage = String(newValue.prefix(1000))
                    }
                    
                    // hide keyboard on drag gesture
                    .gesture(DragGesture().onChanged(
                                { _ in
                                    if keyboardOn
                                    {
                                        UIApplication.shared.endEditing()
                                    }
                                }))
                
                Button(action:
                        {
                            sendMessage()
                        })
                {
                    Text("Send")
                }
            }
            .navigationBarTitle(self.theirName, displayMode: .inline)
        }
        .padding()
        
        .onAppear()
        {
            self.batchFetching()
            
            self.keyboardObserver()
        }
        
    }
    
    func batchFetching(seeMore: Bool? = false)
    {
        //fetching each text messages
        messageObserver.fetchData(chatId: self.chatId, messagesData: self.messagesData)
        { messageData in
            if seeMore!
            {
                self.messagesData.insert(contentsOf: messageData, at: 0)
                
            }
            else
            {
                self.messagesData.append(contentsOf: messageData)
            }
        }
        
        userObserver.getUserDetails(id: self.theirId)
        { user in
            self.theirName = user.name
            self.theirImage = user.image
        }
    }
    
    func sendMessage()
    {
        self.typedMessage = self.typedMessage.trimmingCharacters(in: .whitespacesAndNewlines) // remove empty spaces
        if self.typedMessage != ""
        {
            self.messageObserver.addMessage(chatId: self.chatId, theirId: self.theirId, message: self.typedMessage)
        }
        self.typedMessage = ""
        
    }
    
    // checks if the keyboard is on or off
    func keyboardObserver()
    {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main)
        { (notification) in
            self.keyboardOn = true
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main)
        { (notification) in
            
            self.keyboardOn = false
        }
    }
}
