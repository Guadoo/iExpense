//
//  ContentView.swift
//  iExpense
//
//  Created by Guadoo on 2021/5/21.
//

import SwiftUI



class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
    
}


struct ContentView : View {
    
    @ObservedObject var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in

                    HStack {
                        VStack(alignment: .leading ) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        
                        if item.amount < 10 {
                            Text("$ \(item.amount)")
                                .background(Color.green)
                                .foregroundColor(.white)
                        } else if item.amount < 100 {
                            Text("$ \(item.amount)")
                                .background(Color.yellow)
                                .foregroundColor(.white)
                        } else {
                            Text("$ \(item.amount)")
                                .background(Color.red)
                                .foregroundColor(.white)
                        }
                    }
                    
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.showingAddExpense = true
                    }, label: {
                        Image(systemName: "rectangle.stack.badge.plus")
                    })
            )
            .toolbar {
                EditButton()
            }

            .sheet(isPresented: $showingAddExpense){
                AddView(expenses: self.expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
