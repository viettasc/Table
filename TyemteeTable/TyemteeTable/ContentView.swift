//
//  ContentView.swift
//  TyemteeTable
//
//  Created by Viettasc Doan on 3/25/20.
//  Copyright © 2020 Viettasc Doan. All rights reserved.
//

import SwiftUI

struct Question: Identifiable {
    var id: Int
    var a: Int
    var b: Int
    var c: Int
}

struct ContentView: View {

    @State var table: Int = 1
    @State var question: Int = 5
    @State var answer: [String] = []
    @State var alert = false
    @State var added = false
    @State var questions: [Question] = []
    
    func add() -> Void {
        added = false
        print("add")
        questions.removeAll()
        answer.removeAll()
        let last = question - 1
        for i in 0...last {
            var a = 0
            var bool = false
            repeat {
                a = Int.random(in: 1...12)
                for item in questions {
                    if item.a == a {
                        bool = true
                        break
                    }
                }
                print("a: ", a)
                bool = false
            } while bool
            
            let c = a * table
            let question = Question(id: i, a: a, b: table, c: c)
            questions.append(question)
            answer.append("0")
        }
        print("answer count: ", answer.count)
        print("answer: ", answer)
        print("question: count", questions.count)
        print("questions: ", questions)
        added = true
    }

    func show() {
        alert.toggle()
    }
    
    func calculate() -> Int {
        var draft = 0
        let last = question - 1
        for i in 0...last {
            if let c = Int(answer[i]),
                c == questions[i].c {
                draft += 1
            }
        }
        return draft
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Avatar")) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                        Image("tyemtee")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .padding()
                    }
                    .frame(height: 231)
                }
                Section(header: Text("Table")) {
                    Stepper("\(table)", value: $table, in: 1...12, onEditingChanged: {_ in self.add()})
                }
                Section(header: Text("Question")) {
                    Stepper("\(question)", value: $question, in: 5...10, onEditingChanged: {_ in self.add()
                    })
                }
                Section(header: Text("Answer")) {
                    if added {
                        ForEach(questions) { question in
                            HStack(spacing: 23) {
                                Text("\(question.a) x \(question.b) = ?")
                                    .frame(width: 100)
                                TextField("answer", text: self.$answer[question.id])
                                    .keyboardType(.numberPad)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }
                Section(header: Text("Submit")) {
                    Button("Ok") {
                        self.show()
                    }
                }
            }
            .navigationBarTitle("Tyemtee")
            .alert(isPresented: $alert) {
                Alert(title: Text("Score"), message: Text("\(calculate())"), dismissButton: .default(Text("Dismiss"), action: {
                }))
            }
            .navigationBarItems(trailing:
                Button("Reset") {
                    self.add()
                }
            )
        }
        .onAppear(perform: add)
        .foregroundColor(Color.pink.opacity(0.6))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

