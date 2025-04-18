import Foundation

class StatisticService: StatisticServiceProtocol {
    var gamesCount: Int = 0
    
    var bestGame: GameResult
    
    var totalAccuracy: Double = 0.0
    
    func store(correct count: Int, total amount: Int) {
        
    }
    init(gamesCount: Int, bestGame: GameResult, totalAccuracy: Double) {
        self.gamesCount = gamesCount
        self.bestGame = bestGame
        self.totalAccuracy = totalAccuracy
    }
}
