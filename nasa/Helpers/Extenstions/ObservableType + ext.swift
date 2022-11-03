//
//  ObservableType + ext.swift
//  nasa
//
//  Created by Danil Demchenko on 02.11.2022.
//

import RxSwift
import Moya

extension ObservableType {
    func decode<T: Codable>(_ type: T.Type) -> Observable<T> {
        return map { response -> T in
            guard let data = (response as? Response)?.data else {
                fatalError("error occured")
            }
            
            guard let object = try? JSONDecoder().decode(type, from: data) else {
                fatalError("decoding error occured")
            }
            
            return object
        }
    }
}
