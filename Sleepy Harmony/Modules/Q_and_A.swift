import Foundation

struct QuestionAnswer: Identifiable {
    let id = UUID()
    let textOne: String
    var textTwo: [QuestionAnswer]?
}

extension QuestionAnswer {
    var hasChildren: Bool { !(textTwo?.isEmpty == true) }
}
