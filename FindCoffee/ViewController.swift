//
//  ViewController.swift
//  FindCoffee
//
//  Created by Anton on 02.02.24.
//

import UIKit
import SnapKit
import SwiftUI

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Регистрация"
        view.backgroundColor = .systemBackground
    }


}

// MARK: - For Canvas

struct ViewRepreset: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ViewRepreset>) {
        
    }
    
}

struct CanvasView: View {
    var body: some View {
        ViewRepreset()
    }
}

#Preview {
    CanvasView()
}

