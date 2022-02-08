//
//  RegisterViewModel.swift
//  Feed The Cat
//
//  Created by Ivan Budovich on 2/3/22.
//

import Combine
import Foundation

class RegisterViewModel: ObservableObject {

    
    @Published var email: String = ""
    @Published var password: String = ""
    let service: Service
    var registerSubject: PassthroughSubject<Void, Never> = .init()
    var subscribtions: Set<AnyCancellable> = .init()
    @Published var isAuthorized: Bool = false
    
    init(service: Service) {
        self.service = service
        
        let validationPublisher =
        registerSubject
            .withLatestFrom($email, $password)
            .map { (isValid: $0.isValidEmail && $1.isValidPassword, email: $0, password: $1) }
            
        validationPublisher
            .filter { $0.isValid }
            .setFailureType(to: NSError.self)
            .receive(on: DispatchQueue.global(qos: .background))
            .flatMapLatest { [service] (_, email, password) -> AnyPublisher<Void, NSError> in
                service.firebaseService.createUser(email: email, password: password)
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: {} , receiveCompletion: { error in })
            .retry(1)
            .sink(receiveCompletion: {_ in }, receiveValue: {})
            .store(in: &subscribtions)
    }
    
}

