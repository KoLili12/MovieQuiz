//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Николай Жирнов on 17.10.2024.
//

struct AlertModel {
    let title: String
    let message: String
    let buttonTitle: String
    let comletion: (() -> Void)?
}
