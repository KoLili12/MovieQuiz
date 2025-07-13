//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Николай Жирнов on 17.10.2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: (UIViewController & AlertDelegate)? // сделал слабой ссылкой
    
    init(delegate: (UIViewController & AlertDelegate)?) {
        self.delegate = delegate
    }
    
    func presentAlert(modelPr: AlertModel) {
        let alert = UIAlertController(
            title: modelPr.title,
            message: modelPr.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Alert"
        
        let action = UIAlertAction(title: modelPr.buttonTitle, style: .default) { [weak delegate] _ in
            delegate?.didReceiveResultAlert()
        }

        alert.addAction(action)

        delegate?.present(alert, animated: true, completion: nil)
    }
}
