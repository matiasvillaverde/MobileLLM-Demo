import Facade
import SwiftUI

final class NotesViewModel: ObservableObject {

    private let model = MobileLLM.shared

    @Published var notes = [Note]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(notes) {
                UserDefaults.standard.set(encoded, forKey: "Notes")
            }
        }
    }

    init() {
        if let notes = UserDefaults.standard.data(forKey: "Notes") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Note].self, from: notes) {
                self.notes = decoded
                return
            }
        }
        self.notes = []
    }

    @MainActor func add(note: Note) {
        notes.append(note)
        do {
            try model.add(document: note.text)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    @MainActor func delete(note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            do {
                try model.delete(document: note.text)
            } catch {
                fatalError(error.localizedDescription)
            }
            notes.remove(at: index)
        }
    }
}
