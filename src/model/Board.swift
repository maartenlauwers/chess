//
//  Board.swift
//  Chess
//
//  Created by Maarten on 25/12/2021.
//

import Foundation
import AppKit

typealias File = Int
typealias Rank = Int
typealias Position = (File, Rank)

enum Player {
    case white
    case black
}

class Board: ObservableObject {
    
    @Published var pieces = [Piece]()
    @Published var capturedPieces = [Piece]()
    
    var capturedWhitePieces: [Piece] {
        return capturedPieces.filter({ $0.player == .white })
    }
    var capturedBlackPieces: [Piece] {
        return capturedPieces.filter({ $0.player == .black })
    }
    
    @Published var highlightedPositions = [Position]()
    
    var pickedUpPiece: Piece?
    
    var currentPlayer: Player = .white
    
    
    // MARK: - Lifecycle
    
    
    init() {
        pieces = [Piece]()
        
        pieces = [
            Piece(score: 1, player: .white, type: .pawn, position: (1, 2)),
            Piece(score: 1, player: .white, type: .pawn, position: (2, 2)),
            Piece(score: 1, player: .white, type: .pawn, position: (3, 2)),
            Piece(score: 1, player: .white, type: .pawn, position: (4, 2)),
            Piece(score: 1, player: .white, type: .pawn, position: (5, 2)),
            Piece(score: 1, player: .white, type: .pawn, position: (6, 2)),
            Piece(score: 1, player: .white, type: .pawn, position: (7, 2)),
            Piece(score: 1, player: .white, type: .pawn, position: (8, 2)),
            
            Piece(score: 5, player: .white, type: .rook, position: (1, 1)),
            Piece(score: 3, player: .white, type: .knight, position: (2, 1)),
            Piece(score: 3, player: .white, type: .bishop, position: (3, 1)),
            Piece(score: 9, player: .white, type: .queen, position: (4, 1)),
            Piece(score: 0, player: .white, type: .king, position: (5, 1)),
            Piece(score: 3, player: .white, type: .bishop, position: (6, 1)),
            Piece(score: 3, player: .white, type: .knight, position: (7, 1)),
            Piece(score: 5, player: .white, type: .rook, position: (8, 1)),
            
            Piece(score: 1, player: .black, type: .pawn, position: (1, 7)),
            Piece(score: 1, player: .black, type: .pawn, position: (2, 7)),
            Piece(score: 1, player: .black, type: .pawn, position: (3, 7)),
            Piece(score: 1, player: .black, type: .pawn, position: (4, 7)),
            Piece(score: 1, player: .black, type: .pawn, position: (5, 7)),
            Piece(score: 1, player: .black, type: .pawn, position: (6, 7)),
            Piece(score: 1, player: .black, type: .pawn, position: (7, 7)),
            Piece(score: 1, player: .black, type: .pawn, position: (8, 7)),
            
            Piece(score: 5, player: .black, type: .rook, position: (1, 8)),
            Piece(score: 3, player: .black, type: .knight, position: (2, 8)),
            Piece(score: 3, player: .black, type: .bishop, position: (3, 8)),
            Piece(score: 9, player: .black, type: .queen, position: (4, 8)),
            Piece(score: 0, player: .black, type: .king, position: (5, 8)),
            Piece(score: 3, player: .black, type: .bishop, position: (6, 8)),
            Piece(score: 3, player: .black, type: .knight, position: (7, 8)),
            Piece(score: 5, player: .black, type: .rook, position: (8, 8))
        ]
    }
    
    func getPiece(at position: Position) -> Piece? {
        return pieces.first(where: { $0.file == position.0 && $0.rank == position.1 })
    }
    
    func findPiece(of type: PieceType, player: Player) -> Piece? {
        return pieces.first(where: { $0.type == type && $0.player == player })
    }
    
    func indexOfPiece(piece: Piece) -> Int? {
        return pieces.firstIndex(where: { $0 == piece })
    }
    
    func indexOfPiece(at position: Position) -> Int? {
        return pieces.firstIndex(where: { $0.file == position.0 && $0.rank == position.1 })
    }
    
