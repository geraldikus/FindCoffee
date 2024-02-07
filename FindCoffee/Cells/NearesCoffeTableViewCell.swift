//
//  NearesCoffeTableViewCell.swift
//  FindCoffee
//
//  Created by Anton on 07.02.24.
//

import UIKit

class NearesCoffeTableViewCell: UITableViewCell {
    
    static let reuseId = "NearesCoffeeCell"
    
    private let bacgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tableViewBackgoundColor
        view.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.25
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.titleColor
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .placeholderColor
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubview(bacgroundView)
        bacgroundView.addSubview(title)
        bacgroundView.addSubview(distanceLabel)
        setupConstraints()
        
    }

    private func setupConstraints() {
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(5)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp_bottomMargin).offset(10)
            make.left.equalToSuperview().inset(5)
        }
        
        bacgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.bottom.left.right.equalToSuperview().inset(3)
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
