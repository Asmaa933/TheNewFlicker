//
//  UIcollectionViewExtension.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 17/07/2021.
//

import UIKit

extension UICollectionView {
    func registerCellNib<Cell: UICollectionViewCell>(cellClass: Cell.Type) {
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: Cell.self))
    }

    func dequeue<Cell: UICollectionViewCell>(indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)

        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error in cell")
        }
        return cell
    }

    func setEmptyView(with image: UIImage, title: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let imageView = UIImageView(image: image)
        let titleLabel = UILabel()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = #colorLiteral(red: 0.7254901961, green: 0.7176470588, blue: 0.7333333333, alpha: 1)
        titleLabel.text = title
        emptyView.addSubview(imageView)
        emptyView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -10),
            imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
        ])

        UIView.animate(withDuration: 1, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (_) in
                UIView.animate(withDuration: 1, animations: {
                    imageView.transform = CGAffineTransform.identity
                })
            })
        })

        self.backgroundView = emptyView
    }

    func restore() {
        self.backgroundView = nil
    }

}
