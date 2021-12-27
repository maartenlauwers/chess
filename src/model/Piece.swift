//
//  Piece.swift
//  Chess
//
//  Created by Maarten on 26/12/2021.
//

import Foundation

enum PieceType {
    case king
    case queen
    case rook
    case bishop
    case knight
    case pawn
}

struct Piece: Equatable, Hashable {
    let id = UUID()
    let score: UInt8
    let player: Player
    let type: PieceType
    var position: (File, Rank)
    
    var inCheck = false
    
    var file: File {
        return position.0
    }
    var rank: Rank {
        return position.1
    }
    
    var iconType: IconType {
        switch player {
        case .white:
            switch type {
            case .king:
                return .king_white
            case .queen:
                return .queen_white
            case .rook:
                return .rook_white
            case .knight:
                return .knight_white
            case .bishop:
                return .bishop_white
            case .pawn:
                return .pawn_white
            }
        case .black:
            switch type {
            case .king:
                return .king_black
            case .queen:
                return .queen_black
            case .rook:
                return .rook_black
            case .knight:
                return .knight_black
            case .bishop:
                return .bishop_black
            case .pawn:
                return .pawn_black
            }
        }
    }
    
    func positionToString() -> String {
        var name = ""
        switch file {
        case 1:
            name = "a"
        case 2:
            name = "b"
        case 3:
            name = "c"
        case 4:
            name = "d"
        case 5:
            name = "e"
        case 6:
            name = "f"
        case 7:
            name = "g"
        case 8:
            name = "h"
        default:
            return "ERROR: Invalid position"
        }
        
        return "\(name)\(rank)"
    }
    
    func toString() -> String {
        switch type {
        case .king:
            return "k \(positionToString())"
            
        case .queen:
            return "q \(positionToString())"
            
        case .rook:
            return "r \(positionToString())"
            
        case .knight:
            return "n \(positionToString())"
            
        case .bishop:
            return "b \(positionToString())"
            
        case .pawn:
            return positionToString()
        }
    }
    
    
    // MARK: - Equatable
    
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.position == rhs.position
    }
    
    
    // MARK: - Hashable
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
