//
//  CartTableViewCell.swift
//  FindCoffee
//
//  Created by Anton on 12.02.24.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    static let reuseId = "CartCell"
    
    private let bacgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tableViewBackgoundColor
        view.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.25
        return view
    }()
    
    var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.titleColor
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "Title"
        
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .placeholderColor
        label.font = .systemFont(ofSize: 14)
        label.text = "Price label"
        
        return label
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.cartTextColor, for: .normal)
        
        return button
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.cartTextColor, for: .normal)
        
        return button
    }()
    
    let countLabel: UILabel = {
        let count = UILabel()
        count.textColor = .cartTextColor
        count.text = "1"
        return count
    }()
    
    let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 3
        stack.alignment = .center
        stack.axis = .horizontal
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubview(bacgroundView)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        bacgroundView.addSubview(title)
        bacgroundView.addSubview(priceLabel)
        horizontalStackView.addArrangedSubview(minusButton)
        horizontalStackView.addArrangedSubview(countLabel)
        horizontalStackView.addArrangedSubview(plusButton)
        bacgroundView.addSubview(horizontalStackView)
    }
    
    private func setupConstraints() {
        bacgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.bottom.left.right.equalToSuperview().inset(3)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(5)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp_bottomMargin).offset(10)
            make.left.equalToSuperview().inset(5)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(5)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
