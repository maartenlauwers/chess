//
//  ContentView.swift
//  Chess
//
//  Created by Maarten on 25/12/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var board: Board
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(1..<10, id: \.self) { file in
                VStack(spacing: 0) {
                    if file < 9 {
                        ForEach(1..<9, id: \.self) { rank in
                            TileView(board: board, file: file, rank: rank)
                        }
                        
                        switch file {
                        case 1:
                            LegendView(text: "a")
                        case 2:
                            LegendView(text: "b")
                        case 3:
                            LegendView(text: "c")
                        case 4:
                            LegendView(text: "d")
                        case 5:
                            LegendView(text: "e")
                        case 6:
                            LegendView(text: "f")
                        case 7:
                            LegendView(text: "g")
                        case 8:
                            LegendView(text: "h")
                        default:
                            EmptyView()
                        }
                    }
                    else {
                        ForEach(1..<9) { rank in
                            let reversedRank = (8 - rank) + 1
                            LegendView(text: "\(reversedRank)")
                                .frame(width: 44, height: 77, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                        }
                    }
                }
                .padding(0)
            }
        }
        .frame(width: 640, height: 640, alignment: .center)
    }
}

struct TileView: View {
    
    @ObservedObject var board: Board
    var file: Int
    var rank: Int
    var reversedRank: Int {
        (8 - rank) + 1
    }
    
    var boardColor: Color {
        let sum = file + rank
        let isEven = sum % 2 == 0
        
        if let piece = board.pickedUpPiece, piece.position == (file, reversedRank) {
            return Color.green
        }
        return isEven ? Color.white : Color.gray
    }
    
    var isHighlighted: Bool {
        board.isHighlighted(at: (file, reversedRank))
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(boardColor)
                .padding(0)
                .onTapGesture {
                    board.handleTap(at: (file, reversedRank))
                }
            
            if let piece = board.getPiece(at: (file, reversedRank)) {
                ViewIcon(iconType: .constant(piece.iconType))
                    .onTapGesture {
                        board.handleTap(at: (file, reversedRank))
                    }
                    .padding(4)
                    .border(isHighlighted ? .green : .clear)
            }
            else if isHighlighted {
                Circle()
                    .fill(Color.green)
                    .padding(32)
                    .onTapGesture {
                        board.handleTap(at: (file, reversedRank))
                    }
            }
        }
        .padding(0)
    }
}

struct LegendView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .fontWeight(.bold)
            .padding(4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(board: Board())
    }
}
