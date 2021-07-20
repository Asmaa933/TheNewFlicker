//
//  CustomDropDown.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 20/07/2021.
//

import DropDown

class CustomDropDown: UITextField {
    
    let dropMenu = DropDown()
    private let label = UILabel()
    
    public var dropMenuItems: [String]? {
        get {
            return dropMenu.dataSource
        }
        set {
            dropMenu.dataSource = newValue ?? []
        }
    }
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        setupDropDown()
        setupLabel()
    }
    
    func showLabel() {
        label.isHidden = false
    }
}

fileprivate extension CustomDropDown {
    
    func setupDropDown() {
        dropMenu.bottomOffset = CGPoint(x: 0, y:(self.bounds.height))
        dropMenu.anchorView = self.plainView
    }
    
    
    
    func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = placeholder
        label.textColor = .gray
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: 12)
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 15),
            label.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        ])
    }
}
