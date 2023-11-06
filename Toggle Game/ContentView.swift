//
//  ContentView.swift
//  Toggle Game
//
//  Created by Fendada on 2023/11/5.
// written by Fendada in ysu

import SwiftUI


struct CircleState {
    var isToggled: Bool
}


struct ContentView: View {
    let gridSize = 5
    
    @State private var circleStates: [[CircleState]]
    @State private var isGameWon = false
    @State private var circleColor = Color.green
    @State private var isColorPickerShown = false
    
    
    init() {
        circleStates = Array(repeating: Array(repeating: CircleState(isToggled: false), count: gridSize), count: gridSize)
    }
    
    var body: some View {
    NavigationView {
            VStack {
                Spacer()
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: gridSize), spacing: 10) {
                    ForEach(0..<gridSize * gridSize, id: \.self) { index in
                        let row = index / gridSize
                        let column = index % gridSize
                        
                        let isToggled = circleStates[row][column].isToggled
                        
                        Circle()
                            .foregroundColor(isToggled ? Color.white:circleColor)
                            .overlay(
                                Circle()
                                    .stroke(circleColor, lineWidth: 2)
                            )
                            .frame(width: 70, height: 70)
                            .onTapGesture {
                                for i in 0..<gridSize {
                                    circleStates[row][i].isToggled.toggle()
                                    circleStates[i][column].isToggled.toggle()
                                }
                                
                                circleStates[row][column].isToggled.toggle()
                                checkWinCondition()
                            }
                            .onAppear {
                                resetGame()
                            }
                    }
                }
                .padding()
                .alert(isPresented: $isGameWon) {
                            Alert(
                                title: Text("游戏胜利！"),
                                message: nil,
                                //dismissButton: .default(Text("确定"))
                                primaryButton: .default(Text("返回"), action: {
                                    // 处理返回按钮的逻辑
                                    // 例如重置游戏状态
                                }),
                                secondaryButton: .default(Text("再来一局"), action: {
                                    resetGame()
                                })
                            )
                        }
                Spacer()
            }
            .navigationTitle("Toggle Game")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isColorPickerShown = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            
            .sheet(isPresented: $isColorPickerShown, onDismiss: {
                // 当颜色选择器关闭时的逻辑
            }) {
                ColorPicker("选择颜色", selection: $circleColor)
                    //.padding()
            }
        }
    }
    
    private func resetGame(){
        for _ in 0...20 {
            let x = Int.random(in: 0...4)
            let y = Int.random(in: 0...4)
            
            for i in 0..<gridSize {
                circleStates[x][i].isToggled.toggle()
                
                circleStates[i][y].isToggled.toggle()
            }
            
            circleStates[x][y].isToggled.toggle()
        }
        isGameWon = false
    }
    
    private func checkWinCondition() {
        var allEmpty = true
        
        for row in circleStates {
            for circleState in row {
                if !circleState.isToggled {
                    allEmpty = false
                    break
                }
            }
            
            if !allEmpty {
                break
            }
        }
            
        if allEmpty {
            isGameWon = true
        }
    }
}

#Preview {
    ContentView()
}
