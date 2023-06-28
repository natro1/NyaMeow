//
//  CatModel.swift
//  NyaMeow
//
//  Created by Natalia Rojek on 04/01/2023.
//
//  Review Pending

struct CatImageModel: Decodable {
    // swiftlint:disable:next identifier_name
    let url: String
}

struct CatFactModel: Decodable {
    let data: [String]
}
