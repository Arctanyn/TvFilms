//
//  HomePageRouter.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 18.05.2022.
//

import UIKit

class HomePageRouter: Router {
    
    //MARK: Properties
    
    private let assemblyBuilder: AssemblyBuilderProtocol
    private let baseViewController: UIViewController
    
    //MARK: - Initialization
    
    required init(baseViewController: UIViewController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.baseViewController = baseViewController
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    
    func present(module: Module, animated: Bool, context: Any?, completion: (() -> Void)?) {
        let definitionVC = prepareModule(module, context: context)
        definitionVC.modalPresentationStyle = .fullScreen
        baseViewController.present(definitionVC, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {}
    
    //MARK: - Private methods
    
    private func prepareModule(_ module: Module, context: Any?) -> UIViewController {
        switch module {
        case .titlePage:
            guard let title = context as? TMDBTitle else { return UIViewController() }
            return assemblyBuilder.createTitlePageModule(title: title)
        case .search:
            return assemblyBuilder.createSearchModule()
        default:
            fatalError("ERROR: Invalid routing module requested")
        }
    }
    
}
