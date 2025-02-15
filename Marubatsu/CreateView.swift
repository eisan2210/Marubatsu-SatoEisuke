//
//  CreateView.swift
//  Marubatsu
//
//  Created by satoeisuke on 2025/02/15.
//

import SwiftUI

struct CreateView: View {
    @Binding var quizzesArray: [Quiz] //回答画面で読み込んだ問題を受け取る
    @State private var questionText = "" //テキストフィールドの文字を受け取る
    @State private var selectAnswer = "○" //ピッカーで選ばれた回答を受け取る
    let answes = ["○", "×"] // ピッカーの選択肢の一覧
    
    var body: some View {
        VStack {
            Text("問題文と解答を入力して、追加ボタンを押してください。")
                .foregroundStyle(.gray)
                .padding()
            
            //　問題文を入力するテキストフィールド
            TextField(text: $questionText) {
                Text("問題文を入力してください")
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            
            //回答を選択するピッカー
            Picker("解答", selection: $selectAnswer) {
                ForEach(answes, id: \.self){ answe in
                    Text(answe)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            
            //追加ボタン
            Button {
                // 追加ボタンが押されたときの処理
                addQuiz(question: questionText, answer: selectAnswer)
            } label: {
                Text("追加")
            }
            .padding()
            
            Button {
                quizzesArray.removeAll() //配列を空に
                UserDefaults.standard.removeObject(forKey: "quiz")
            } label: {
                Text("全削除")
            }
            .foregroundStyle(.red)
            .padding()
            
        }
    }
    
    func addQuiz(question: String, answer: String) {
        if question.isEmpty {
            print("問題文が入力されていません")
            return
        }
        
        var saveingAnswer = true //　保存するためのtrue/falseを入れる変数
        
        //○か×で、turu/falseを切り替える
        switch answer {
        case "○":
            saveingAnswer = true
        case "×":
            saveingAnswer = false
        default:
            print( "適切な答えが入っていません")
            break
        }
        
        let newQuiz = Quiz(question: question, answer: saveingAnswer)
        
        var array: [Quiz] = quizzesArray //一時的に変数を入れておく
        array.append(newQuiz) // 作った問題を配列に追加
        let storeKye = "quiz" // UserDefaultsに保存するためのキー
        
        // エンコードできたら保存
        if let encodQuizzes = try? JSONEncoder().encode(array) {
            UserDefaults.standard.setValue(encodQuizzes, forKey: storeKye)
            questionText = "" //テキストフィールドを空白に戻す
            quizzesArray = array //[既存問題 + 新問題]となった配列に更新
        }
        
        
        
    }
    
    
}

#Preview {
   // CreateView()
}
