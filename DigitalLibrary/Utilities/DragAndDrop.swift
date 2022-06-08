//
//  DragAndDrop.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 04/06/22.
//

import SwiftUI

struct MyDropDelegate<A: Equatable> : DropDelegate {

    let item : A
    @Binding var items : [A]
    @Binding var draggedItem : A?

    func performDrop(info: DropInfo) -> Bool {
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem else {
            return
        }

        if draggedItem != item {
            let from = items.firstIndex(of: draggedItem)!
            let to = items.firstIndex(of: item)!
            withAnimation(.default) {
                self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }
    }
}

// Insert in struct variables
//    @State var draggedItem : Bookshelf?


// Append to NavigationLink (or element of List)
//                    .onDrag({
//                        self.draggedItem = bookshelf
//                        return NSItemProvider(item: nil, typeIdentifier: bookshelf.name ?? "")
//                    })
//                    .onDrop(of: [UTType.text], delegate:
//                        MyDropDelegate<Bookshelf>(item: bookshelf, items:
//                            Binding<[Bookshelf]> (
//                                get: { return Array(bookshelfs) },
//                                set: { _ in }
//                            )
//                            , draggedItem: $draggedItem
//                        )
//                    )