    /// Check which of these positions are actually valid, that
    /// is:
    /// * Free
    /// * If not free, can be captured.
    /// * In case of the king, does not put the king in check.
    func moves(for piece: Piece) -> [Position] {
        var positions = [Position]()
        
        switch piece.type {
        case .king:
            positions = [
                (piece.file, piece.rank + 1),
                (piece.file + 1, piece.rank + 1),
                (piece.file + 1, piece.rank),
                (piece.file + 1, piece.rank - 1),
                (piece.file, piece.rank - 1),
                (piece.file - 1, piece.rank - 1),
                (piece.file - 1, piece.rank),
                (piece.file - 1, piece.rank + 1)
            ]
            positions = positions.filter({ isOnBoard($0) })
            
        case .queen:
            positions.append(contentsOf: movesForRook(with: piece))
            positions.append(contentsOf: movesForBishop(with: piece))
            
        case .rook:
            positions = movesForRook(with: piece)
            
        case .knight:
            positions = movesForKnight(with: piece)
            
        case .bishop:
            positions = movesForBishop(with: piece)
            
        case .pawn:
            switch piece.player {
            case .white:
                if piece.rank < 8 {
                    positions.append((piece.file, piece.rank + 1))
                    if piece.rank == 2 {
                        // Pawns can move two tiles at the start.
                        positions.append((piece.file, piece.rank + 2))
                    }
                    if piece.file > 1 {
                        positions.append((piece.file - 1, piece.rank + 1))
                    }
                    if piece.file < 8 {
                        positions.append((piece.file + 1, piece.rank + 1))
                    }
                }
                
                
            case .black:
                if piece.rank > 1 {
                    positions.append((piece.file, piece.rank - 1))
                    if piece.rank == 7 {
                        // Pawns can move two tiles at the start.
                        positions.append((piece.file, piece.rank - 2))
                    }
                    if piece.file > 1 {
                        positions.append((piece.file - 1, piece.rank - 1))
                    }
                    if piece.file < 8 {
                        positions.append((piece.file + 1, piece.rank - 1))
                    }
                }
            }
        }
        
        // Filter out invalid moves.
        positions = positions.filter({ canMove(piece, to: $0)})
        return positions
    }
    
    func movesForKnight(with piece: Piece) -> [Position] {
        let positions = [
            (piece.file + 1, piece.rank + 2),
            (piece.file + 1, piece.rank - 2),
            (piece.file + 2, piece.rank + 1),
            (piece.file + 2, piece.rank - 1),
            (piece.file - 1, piece.rank + 2),
            (piece.file - 1, piece.rank - 2),
            (piece.file - 2, piece.rank + 1),
            (piece.file - 2, piece.rank - 1),
        ]
        return positions.filter({ isOnBoard($0) })
    }
    
    func movesForBishop(with piece: Piece) -> [Position] {
        var positions = [Position]()
        // Top right
        var file = piece.file
        var rank = piece.rank
        while file < 8 && rank < 8 {
            file += 1
            rank += 1
            let newPosition = (file, rank)
            if isFree(newPosition) {
                positions.append(newPosition)
            }
            else {
                positions.append(newPosition)
                break
            }
        }
        // Bottom right
        file = piece.file
        rank = piece.rank
        while file < 8 && rank > 1 {
            file += 1
            rank -= 1
            let newPosition = (file, rank)
            if isFree(newPosition) {
                positions.append(newPosition)
            }
            else {
                positions.append(newPosition)
                break
            }
        }
        // Bottom left
        file = piece.file
        rank = piece.rank
        while file > 1 && rank > 1 {
            file -= 1
            rank -= 1
            let newPosition = (file, rank)
            if isFree(newPosition) {
                positions.append(newPosition)
            }
            else {
                positions.append(newPosition)
                break
            }
        }
        // Top left
        file = piece.file
        rank = piece.rank
        while file > 1 && rank < 8 {
            file -= 1
            rank += 1
            let newPosition = (file, rank)
            if isFree(newPosition) {
                positions.append(newPosition)
            }
            else {
                positions.append(newPosition)
                break
            }
        }

        return positions
    }
    
    func movesForRook(with piece: Piece) -> [Position] {
        var positions = [Position]()
        // Up
        for rank in piece.rank+1..<9 {
            let newPosition = (piece.file, rank)
            if isFree(newPosition) {
                positions.append(newPosition)
            }
            else {
                positions.append(newPosition)
                break
            }
        }
        // Down
        for rank in (1..<piece.rank).reversed() {
            let newPosition = (piece.file, rank)
            if isFree(newPosition) {
                positions.append(newPosition)
            }
            else {
                positions.append(newPosition)
                break
            }
        }
        // Right
        for file in piece.file+1..<9 {
            let newPosition = (file, piece.rank)
            if isFree(newPosition) {
                positions.append(newPosition)
            }
            else {
                positions.append(newPosition)
                break
            }
        }
        // Left
        for file in (1..<piece.file).reversed() {
            let newPosition = (file, piece.rank)
            if isFree(newPosition) {
                positions.append(newPosition)
            }
            else {
                positions.append(newPosition)
                break
            }
        }
        return positions
    }
    
    func isOnBoard(_ position: Position) -> Bool {
        let file = position.0
        let rank = position.1
        return file > 0 && file < 9 && rank > 0 && rank < 9
    }
    
    /// Returns true if a position on the board is free.
    func isFree(_ position: Position) -> Bool {
        return getPiece(at: position) == nil
    }
    
    /// Returns true if the given move is valid for the given piece. This means
    /// that:
    ///
    /// - The position is within range of the piece.
    /// - Either the position is free...
    /// - ...or the piece at the position can be captured.
    /// - the king is not placed in check.
    func canMove(_ piece: Piece, to position: Position) -> Bool {
        let targetFile = position.0
        
        switch piece.type {
        case .pawn:
            if piece.file != targetFile {
                // We can only move diagonally if there is a piece to capture.
                guard let targetPiece = getPiece(at: position) else {
                    return false
                }
                // The piece to capture must belong to the other player.
                guard piece.player != targetPiece.player else {
                    return false
                }
                
                return true
            }
            return true
            
        default:
            if let targetPiece = getPiece(at: position) {
                // The piece to capture must belong to the other player.
                guard piece.player != targetPiece.player else {
                    return false
                }
            }
            return true
        }
    }
    
