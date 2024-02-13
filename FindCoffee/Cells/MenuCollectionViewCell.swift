//
//  MenuCollectionViewCell.swift
//  FindCoffee
//
//  Created by Anton on 07.02.24.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "MenuCell"
    
    let view = UIView()
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        return image
    }()
    
    var count: Int = 0 {
        didSet {
            countLabel.text = "\(count)"
        }
    }
    
    weak var menuVC: MenuViewController?
    
    var indexPath: IndexPath?
    
    var addToCartAction: (() -> Void)?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    let name: UILabel = {
        let name = UILabel()
        name.textColor = .mainTextColor
        name.font = .systemFont(ofSize: 15)
        return name
    }()
    
    var priceLabel: UILabel = {
        let price = UILabel()
        price.textColor = .titleColor
        price.font = .systemFont(ofSize: 14, weight: .bold)
        return price
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.tableViewBackgoundColor, for: .normal)
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.tableViewBackgoundColor, for: .normal)
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let countLabel: UILabel = {
        let count = UILabel()
        count.textColor = .placeholderText
        return count
    }()
    
    let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 3
        stack.alignment = .center
        stack.axis = .horizontal
        return stack
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = 10
        contentView.addSubview(view)
        contentView.backgroundColor = .white
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 3
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        view.addSubview(imageView)
        view.addSubview(activityIndicatorView)
        view.addSubview(name)
        view.addSubview(priceLabel)
        
        view.addSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(minusButton)
        horizontalStackView.addArrangedSubview(countLabel)
        horizontalStackView.addArrangedSubview(plusButton)
    }
    
    private func setupConstraints() {
        view.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.height.equalTo(210)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(140)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(imageView)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp_bottomMargin).offset(15)
            make.left.equalToSuperview().inset(10)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(name.snp_bottomMargin).offset(5)
            make.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(10)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(name.snp_bottomMargin).offset(5)
            make.left.equalTo(priceLabel.snp_rightMargin).inset(6)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        
    }
    
    @objc func minusButtonTapped() {
        if count > 0 {
            count -= 1
            addToCartAction?()
        }
    }


    @objc func plusButtonTapped() {
        count += 1
        addToCartAction?()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
