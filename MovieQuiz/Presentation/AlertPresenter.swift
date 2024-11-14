//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Николай Жирнов on 17.10.2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var deligate: (UIViewController & AlertDeligate)? // сделал слабой ссылкой
    
    init(deligate: (UIViewController & AlertDeligate)?) {
        self.deligate = deligate
    }
    
    func presentAlert(modelPr: AlertModel) {
        let alert = UIAlertController(
            title: modelPr.title,
            message: modelPr.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Alert"
        
        let action = UIAlertAction(title: modelPr.buttonTitle, style: .default) { [weak deligate] _ in
            deligate?.didReceiveResultAlert()
        }

        alert.addAction(action)

        deligate?.present(alert, animated: true, completion: nil)
    }
}
