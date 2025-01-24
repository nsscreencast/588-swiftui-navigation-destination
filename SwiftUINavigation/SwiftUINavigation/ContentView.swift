//
//  ContentView.swift
//  SwiftUINavigation
//
//  Created by Ben Scheirman on 1/24/25.
//

import SwiftUI


struct Item: Identifiable, Hashable {
    var id: UUID = .init()
    let title: String

    static func build(_ count: Int) -> [Self] {
        (1...count).map {
            Self.init(title: "Item \($0)")
        }
    }
}

struct Fruit: Identifiable, Hashable {
    var id: UUID = .init()
    let title: String

    static func build() -> [Self] {
        [
            .init(title: "Apples"),
            .init(title: "Bananas"),
            .init(title: "Oranges")
        ]
    }
}

struct Vegetable: Identifiable, Hashable {
    var id: UUID = .init()
    let title: String
}

struct ContentView: View {
    let items = Item.build(100)
    let fruits = Fruit.build()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(fruits) { fruit in
                        NavigationLink(fruit.title, value: fruit)
                    }
                } header: {
                    Text("Fruits")
                }
                Section {
                    ForEach(items) { item in
                        NavigationLink(item.title, value: item)
                    }
                } header: {
                    Text("Items")
                }
            }
            .navigationDestination(for: Item.self) { item in
                ItemView(item: item)
            }
            .navigationDestination(for: Fruit.self) { fruit in
                Color.red
                    .overlay(Text(fruit.title))
                    .foregroundStyle(.white)
                    .font(.headline)
            }
        }
    }
}

@Observable
final class ItemModel {
    init() {
        print("ItemModel.init")
    }

    func load() {
        print("ItemModel.load")
    }

    deinit {
        print("ItemModel.deinit")
    }
}

struct ItemView: View {
    let item: Item
    @State var model = ItemModel()

    var body: some View {
        VStack {
            Text(item.title)

            NavigationLink("View Fruit", value: Fruit(title: "Apple"))
            NavigationLink("View Vegetable", value: Vegetable(title: "Zucchini"))
        }
        .task {
            model.load()
        }
        .navigationDestination(for: Vegetable.self) { vegetable in
            Color.green
                .overlay(Text(vegetable.title))
                .foregroundStyle(.white)
                .font(.headline)
        }
    }
}

#Preview {
    ContentView()
}
