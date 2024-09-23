//
//  ContentView.swift
//  iExpense
//
//  Created by David Hernandez on 15/08/24.
//
import SwiftUI

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in //aqui vamos a cambiar el loop para que despliegue toda la info relevante del expense que queremos usar
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                            .foregroundColor(item.amount < 10 ? .green : item.amount < 100 ? .orange : .red)
                            .font(item.amount < 10 ? .body : item.amount < 100 ? .headline : .title3)
                            .padding(5)
                            .background(item.amount < 10 ? Color.green.opacity(0.2) : item.amount < 100 ? Color.orange.opacity(0.2) : Color.red.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                    }
                    .accessibilityElement()
                    .accessibilityLabel("\(item.name), \(item.amount.formatted(.currency(code: "USD")))") //VoiceOver support
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses) //links this view with AddView and
        }
        
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
}

struct ExpenseItem: Identifiable, Codable {
    var id = UUID() //UUID - UNIVERSALLY UNIQUE IDENTIFICATION NUMBER
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
   }


#Preview {
    ContentView()
}
