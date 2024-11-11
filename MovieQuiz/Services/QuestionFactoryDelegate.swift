//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Николай Жирнов on 17.10.2024.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
