//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Николай Жирнов on 21.10.2024.
//

import Foundation

struct GameResult: Codable { // Подписываем под протокол Codable, чтоб использовать сериализацию
    let correct: Int
    let total: Int
    let date: Date
    
// метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
