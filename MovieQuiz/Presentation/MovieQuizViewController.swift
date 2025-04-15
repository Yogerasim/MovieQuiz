import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    // MARK: - Properties

    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var currentQuestion: QuizQuestion?
    private let questionsAmount = 10
    private var questionFactory: QuestionFactory = QuestionFactory()
    private var alertPresenter: AlertPresenter?

    // MARK: - Outlets

    @IBOutlet private weak var questionCounterLabel: UILabel!
    @IBOutlet private weak var questionTitleTextLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var questionTextLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        questionFactory.setup(delegate: self)
        alertPresenter = AlertPresenter(viewController: self)
        startNewGame()
    }

    // MARK: - UI Setup

    private func setupUI() {
        if let mediumFont = UIFont(name: "YSDisplay-Medium", size: 20) {
            yesButton.titleLabel?.font = mediumFont
            noButton.titleLabel?.font = mediumFont
            questionTitleTextLabel.font = mediumFont
            questionCounterLabel.font = mediumFont
        }

        if let boldFont = UIFont(name: "YSDisplay-Bold", size: 23) {
            questionTextLabel.font = boldFont
        }

        yesButton.setTitle("Да", for: .normal)
        noButton.setTitle("Нет", for: .normal)
        questionTitleTextLabel.text = "Вопрос:"

        movieImageView.layer.cornerRadius = 20
        movieImageView.layer.masksToBounds = true
    }

    // MARK: - Actions

    
    @IBAction func noButtonTapped(_ sender: Any) {
        handleAnswer(givenAnswer: false)
    }
    @IBAction func yesButtonTapped(_ sender: Any) {
        handleAnswer(givenAnswer: true)
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(_ question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async {
            self.show(quizStep: viewModel)
        }
    }

    // MARK: - Game Logic

    private func startNewGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory.reset()
        setButtonsEnabled(true)
        questionFactory.requestNextQuestion()
    }

    private func handleAnswer(givenAnswer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let isCorrect = (givenAnswer == currentQuestion.correctAnswer)
        showAnswerResult(isCorrect: isCorrect)
    }

    private func showAnswerResult(isCorrect: Bool) {
        setButtonsEnabled(false)

        if isCorrect {
            correctAnswers += 1
        }

        movieImageView.layer.borderWidth = 8
        movieImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let resultViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questionsAmount)",
                buttonText: "Сыграть ещё раз"
            )
            show(quiz: resultViewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }

    private func show(quizStep: QuizStepViewModel) {
        movieImageView.image = quizStep.image
        questionTextLabel.text = quizStep.question
        questionCounterLabel.text = quizStep.questionNumber

        movieImageView.layer.borderWidth = 0
        movieImageView.layer.borderColor = UIColor.clear.cgColor

        setButtonsEnabled(true)
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ) { [weak self] in
            guard let self = self else { return }
            self.startNewGame()
            self.movieImageView.layer.borderWidth = 0
        }

        alertPresenter?.showAlert(model: alertModel)
    }

    private func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let formattedText = model.text.replacingOccurrences(of: "фильма ", with: "фильма\n")
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: formattedText,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
}
