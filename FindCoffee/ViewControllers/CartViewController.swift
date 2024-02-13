//
//  CartViewController.swift
//  FindCoffee
//
//  Created by Anton on 12.02.24.
//

import UIKit

final class CartViewController: UIViewController, CartDelegate {

    private var tableView: UITableView!
    private let footerLabel = UILabel()
    
    var token: String?
    var locationId: Int?
    
    var data: [Menu]
    
    init(selectedItems: [Menu]) { // Обновленный инициализатор с передачей count
        self.data = selectedItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ваш заказ"
        setupView()
        
        let menuViewController = MenuViewController(token: token ?? "", locationID: locationId ?? 0)
        menuViewController.cartDelegate = self
        menuViewController.dataUpdatedHandler = { [weak self] updatedData in
            self?.data = updatedData
            self?.tableView.reloadData()
        }
        
        print("TOKEN: \(token)")
        print("LocationID: \(locationId)")
        
        print("Data: \(data)")
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseId)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 10))
        }
    }
    
    func addToCart(menuItem: Menu, count: Int) {
        if !data.contains(menuItem) {
            data.append(menuItem)
        }
        tableView.reloadData()
    }

}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseId, for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        
        let menu = data[indexPath.row]

        cell.title.text = menu.name
        cell.priceLabel.text = "\(menu.price)руб"
        cell.countLabel.text = "2"
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerLabel.text = "Время ожидания заказа 15 минут. Спасибо, что выбрали нас!"
        footerLabel.numberOfLines = 0
        footerLabel.backgroundColor = .white
        footerLabel.textAlignment = .center
        footerLabel.font = .systemFont(ofSize: 24)
        footerLabel.textColor = .cartTextColor
        return footerLabel
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }
}


