import SwiftUI
import Facade

struct ModelSelectorView: View {

    @State private var model_url: URL?
    @EnvironmentObject var viewModel: ModelSelectorViewModel

    @State private var isFilePickerPresented = false
    @State private var selectedFileURL: URL?
    @State private var sandboxFileURL: URL?
    @State private var showingAlert = false
    @State private var loading = false

    var body: some View {
        VStack {

            if loading {
                ProgressView()
            } else {
                Button("Pick a File") {
                    isFilePickerPresented = true
                }
                .fileImporter(
                    isPresented: $isFilePickerPresented,
                    allowedContentTypes: [.item],
                    allowsMultipleSelection: false) { result in
                    switch result {
                    case .success(let urls):
                        guard let url = urls.first else { return }
                        selectedFileURL = url
                        model_url = url
                    case .failure(let error):
                        print("Error picking file: \(error)")
                    }
                }
                .padding()
                .font(.largeTitle)
                .padding()

                Button("Load model") {
                    loading = true
                    guard let url = model_url else { return }
                    viewModel.load(model: url)
                    loading = false
                    showingAlert = true
                }
                .font(.largeTitle)
                .padding()
                .alert("Model loaded in memory", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
        }
    }
}
