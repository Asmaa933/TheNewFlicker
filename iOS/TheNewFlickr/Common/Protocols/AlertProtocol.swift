//
//  AlertProtocol.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 26/09/2021.
//

import UIKit

protocol AlertProtocol {
    func showAlert(message: String)
}

extension AlertProtocol where Self: UIViewController {
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default)
        alert.addAction(action)
        DispatchQueue.main.async {[weak self] in
            self?.present(alert, animated: true)
        }
    }
}
