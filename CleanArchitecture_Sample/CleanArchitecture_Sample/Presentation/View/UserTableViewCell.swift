//
//  UserTableViewCell.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/25/24.
//

import UIKit
import Kingfisher
import RxSwift

final class UserTableViewCell: UITableViewCell {
    public var disposeBag = DisposeBag()
    private let userImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.systemGray5.cgColor
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    public let favoritButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "heart"), for: .normal)
        button.setImage(.init(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemPink
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() //셀 다시 그릴떄 초기화
    }
    
    func apply(cellData: UserListCellData) {
        guard case let .user(user, isFavorite) = cellData else { return }
        userImageView.kf.setImage(with: URL(string: user.imageURL))
        nameLabel.text = user.login
        favoritButton.isSelected = isFavorite
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Set Up

private extension UserTableViewCell {
    func setUpView() {
        contentView.addSubview(userImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(favoritButton)
        userImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(20)
            make.height.equalTo(80).priority(.high)
            make.width.equalTo(80)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView)
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
        favoritButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-20)
        }
    }
}
