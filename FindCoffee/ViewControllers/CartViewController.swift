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
    var counts: [Menu: Int] = [:]
    
    init(selectedItems: [Menu], counts: [Menu: Int]) {
        self.data = selectedItems
        self.counts = counts
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
        counts[menuItem] = count
        tableView.reloadData()
    }

    func updateCart(menuItemId: Menu, count: Int) {
        if count == 0 {
            counts.removeValue(forKey: menuItemId)
            data = data.filter { $0 != menuItemId }
        } else {
            counts[menuItemId] = count
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
        print("Count for indexPath \(indexPath): \(counts[menu] ?? 228)")
        cell.countLabel.text = "\(counts[menu] ?? 0)"
        
        cell.increaseCountAction = { [weak self] in
            guard let self = self else { return }
            guard let menu = self.data[safe: indexPath.row] else { return }
            var count = self.counts[menu] ?? 0
            count += 1
            self.counts[menu] = count
            cell.countLabel.text = "\(count)"
        }
        
        cell.decreaseCountAction = { [weak self] in
            guard let self = self, let indexPath = self.tableView.indexPath(for: cell) else { return }
            guard let menu = self.data[safe: indexPath.row] else { return }
            if var count = self.counts[menu], count > 0 {
                count -= 1
                if count == 0 {
                    self.counts.removeValue(forKey: menu)
                    self.data.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    self.counts[menu] = count
                    cell.countLabel.text = "\(count)"
                }
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if !counts.isEmpty {
            footerLabel.text = "Время ожидания заказа 15 минут. Спасибо, что выбрали нас!"
        } else {
            footerLabel.text = "К сожалению, ваша корзина пуста."
        }
        
        footerLabel.numberOfLines = 0
        footerLabel.backgroundColor = .white
        footerLabel.textAlignment = .center
        footerLabel.font = .systemFont(ofSize: 24)
        footerLabel.textColor = .cartTextColor
        
        return footerLabel
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }
}