    func checkKingInCheck() {
        if
            let whiteKing = findPiece(of: .king, player: .white),
            let index = indexOfPiece(piece: whiteKing) {
            pieces[index].inCheck = isInCheck(piece: whiteKing)
        }
        if
            let blackKing = findPiece(of: .king, player: .black),
            let index = indexOfPiece(piece: blackKing) {
            pieces[index].inCheck = isInCheck(piece: blackKing)
        }
    }
    
    func isInCheck(piece: Piece) -> Bool {
        let enemyPlayer: Player = piece.player == .white ? .black : .white
        
        for position in movesForBishop(with: piece) {
            if
                let pieceAtPosition = getPiece(at: position),
                pieceAtPosition.type == .bishop || pieceAtPosition.type == .queen,
                pieceAtPosition.player == enemyPlayer {
                return true
            }
        }
        for position in movesForRook(with: piece) {
            if
                let pieceAtPosition = getPiece(at: position),
                pieceAtPosition.type == .rook || pieceAtPosition.type == .queen,
                pieceAtPosition.player == enemyPlayer {
                return true
            }
        }
        for position in movesForKnight(with: piece) {
            if
                let pieceAtPosition = getPiece(at: position),
                pieceAtPosition.type == .knight,
                pieceAtPosition.player == enemyPlayer {
                return true
            }
        }
        
        switch piece.player {
        case .white:
            if
                let pieceAtPosition = getPiece(at: (piece.file - 1, piece.rank + 1)),
                pieceAtPosition.type == .pawn,
                pieceAtPosition.player == enemyPlayer {
                return true
            }
            if
                let pieceAtPosition = getPiece(at: (piece.file + 1, piece.rank + 1)),
                pieceAtPosition.type == .pawn,
                pieceAtPosition.player == enemyPlayer {
                return true
            }
            
        case .black:
            if
                let pieceAtPosition = getPiece(at: (piece.file - 1, piece.rank - 1)),
                pieceAtPosition.type == .pawn,
                pieceAtPosition.player == enemyPlayer {
                return true
            }
            if
                let pieceAtPosition = getPiece(at: (piece.file + 1, piece.rank - 1)),
                pieceAtPosition.type == .pawn,
                pieceAtPosition.player == enemyPlayer {
                return true
            }
        }
        
        return false
    }
    
    // TODO: Determine game over
    //
    // 1. Check if the king can perform any of its valid moves to escape the check.
    // 2. For every of our pieces, check if it can capture the checking piece (check if any of its valid move positions matches the checking piece position)
    // 3. For every of our pieces, check if it can block the checking piece. 
    
    
    
    
    // MARK: - UI Helper
    
    
    func isHighlighted(at position: Position) -> Bool {
        return highlightedPositions.contains { highlightedPosition in
            return position == highlightedPosition
        }
    }
    
    
    // MARK: - Audio
    
    
    private func playPieceSound() {
        NSSound(named: "capture.mp3")?.play()
    }
    
    
    // MARK: - Events
    
    
    func handleTap(at position: Position) {
        if let piece = pickedUpPiece {
            // This tap is setting down the piece.
            
            guard highlightedPositions.contains(where: { $0 == position }) else {
                // Player put the piece back to its original position.
                pickedUpPiece = nil
                highlightedPositions.removeAll()
                return
            }
            
            guard let index = indexOfPiece(piece: piece) else {
                return
            }
            
            // Perform the move, check if the king is in check. If not, we're
            // good. If yes, undo the move.
            
            // Remove any captured piece
            let capturedIndex = indexOfPiece(at: position)
            let capturedPiece = getPiece(at: position)
            
            pieces[index].position = position
            
            // Write out the move.
            print("Move: \(pieces[index].toString())")
            
            if let capturedIndex = capturedIndex {
                capturedPieces.append(pieces[capturedIndex])
                pieces.remove(at: capturedIndex)
            }
            
            // Check if the move we're about to make puts our king in check.
            // If so, undo the move.
            if let king = findPiece(of: .king, player: currentPlayer) {
                if isInCheck(piece: king) {
                    pieces[index].position = piece.position
                    if let capturedPiece = capturedPiece {
                        pieces.append(capturedPiece)
                        capturedPieces.removeLast()
                    }
                }
                else {
                    playPieceSound()
                    currentPlayer = currentPlayer == .white ? .black : .white
                }
                
                checkKingInCheck()
                pickedUpPiece = nil
                highlightedPositions.removeAll()
            }
            else {
                assertionFailure("ERROR: Could not find the king on the board yet the game is ongoing.")
            }
        }
        else {
            // This tap is picking up the piece.
            guard let piece = getPiece(at: position), piece.player == currentPlayer else {
                return
            }
            
            pickedUpPiece = piece
            highlightedPositions = moves(for: piece)
        }
    }
}
