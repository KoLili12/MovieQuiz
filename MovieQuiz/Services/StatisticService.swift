//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Николай Жирнов on 21.10.2024.
//

import Foundation


class StatisticService: StatisticServiceProtocol {
    func store(game: GameResult) {
        self.correctAnswers += game.correct
        gamesCount += 1
        if game.isBetterThan(bestGame) {
            bestGame = game
        }
    }
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
    }
    
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correct.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    private let storage: UserDefaults = .standard
    
    var gamesCount: Int {
        get {
            // Добавьте чтение значения из UserDefaults
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            // Добавьте запись значения newValue из UserDefaults
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
     
    var bestGame: GameResult {
        get {
            guard let res = storage.dictionary(forKey: Keys.bestGame.rawValue) else {return GameResult(correct: 0, total: 0, date: Date())}
            return GameResult(correct: Int(res["correct"] as? Int ?? 0), total: Int(res["total"] as? Int ?? 0), date: res["date"] as? Date ?? Date())
        }
        set {
            let res = ["correct": newValue.correct, "total": newValue.total, "date": newValue.date] as [String: Any]
            storage.set(res, forKey: Keys.bestGame.rawValue)
        }
    }
     
    var totalAccuracy: Double {
        let res: Double = correctAnswers > 0 ? (Double(correctAnswers) / (Double(10 * gamesCount))) * 100 : 0
        return Double(round(100 * res) / 100)
    }
 }

