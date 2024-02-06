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
    
    private var collectionView: UICollectionView!
    let sections = [Location]()
    private let token: String
    
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
        setupCollectionView()
        fetchLocations()
    }
    
    private func fetchLocations() {
        let urlString = "http://147.78.66.203:3210/locations"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("Authorization token: \(token)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
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
            } catch {
                print("Error decoding locations: \(error)")
            }
        }.resume()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(NearestCoffeCell.self, forCellWithReuseIdentifier: NearestCoffeCell.reuseId)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layotEnvironment in
            
            return self.createVerticalSection()
        }
        
        return layout
    }
    
    func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 12, leading: 20, bottom: 0, trailing: 20)
        
        return section
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
