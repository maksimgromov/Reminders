//
//  Todo.swift
//  Reminders
//
//  Created by Максим Громов on 19.03.2021.
//

import SwiftUI

struct AddToDoView: View {
  
  @Environment(\.managedObjectContext) var managedObjectContext
  @Environment(\.presentationMode) var presentationMode
  @State private var name: String = ""
  @State private var priority: String = "Normal"
  @State private var errorShowing: Bool = false
  @State private var errorTitle: String = ""
  @State private var errorMessage: String = ""
  @ObservedObject var theme = ThemeSettings.shared
  
  var themes: [Theme] = themeData
  let priorities = ["High", "Normal", "Low"]
  
  var body: some View {
    NavigationView {
      VStack {
        VStack(alignment: .leading, spacing: 20) {
          TextField("Todo", text: $name)
            .padding()
            .background(Color(UIColor.tertiarySystemFill))
            .cornerRadius(9)
            .font(.system(size: 24, weight: .bold, design: .default))

          Picker("Priority", selection: $priority) {
            ForEach(priorities, id: \.self) {
              Text($0)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
          Button(action: {
            if self.name != "" {
              let todo = Todo(context: self.managedObjectContext)
              todo.name = self.name
              todo.priority = self.priority
              do {
                try self.managedObjectContext.save()
              } catch {
                print(error)
              }
            } else {
              self.errorShowing = true
              self.errorTitle = "Invalid Name"
              self.errorMessage = "Make sure to enter something for\nthe new todo item."
              return
            }
            self.presentationMode.wrappedValue.dismiss()
          }) {
            Text("Save")
              .font(.system(size: 24, weight: .bold, design: .default))
              .padding()
              .frame(minWidth: 0, maxWidth: .infinity)
              .background(themes[self.theme.themeSettings].themeColor)
              .cornerRadius(9)
              .foregroundColor(Color.white)
          }
        }
          .padding(.horizontal)
          .padding(.vertical, 30)
        
        Spacer()
      }
        .navigationBarTitle("New Todo", displayMode: .inline)
        .navigationBarItems(trailing:
          Button(action: {
            self.presentationMode.wrappedValue.dismiss()
          }) {
            Image(systemName: "xmark")
          }
      )
        .alert(isPresented: $errorShowing) {
          Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
      }
    }
      .accentColor(themes[self.theme.themeSettings].themeColor)
      .navigationViewStyle(StackNavigationViewStyle())
  }
}


struct AddToDoView_Previews: PreviewProvider {
  static var previews: some View {
    AddToDoView()
      .previewDevice("iPhone 12 Pro")
  }
}

