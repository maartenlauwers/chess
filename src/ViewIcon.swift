//
//  ViewIcon.swift
//  Chess
//
//  Created by Maarten on 25/12/2021.
//

import Foundation
import AppKit
import SwiftUI
import Cocoa


enum IconType: Int, Hashable {
    case king_white
    case king_black
    case queen_white
    case queen_black
    case rook_white
    case rook_black
    case bishop_white
    case bishop_black
    case knight_white
    case knight_black
    case pawn_white
    case pawn_black
}

struct ViewIcon: NSViewRepresentable {
    @Binding var iconType: IconType

    func makeNSView(context: Context) -> NSViewIcon {
        NSViewIcon()
    }
    
    func updateNSView(_ nsView: NSViewIcon, context: Context) {
        nsView.iconType = iconType
    }
}

class NSViewIcon: NSView {

    var iconType: IconType = .king_white {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    override func draw(_ rect: CGRect) {
        switch iconType {
        case .king_white:
            Paintcode.drawKing_white(frame: rect, resizing: .aspectFit)
        case .king_black:
            Paintcode.drawKing_black(frame: rect, resizing: .aspectFit)
        case .queen_white:
            Paintcode.drawQueen_white(frame: rect, resizing: .aspectFit)
        case .queen_black:
            Paintcode.drawQueen_black(frame: rect, resizing: .aspectFit)
        case .rook_white:
            Paintcode.drawRook_white(frame: rect, resizing: .aspectFit)
        case .rook_black:
            Paintcode.drawRook_black(frame: rect, resizing: .aspectFit)
        case .bishop_white:
            Paintcode.drawBishop_white(frame: rect, resizing: .aspectFit)
        case .bishop_black:
            Paintcode.drawBishop_black(frame: rect, resizing: .aspectFit)
        case .knight_white:
            Paintcode.drawKnight_white(frame: rect, resizing: .aspectFit)
        case .knight_black:
            Paintcode.drawKnight_black(frame: rect, resizing: .aspectFit)
        case .pawn_white:
            Paintcode.drawPawn_white(frame: rect, resizing: .aspectFit)
        case .pawn_black:
            Paintcode.drawPawn_black(frame: rect, resizing: .aspectFit)
        }
    }
}
