//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Николай Жирнов on 17.10.2024.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?) 
}