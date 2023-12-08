import SwiftUI

struct ChatView: View {

    @State private var inputText: String = ""
    @State private var messages: [Message] = []

    @EnvironmentObject var model: ChatViewModel

    var body: some View {
    VStack {
        ScrollView {
            LazyVStack {
                ForEach(messages) { message in
                    MessageView(message: message)
                }
            }
        }
        .padding()

        HStack {
            TextField("Enter message", text: $inputText)
                .padding(10)
                .background(Color(.systemBackground)) // dynamic background color
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .padding(.horizontal)

            Button(action: {
                Task {

                    let userMessage = Message(text: inputText, isFromUser: true)
                    messages.append(userMessage)
                    let temporaryInput = inputText
                    inputText = ""

                    Task {
                        var message = ""
                        do {
                            let (prediction, _) = try await model.predictStream(temporaryInput)
                            message = prediction
                        } catch {
                            message = error.localizedDescription
                        }
                        let aiMessage = Message(text: message, isFromUser: false)
                        messages.append(aiMessage)
                        print(message)
                    }
                }
            }) {
                Text("Send")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }
    .background(Color(.systemBackground))
    .onTapGesture {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    }
}

struct MessageView: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.slide)
            } else {
                Text(message.text)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.slide)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
}
