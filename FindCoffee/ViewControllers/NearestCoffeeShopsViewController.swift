//
//  NearestCoffeeShopsViewController.swift
//  FindCoffee
//
//  Created by Anton on 05.02.24.
//

import UIKit
import SnapKit
import SwiftUI

class NearestCoffeeShopsViewController: UIViewController {
    
    private var tableView: UITableView!
    private let token: String
    private var data = [Location]()
    
    private lazy var mapButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.buttonBackgroundColor
        button.setTitle("На карте", for: .normal)
        button.setTitleColor(.buttonTitleColor, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()

    
    init(token: String) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ближайшие кофейни"
        view.backgroundColor = .systemBackground
        
        setupView()
        setupConstraints()
        fetchLocations()
    }
    
    private func setupView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.register(NearesCoffeTableViewCell.self, forCellReuseIdentifier: NearesCoffeTableViewCell.reuseId)
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(mapButton)
        tableView.addSubview(refreshControl)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(10)
        }
        
        mapButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).inset(15)
            make.right.equalToSuperview().inset(19)
            make.left.equalToSuperview().inset(19)
            make.bottom.equalTo(view.snp.bottomMargin).inset(15)
            make.height.equalTo(48)
        }
    }
    
    
    private func fetchLocations() {
        let urlString = "http://147.78.66.203:3210/locations"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("Authorization token: \(token)")
        
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
                let locations = try decoder.decode([Location].self, from: data)
                print("Locations: \(locations)")
                
                self.data = locations
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding locations: \(error)")
            }
        }.resume()
    }
    
    @objc func mapButtonTapped() {
        print("Map button tapped")
    }
    
    @objc private func refreshData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

}

extension NearestCoffeeShopsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NearesCoffeTableViewCell.reuseId, for: indexPath) as? NearesCoffeTableViewCell else { return UITableViewCell() }
        
        let location = data[indexPath.item]
        let locationManager = LocationManager.shared
        
        locationManager.requestUserLocation { userLocation in
            if let userLocation = userLocation {
                let distance = LocationManager.shared.distanceFromUserToCoffeeShop(coffeeLatitude: location.point.latitude, coffeeLongitude: location.point.longitude)
                
                print("User location: \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
                cell.distanceLabel.text = String(format: "%.2f км от вас", distance ?? 0)
            } else {
                print("Failed to fetch user location.")
            }
        }
        
        cell.title.text = location.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = data[indexPath.row]
        print("Title: \(location.name)")
        print("ID: \(location.id)")
        print("Distance: \(location.point.latitude)")
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
}

// MARK: - For Canvas

struct ViewRepresetNearestCoffee: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return NearestCoffeeShopsViewController(token: "")
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ViewRepresetNearestCoffee>) {
        
    }
    
}

struct CanvasViewNearestCoffee: View {
    var body: some View {
        ViewRepresetNearestCoffee()
    }
}

#Preview {
    CanvasViewNearestCoffee()
}
