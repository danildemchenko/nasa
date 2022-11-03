//
//  RoverPhoto.swift
//  nasa
//
//  Created by Danil Demchenko on 21.10.2022.
//

import Foundation

struct RoverPhotos: Codable {
    let photos: [RoverPhoto]
}

struct RoverPhoto: Codable {
    let id: Int
    let sol: Int
    let img_src: String
    let earth_date: String
    let rover: Rover
}

struct Rover: Codable {
    let id: Int
    let name: String
    let landing_date: String
    let launch_date: String
    let status: String
}
