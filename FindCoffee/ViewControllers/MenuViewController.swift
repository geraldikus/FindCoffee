//
//  MenuViewController.swift
//  FindCoffee
//
//  Created by Anton on 07.02.24.
//

import UIKit

protocol CartDelegate: AnyObject {
    func addToCart(menuItem: Menu, count: Int)
    func updateCart(menuItemId: Menu, count: Int)
}

class MenuViewController: UIViewController {
    
    private let token: String
    var data = [Menu]()
    private var locationID: Int?
    private var collectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    private let sectionInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
    var idText: String?
    var counts: [Menu: Int] = [:]
    
    weak var cartDelegate: CartDelegate?
    var selectedItems: [Menu] = []
    
    var selectedCounts: [Menu: Int] = [:]
    
    var dataUpdatedHandler: (([Menu]) -> Void)?
    
    init(token: String, locationID: Int) {
        self.token = token
        self.locationID = locationID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let id: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var toPaymentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.buttonBackgroundColor
        button.setTitle("Перейти к оплате", for: .normal)
        button.setTitleColor(.buttonTitleColor, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(toPaymentButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Меню"
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        setupCollectionView()
        view.addSubview(toPaymentButton)
        setupConstraints()
        fetchLocations()
    }
    
    private func setupCollectionView() {
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 200, height: 300)
        layout.scrollDirection = .vertical
        layout.collectionView?.showsVerticalScrollIndicator = false
        layout.sectionInset = sectionInsets
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.reuseId)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }

    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(10)
            make.left.equalToSuperview().offset(10)
        }
        
        toPaymentButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(20)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(view.snp.bottomMargin).inset(15)
            make.height.equalTo(48)
        }
    }
    
    private func fetchLocations() {
        guard let locationID = locationID else {
            print("No location ID specified")
            return
        }

        let urlString = "http://147.78.66.203:3210/location/\(locationID)/menu"
        guard let url = URL(string: urlString) else {
            print("Invalid URL for menu")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching locations: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let menu = try decoder.decode([Menu].self, from: data)
                print("Menu: \(menu)")
                
                self.data = menu
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error decoding locations: \(error)")
            }
        }.resume()
    }
    
    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
    func loadImage(for cell: MenuCollectionViewCell, from urlString: String) {
        cell.activityIndicatorView.startAnimating()

        fetchImage(from: urlString) { image in
            DispatchQueue.main.async {
                cell.activityIndicatorView.stopAnimating() 
                cell.imageView.image = image
            }
        }
    }

    @objc func toPaymentButtonTapped() {
        let selectedItems = selectedCounts.compactMap { menuItem, count -> Menu? in
            return menuItem
        }
        
        let newCartVC = CartViewController(selectedItems: selectedItems, counts: selectedCounts)
        newCartVC.token = token
        newCartVC.locationId = locationID
        newCartVC.counts = selectedCounts 
        navigationController?.pushViewController(newCartVC, animated: true)
    }

}

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.reuseId, for: indexPath) as? MenuCollectionViewCell else {
            print("Wrong cell in Menu")
            return UICollectionViewCell()
        }
        
        let menu = data[indexPath.item]
        print("MENU from CollectionView: \(menu.name)")
        
        loadImage(for: cell, from: menu.imageURL)
        cell.indexPath = indexPath
        cell.name.text = menu.name
        cell.priceLabel.text = "\(menu.price)руб"
        
        cell.countLabel.text = "\(counts[menu] ?? 0)"
        
        cell.cartAction = { [weak self] isAddAction in
            guard let self = self else { return }
            let menuItem = self.data[indexPath.item]
            var count = self.selectedCounts[menuItem] ?? 0
            
            if isAddAction {
                count += 1
            } else {
                if count > 0 {
                    count -= 1
                }
            }
            
            if count == 0 {
                self.selectedCounts.removeValue(forKey: menuItem)
            } else {
                self.selectedCounts[menuItem] = count
            }
            
            cell.countLabel.text = "\(count)"
            self.cartDelegate?.updateCart(menuItemId: menuItem, count: count)
        }
        



        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: 205)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
}


