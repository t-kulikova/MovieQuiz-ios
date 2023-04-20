//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Tatsiana Kulikova on 20.04.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
