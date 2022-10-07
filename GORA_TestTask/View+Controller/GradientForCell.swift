//
//  GradientCell.swift
//  GORA_TestTask
//
//  Created by Kirill Drozdov on 13.06.2022.
//

import UIKit

final class GradientCellBacground: UIView {

    private let gradient = CAGradientLayer()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }

    private func setupGradient() {
        self.layer.addSublayer(gradient)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
    }
}
