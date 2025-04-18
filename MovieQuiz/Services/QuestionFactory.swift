import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    // MARK: - Delegate
    private weak var delegate: QuestionFactoryDelegate?
    
    
    // MARK: - Properties
    private var currentIndex = 0
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма меньше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма меньше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма меньше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма меньше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма меньше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма меньше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма меньше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма меньше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма меньше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма меньше чем 6?", correctAnswer: false)
    ]
    
    // MARK: - Public metods
    
    func setup(delegate: QuestionFactoryDelegate) {
            self.delegate = delegate
        }
    func requestNextQuestion() {
            guard currentIndex < questions.count else {
                delegate?.didReceiveNextQuestion(nil)
                return
            }

            let question = questions[currentIndex]
            currentIndex += 1

            delegate?.didReceiveNextQuestion(question)
        }

        func reset() {
            currentIndex = 0
        }
}
