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
            if let data = storage.data(forKey: Keys.bestGame.rawValue),
               let gameResult = try? JSONDecoder().decode(GameResult.self, from: data) {
                return gameResult
            }
            return GameResult(correct: 0, total: 0, date: Date())
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                storage.set(encodedData, forKey: Keys.bestGame.rawValue)
            }
        }
    }

     
    var totalAccuracy: Double {
        correctAnswers > 0 ? Double(correctAnswers) / (Double(10 * gamesCount)) : 0
    }
 }

