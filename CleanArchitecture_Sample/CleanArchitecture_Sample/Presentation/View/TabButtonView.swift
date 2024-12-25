//
//  TabButtonView.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/25/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class TabButtonView: UIStackView {
    private let tabList: [TabButtonType]
    private let disposeBag = DisposeBag()
    public let selectedType: BehaviorRelay<TabButtonType?>
    init(tabList: [TabButtonType]) {
        self.tabList = tabList
        self.selectedType = BehaviorRelay(value: tabList.first)
        super.init(frame: .zero)
        alignment = .fill
        distribution = .fillEqually
        
        addButton()
        (arrangedSubviews.first as? UIButton)?.isSelected = true //버튼 초깃값
    }
    
    private func addButton() {
        tabList.forEach { type in
            let button = TabButton(type: type)
            button.rx.tap.bind { [weak self] in
                self?.arrangedSubviews.forEach { view in
                    (view as? UIButton)?.isSelected = false //나머지 모두 false
                }
                button.isSelected = true
                self?.selectedType.accept(type)
            }.disposed(by: disposeBag)
            addArrangedSubview(button)
        }
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TabButton: UIButton {
    private let type: TabButtonType
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .systemOrange : .systemGray5
        }
    }
    init(type: TabButtonType) {
        self.type = type
        super.init(frame: .zero)
        backgroundColor = .systemGray5
        setTitle(type.title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        setTitleColor(.black, for: .normal)
        setTitleColor(.white, for: .selected)
        switch type {
        case .api:
            applyCorners(corners: [.topLeft, .bottomLeft], radius: 15)
        case .favorite:
            applyCorners(corners: [.topRight, .bottomRight], radius: 15)
        }
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyCorners(corners: UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(
                roundedRect: self.bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
