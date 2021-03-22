//
//  ContentView.swift
//  Reminders
//
//  Created by Максим Громов on 19.03.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
  
  @Environment(\.managedObjectContext) var managedObjectContext
  @EnvironmentObject var iconSettings: IconNames
  @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
  @State private var showingAddTodoView: Bool = false
  @State private var animatingButton: Bool = false
  @State private var showingSettingsView: Bool = false
  @ObservedObject var theme = ThemeSettings.shared
  
  var themes: [Theme] = themeData
  
  var body: some View {
    NavigationView {
      ZStack {
        List {
          ForEach(self.todos, id: \.self) { todo in
            HStack {
              Circle()
                .frame(width: 12, height: 12, alignment: .center)
                .foregroundColor(self.colorize(priority: todo.priority ?? "Normal"))
              Text(todo.name ?? "Unknown")
                .fontWeight(.semibold)
              Spacer()
              Text(todo.priority ?? "Unknown")
                .font(.footnote)
                .foregroundColor(Color(UIColor.systemGray2))
                .padding(3.0)
                .frame(minWidth: 62)
                .overlay(Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75))
            }
            .padding(.vertical,  10.0)
          }
          .onDelete(perform: deleteTodo)
        }
        .navigationBarTitle("Reminders", displayMode: .inline)
        .navigationBarItems(
          leading: EditButton().accentColor(themes[self.theme.themeSettings].themeColor),
          trailing:
                              Button(action: {
                                self.showingSettingsView.toggle()
                              }){Image(systemName: "paintbrush")
                                .imageScale(.large)
                                .accentColor(themes[self.theme.themeSettings].themeColor)
                                .sheet(isPresented: $showingSettingsView) {
                                  SettingsView().environmentObject(self.iconSettings)
                                }
                            })
        if todos.count == 0 {
          EmptyListView()
        }
      }
      .sheet(isPresented: $showingAddTodoView) {
        AddToDoView().environment(\.managedObjectContext, self.managedObjectContext)
      }
      .overlay(
        ZStack {
          Group {
            Circle()
              .fill(themes[self.theme.themeSettings].themeColor)
              .opacity(self.animatingButton ? 0.2 : 0)
              .frame(width: 68, height: 68, alignment: .center)
            Circle()
              .fill(themes[self.theme.themeSettings].themeColor)
              .opacity(self.animatingButton ? 0.15 : 0)
              .frame(width: 88, height: 88, alignment: .center)
          }
          Button(action: {
            self.showingAddTodoView.toggle()
          }) {
            Image(systemName: "plus.circle.fill")
              .resizable()
              .scaledToFit()
              .background(Circle().fill(Color("ColorBase")))
              .frame(width: 48, height: 48, alignment: .center)
          }
          .accentColor(themes[self.theme.themeSettings].themeColor)
          .onAppear(perform: {
            self.animatingButton.toggle()
          })
        }
        .padding(.bottom, 15)
        .padding(.trailing, 15)
        , alignment: .bottomTrailing
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
  private func deleteTodo(at offsets: IndexSet) {
    for index in offsets {
      let todo = todos[index]
      managedObjectContext.delete(todo)
      do {
        try managedObjectContext.save()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  private func colorize(priority: String) -> Color {
    switch priority {
    case "High":
      return .pink
    case "Normal":
      return .green
    case "Low":
      return .blue
    default:
      return .gray
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      return ContentView()
        .environment(\.managedObjectContext, context)
        .previewDevice("iPhone 12 Pro")
  }
}

