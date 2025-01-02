//
//  HeaderTableViewCell.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/25/24.
//

import UIKit

final class HeaderTableViewCell: UITableViewCell, UserListCellProtocol {
    private let titleLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    func setUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(6)
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(6)
        }
    }
    
    func apply(cellData: UserListCellData) {
        guard case let .header(title) = cellData else { return }
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
