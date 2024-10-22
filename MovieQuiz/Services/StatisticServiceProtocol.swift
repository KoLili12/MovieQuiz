//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Николай Жирнов on 21.10.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: String { get }
    
    func store(game: GameResult)
}
