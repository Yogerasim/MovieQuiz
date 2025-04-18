import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {
    
    // MARK: - Private Properties
    
    private let storage = UserDefaults.standard

    private enum Keys {
        static let gamesCount = "gamesCount"
        static let bestGameCorrect = "bestGame.correct"
        static let bestGameTotal = "bestGame.total"
        static let bestGameDate = "bestGame.date"
        static let totalCorrectAnswers = "totalCorrectAnswers"
        static let totalQuestions = "totalQuestions"
    }
    
    // MARK: - Public Computed Properties

    var gamesCount: Int {
        get { storage.integer(forKey: Keys.gamesCount) }
        set { storage.set(newValue, forKey: Keys.gamesCount) }
    }

    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect)
            let total = storage.integer(forKey: Keys.bestGameTotal)
            let date = storage.object(forKey: Keys.bestGameDate) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect)
            storage.set(newValue.total, forKey: Keys.bestGameTotal)
            storage.set(newValue.date, forKey: Keys.bestGameDate)
        }
    }

    var totalAccuracy: Double {
        let correct = storage.integer(forKey: Keys.totalCorrectAnswers)
        let total = storage.integer(forKey: Keys.totalQuestions)
        return total == 0 ? 0 : (Double(correct) / Double(total)) * 100
    }
    
    // MARK: - Public Methods

    func store(correct count: Int, total amount: Int) {
        gamesCount += 1

        let newCorrect = storage.integer(forKey: Keys.totalCorrectAnswers) + count
        let newTotal = storage.integer(forKey: Keys.totalQuestions) + amount

        storage.set(newCorrect, forKey: Keys.totalCorrectAnswers)
        storage.set(newTotal, forKey: Keys.totalQuestions)

        let currentGame = GameResult(correct: count, total: amount, date: Date())
        if currentGame.correct > bestGame.correct {
            bestGame = currentGame
        }
    }
}
