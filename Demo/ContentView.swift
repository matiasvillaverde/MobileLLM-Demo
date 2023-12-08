import SwiftUI

struct ContentView: View {

    @State private var selectedTab = 0
    @State private var chat = ChatViewModel()
    @State private var notes = NotesViewModel()
    @State private var modelSelector = ModelSelectorViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            NotesListView()
                .environmentObject(notes)
                .environmentObject(chat)
                .tabItem {
                    Image(systemName: "pencil.and.list.clipboard")
                    Text("Notes")
                }
                .tag(0)
            ChatView()
                .environmentObject(chat)
                .tabItem {
                    Image(systemName: "message.circle.fill")
                    Text("Chat")
                }
                .tag(1)
            ModelSelectorView()
                .environmentObject(modelSelector)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Models")
                }
                .tag(2)
        }
    }
}
