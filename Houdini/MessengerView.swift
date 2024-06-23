import SwiftUI

struct Chat: Identifiable {
    let id = UUID()
    let name: String
    let message: String
    let time: String
    let imageName: String
    var messages: [Message]

    mutating func addMessage(_ text: String, isSentByCurrentUser: Bool) {
        let message = Message(text: text, isSentByCurrentUser: isSentByCurrentUser)
        messages.append(message)
    }
}
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isSentByCurrentUser: Bool
}
struct ChatDetailView: View {
    @State private var newMessageText = ""
    @Binding var chat: Chat
    var body: some View {
        VStack {
            ScrollView {
                ForEach(chat.messages) { message in
                    MessageView(message: message)
                }
            }
            .padding()

            Divider()

            HStack {
                TextField("Type a message", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    sendMessage()
                }) {
                    Text("Send")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.trailing)
            }
            .padding()

            Spacer()
        }
        .navigationTitle(chat.name)
    }

    private func sendMessage() {
        guard !newMessageText.isEmpty else { return }
        chat.addMessage(newMessageText, isSentByCurrentUser: true)
        newMessageText = ""
    }
}
struct MessageView: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isSentByCurrentUser {
                Spacer()
            }
            Text(message.text)
                .padding(10)
                .foregroundColor(.white)
                .background(message.isSentByCurrentUser ? Color(hex: "EB1D36") : Color.gray)
                .cornerRadius(8)
            if !message.isSentByCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
struct MessengerView: View {
    @State private var chats: [Chat] = [
        Chat(name: "John Doe", message: "Hey, how are you?", time: "12:34 PM", imageName: "person1", messages: [
            Message(text: "Hi John!", isSentByCurrentUser: true),
            Message(text: "I'm good, thanks!", isSentByCurrentUser: false)
        ]),
        Chat(name: "Jane Smith", message: "Let's catch up later.", time: "11:20 AM", imageName: "person2", messages: [
            Message(text: "Sure, when?", isSentByCurrentUser: true),
            Message(text: "Tomorrow afternoon?", isSentByCurrentUser: false)
        ]),
    ]

    @State private var selectedChat: Chat?

    var body: some View {
        NavigationView {
            List(chats) { chat in
                Button(action: {
                    selectedChat = chat
                }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(chat.name)
                            .font(.headline)
                        Text(chat.message)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Chats")
            .sheet(item: $selectedChat) { chat in
                NavigationView {
                    ChatDetailView(chat: $chats.first(where: { $0.id == chat.id })!)
                        .navigationBarItems(trailing:
                            Button("Close") {
                                selectedChat = nil
                            }
                        )
                }
            }
        }
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleChat = Chat(name: "John Doe", message: "Hey", time: "12:00 PM", imageName: "person1", messages: [])
        return ChatDetailView(chat: .constant(sampleChat))
    }
}
