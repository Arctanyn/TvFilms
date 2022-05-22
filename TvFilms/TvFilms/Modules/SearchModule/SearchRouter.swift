//
//  SearchRouter.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 20.05.2022.
//

import UIKit

class SearchRouter: Router {
    
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
        let defenitionVC = prepareModule(module, context: context)
        defenitionVC.modalPresentationStyle = .fullScreen
        baseViewController.present(defenitionVC, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        baseViewController.dismiss(animated: animated, completion: completion)
    }
    
    //MARK: - Private methods
    
    private func prepareModule(_ module: Module, context: Any?) -> UIViewController {
        switch module {
        case .titlePage:
            guard let title = context as? TMDBTitle else {
                fatalError("ERROR: An undefined context has been set for creating the required module")
            }
            return assemblyBuilder.createTitlePageModule(title: title)
        default:
            fatalError("ERROR: Invalid routing module requested")
        }
    }
}
