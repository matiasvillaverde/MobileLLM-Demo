import Foundation
import Facade
import LLM

final class ModelSelectorViewModel: ObservableObject {

    private let model = MobileLLM.shared

    func load(model url: URL) {

        let parrameters = ModelParameters(maximumContext: 4096, parts: -1, seed: 4294967295, numberOfThreads: 12, customPromptFormat: "USER: {{prompt}}\n\nAssistant:", stopPrompts: ["USER"], numberOfBatch: 512, temperature: 0.9, topK: 40, topP: 0.95, tfsZ: 1, typicalP: 1, repeatPenalty: 1.1, repeatLastNumber: 64, penaltyFrequence: 0, penaltyPresence: 0, penalizeNL: false)

        do {
            try model.load(model: url, parameters: parrameters, type: .rwkv)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
