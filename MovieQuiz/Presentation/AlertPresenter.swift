//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Tatsiana Kulikova on 20.04.2023.
//

import UIKit

final class AlertPresenter {
    
    // MARK: - Properties
    
    private let model: AlertModel
    private weak var viewController: UIViewController?
    
    // MARK: - Initializers
    
    init(model: AlertModel, viewController: UIViewController) {
        self.model = model
        self.viewController = viewController
    }
    
    // MARK: - Methods
    
    func present() {
        guard let viewController else { return }
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { [model] _ in
            model.completion()
        }
        
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
    
}
