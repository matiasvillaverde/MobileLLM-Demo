import SwiftUI
import Foundation
import Facade

struct Note: Identifiable, Codable {
    var id = UUID()
    var title: String
    var text: String
}

struct NotesListView: View {
    @EnvironmentObject var notes: NotesViewModel
    @EnvironmentObject var chat: ChatViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(notes.notes) { note in
                        CardView(note: note, deleteAction: {
                            notes.delete(note: note)
                        })
                    }
                }
                .padding()
            }
            .navigationBarTitle("Notes")
            .navigationBarItems(trailing: NavigationLink(destination: NewNoteView().environmentObject(chat)) {
                Image(systemName: "plus")
            })
        }
    }
}

struct CardView: View {
    let note: Note
    let deleteAction: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(note.title)
                    .font(.headline)
                Spacer()
                Button(action: deleteAction) {
                    Image(systemName: "trash")
                }
            }
            .padding(.bottom, 10)
            Text(note.text)
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground)) // dynamic background color
        .cornerRadius(10)
        .shadow(color: Color(.label).opacity(0.33), radius: 5)
    }
}

struct NewNoteView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var text = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TextField("Title", text: $title)
                    .font(.largeTitle)
                    .padding()

                TextEditor(text: $text)
                    .frame(minHeight: 200)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )

                Button(action: {
                    let note = Note(title: title, text: text)
                    viewModel.add(note: note)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add Note")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}
