//
//  Place.swift
//  MapsApp
//
//  Created by Kwikku Nusantara on 23/05/23.
//
import Foundation

// MARK: - Welcome
struct Place: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title, id, language, resultType: String
    let address: ItemAddress
    let highlights: Highlights
}

// MARK: - ItemAddress
struct ItemAddress: Codable {
    let label, countryCode, countryName, countyCode: String
    let county, city, district: String
    let subdistrict: String?
    let street, postalCode: String
}

// MARK: - Highlights
struct Highlights: Codable {
    let title: [Title]
    let address: HighlightsAddress
}

// MARK: - HighlightsAddress
struct HighlightsAddress: Codable {
    let label, street: [Title]
}

// MARK: - Title
struct Title: Codable {
    let start, end: Int
}
