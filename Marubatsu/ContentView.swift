//
//  ContentView.swift
//  Marubatsu
//
//  Created by satoeisuke on 2025/02/15.
//

import SwiftUI

struct Quiz: Identifiable, Codable{
    var id = UUID()   //それぞれの設問を区別するためのID
    var question: String  //問題文
    var answer: Bool  //答え
}





struct ContentView: View {
    
    
    // 問題
    let quizeExamples: [Quiz] = [
        Quiz(question: "iPhoneアプリを開発する統合環境はZcodeである", answer: false),
        Quiz(question: "Xcode画面の右側にはユーティリティーズがある", answer: true),
        Quiz(question: "Textは文字列を表示する際に利用する", answer: true)
    ]
    
    @AppStorage("quiz") var quizData = Data() //UserDefaultsから問題を読み込む(Data型)
    @State var quizzesArray: [Quiz] = [] //問題を入れておく配列
    
    
    @State var currentQuestionNum = 0 // 今何問目
    @State var showingAlert = false //アラートの表示・非表示を制御
    @State var alertTitle: String = ""  //"正解"か"不正解"の文字を入れるもの
    
    //画面生成時に
    init(){
        if let decodeQuizzes = try? JSONDecoder().decode([Quiz].self, from: quizData){
            _quizzesArray = State(initialValue: decodeQuizzes)
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            
            NavigationStack {
                
                VStack {
                    
                    Text(showQuestion())
                        .padding() //余白を外側に追加
                        .frame(width: geometry.size.width * 0.85, alignment: .leading) //横幅を250,左寄せに
                        .font(.system(size: 25))//フォントサイズを２５に
                        .fontDesign(.rounded) //フォントのデザイン
                        .background(.yellow) //背景の色
                    
                    Spacer() //問題文とボタンの幅を広げるための余白を追加
                    
                    //○×ボタンを横並びにするためにHStackをつかう
                    HStack {
                        
                        Button {
                            //print("○") //ボタンが押された時の動作
                            chekAnswer(yourAnswer: true)
                        } label: {
                            Text("○") //ボタンの見た目
                        }
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4) //幅と高さを190に
                        .font(.system(size: 100, weight: .bold)) //フォントサイズ100で太字に
                        .foregroundStyle(.white) //文字色を白に
                        .background(.red) //背景を赤に
                        
                        
                        
                        Button {
                            //print("×") //ボタンが押された時の動作
                            chekAnswer(yourAnswer: false)
                        } label: {
                            Text("×") //ボタンの見た目
                        }
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4) //幅と高さを190に
                        .font(.system(size: 100, weight: .bold)) //フォントサイズ100で太字に
                        .foregroundStyle(.white) //文字色を白に
                        .background(.blue) //背景を青に
                        
                    }
                }
                .padding()
                
                .navigationTitle("○×クイズ") //  ナビゲーションにタイトル設定
                
                //回答時のアラート
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button ("OK", role: .cancel){}
                }
                // 問題作成画面へ遷移するためのボタンを設置
                .toolbar {
                    // 配置する場所を画面最上部のバーの右端に設定
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            CreateView(quizzesArray: $quizzesArray) //遷移先の画面
                                .navigationTitle("問題を作ろう")
                        } label: {
                            Image(systemName: "plus")
                                .font(.title)
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    
    //問題文を表示するための関数
    func showQuestion() -> String {
        //let question = quizeExamples[currentQuestionNum].question
        var question = "問題がありません"
        
        if !quizzesArray.isEmpty {
            let quiz = quizzesArray[currentQuestionNum]
            question = quiz.question
        }
        
        return question
        
    }
    
    // 回答をチェックする関数、正解なら次の問題を表示
    func chekAnswer(yourAnswer: Bool)  {
        
        if quizzesArray.isEmpty {return}
        let quiz = quizzesArray[currentQuestionNum]
        let ans =  quiz.answer
        
        if yourAnswer == ans { //正解の時
            alertTitle = "正解!"
            //現在の問題番号が問題数を超えないように場合分け
            if currentQuestionNum + 1 < quizzesArray.count {
                
                currentQuestionNum += 1 //次の問題に進む
            } else {
                //超える時は0に戻す
                currentQuestionNum = 0
            }
        } else {
            alertTitle = "不正解…"
        }
        
        
        
        showingAlert = true //アラートを表示
        
    }
    
    
}

#Preview {
    ContentView()
}
