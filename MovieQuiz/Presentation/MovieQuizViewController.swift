import UIKit

final class MovieQuizViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFonts()

        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true

        let firstQuestion = questions[currentQuestionIndex]
        let quizStepViewModel = convert(model: firstQuestion)
        show(quizStep: quizStepViewModel)
    }

    // MARK: - Outlets

    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var yesLabel: UIButton!
    @IBOutlet private weak var noLabel: UIButton!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    @IBAction private func noBottonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    // MARK: - Private Methods

    private func setupFonts() {
        if let mediumFont = UIFont(name: "YSDisplay-Medium", size: 20) {
            yesLabel.titleLabel?.font = mediumFont
            noLabel.titleLabel?.font = mediumFont
            questionTitleLabel.font = mediumFont
            counterLabel.font = mediumFont
        } else {
            print("Не удалось загрузить шрифт 'YSDisplay-Medium'")
        }

        if let boldFont = UIFont(name: "YSDisplay-Bold", size: 23) {
            textLabel.font = boldFont
        } else {
            print("Не удалось загрузить шрифт 'YSDisplay-Bold'")
        }

        yesLabel.setTitle("Да", for: .normal)
        noLabel.setTitle("Нет", for: .normal)
        textLabel.text = "Рейтинг этого фильма\nменьше чем 5?"
        questionTitleLabel.text = "Вопрос:"
        counterLabel.text = "1/10"
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let formattedText = model.text.replacingOccurrences(of: "фильма ", with: "фильма\n")
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: formattedText,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }

    private func show(quizStep: QuizStepViewModel) {
        imageView.image = quizStep.image
        textLabel.text = quizStep.question
        counterLabel.text = quizStep.questionNumber
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }

        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз"
            )
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quizStep: viewModel)
        }
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0

            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quizStep: viewModel)

            self.imageView.layer.borderWidth = 0
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Models

    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }

    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }

    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }

    // MARK: - Data

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

    // MARK: - State

    private var currentQuestionIndex = 0
    private var correctAnswers = 0
}
