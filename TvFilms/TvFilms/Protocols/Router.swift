//
//  RouterProtocol.swift
//  TvFilms
//
//  Created by Малиль Дугулюбгов on 11.05.2022.
//

import UIKit

protocol Router {
    
    init(baseViewController: UIViewController, assemblyBuilder: AssemblyBuilderProtocol)

    func present(module: Module, animated: Bool, context: Any?, completion: (() -> Void)?)
    
    func dismiss(animated: Bool, completion: (() -> Void)?)
}
