//
//  TitlePageRouter.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 18.05.2022.
//

import UIKit

class TitlePageRouter: Router {
    
    //MARK: Properties
    
    private let assemblyBuilder: AssemblyBuilderProtocol
    private let baseViewController: UIViewController
    
    //MARK: - Initialization
    
    required init(baseViewController: UIViewController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.baseViewController = baseViewController
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    
    func present(module: Module, animated: Bool, context: Any?, completion: (() -> Void)?) {}
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        baseViewController.dismiss(animated: true)
    }
}
