//
//  ViewController.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UserListViewController: UIViewController {
    private let viewModel: UserListViewModelProtocol
    private let disposeBag = DisposeBag()
    private let saveFavorit = PublishRelay<UserListItem>()
    private let deleteFavoriy = PublishRelay<Int>()
    private let fetchMore = PublishRelay<Void>()
    private let tabButtonView = TabButtonView(tabList: [.api, .favorite])

    private let searchTextField = {
        let textfield = UITextField()
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.systemGray5.cgColor
        textfield.layer.cornerRadius = 22
        textfield.placeholder = "닉네임을 입력해 주세요"
        let image = UIImageView(image: .init(systemName: "magnifyingglass"))
        image.frame = .init(x: 0, y: 0, width: 20, height: 20)
        textfield.leftView = image
        textfield.leftViewMode = .always
        textfield.tintColor = .systemGray3
        return textfield
    }()
        
    private let tableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setUI()
        bindView() //구독을 하여 관리
        bindViewModel() //output구현
    }
    
    private func bindView() {
        tabButtonView.selectedType.bind { type in
            print("type: \(type)")
        }.disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let tabbuttonType = tabButtonView.selectedType.compactMap { $0 } //옵셔널제거
        let query = searchTextField.rx.text.orEmpty.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        let outPut = viewModel.trenform(input: UserListViewModel.Input(tabButtonType: tabbuttonType, query: query, saveFavorite: saveFavorit.asObservable(), deleteFavorite: deleteFavoriy.asObservable(), fetchMore: fetchMore.asObservable()))
        
        outPut.cellData.bind(to: tableView.rx.items) { tableView, index, item in
            return UITableViewCell()
        }.disposed(by: disposeBag)
        
        outPut.error.bind { [weak self] ms in
            let alert = UIAlertController(title: "알림", message: ms, preferredStyle: .alert)
            alert.addAction(.init(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func setUI() {
        view.addSubview(searchTextField)
        view.addSubview(tabButtonView)
        view.addSubview(tableView)
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        tabButtonView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tabButtonView.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

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
