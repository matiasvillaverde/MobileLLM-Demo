import Foundation
import Facade
import SwiftUI

protocol ChatViewModelDelegate {
    func reply(token: String)
}

final class ChatViewModel: ObservableObject {

    private let model = MobileLLM.shared
    var delegate: ChatViewModelDelegate?

    public func predictStream(_ input: String) async throws -> (String, Double) {
        try await model.ask(question: input, similarityThreshold: 0.1)
    }
}
