import UIKit
import Foundation

class ViewController: UIViewController {
    
    var text = [String]()
    var question : String = ""
    var questionCount = [String]()
    var rightAnswer = [String]()
    var wrongAnswer = [String]()
    var plus = [String]()
    var minus = [String]()
    var characters = [String]()
    var answer = [String]()
    var i : Int = 0
    var answered : Int = 0
    var answeredRight : Int = 0
    var answeredWrong : Int = 0
    
    @IBOutlet weak var QuestionLable: UILabel!
    @IBOutlet var AnswerButtons: [UIButton]!
    @IBOutlet weak var HideReloadButton: UIButton!
    @IBOutlet weak var RevealEvaluationButton: UIButton!
    
    @IBOutlet weak var QuestionsRight: UITextField!
    @IBOutlet weak var QuestionStock: UITextField!
    @IBOutlet weak var QuestionDone: UITextField!
    @IBOutlet weak var QuestionPercentage: UITextField!
    
    override func viewDidLoad() {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        do {
            try FileManager.default.createDirectory(atPath: documentsPath, withIntermediateDirectories: false, attributes: nil)
        } catch {
            print(error)
            print(type(of: error))
        }
        
        super.viewDidLoad()
        let pathTester = Bundle.main.path(forResource: "tester", ofType: "txt")
        
        
        do {
            text = try String(contentsOfFile: pathTester!, encoding: String.Encoding.utf8).components(separatedBy: .newlines)
            //let text = try String(contentsOfFile: path!, encoding: String.Encoding.utf8).components(separatedBy: "\n")
        } catch {print("Unable to load file")}
        //Smazani prazdnych elementu
        for i in stride(from: text.count-1, to: 0, by: -1 ) {
            if text [i] == "" || text [i] == "/n"{
                text.remove(at: i)
            }
                //osetreni v pripade mezery na zacatku radku (funguje i pro tabulátor)
            else if text[i].hasPrefix(" "){
                while text[i].hasPrefix(" ") {
                    let text1 : String = String(text[i].dropFirst())
                    text[i] = text1
                }
                
            }
        }
        //spocita vsechny otazky
        for i in 0...text.count - 1 {
            while !text[i].hasPrefix("+") && !text[i].hasPrefix("-"){
                questionCount.append(text[i])
                break
            }
        }
        QuestionStock.text = String(questionCount.count)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //tlačítko na načtení další otázky
    @IBAction func ReloadButton(_ sender: UIButton) {
        
        //nacteni nulovych hodnot
        question = ""
        wrongAnswer = [String]()
        rightAnswer = [String]()
        answer = [String]()
        plus = [String]()
        minus = [String]()
        for x in 0...AnswerButtons.count - 1 {
            AnswerButtons[x].setTitle(nil, for: .normal)
            AnswerButtons[x].backgroundColor = UIColor.clear
            AnswerButtons[x].isSelected = false
        }
        
        
        
        //vytisknuti otazek
        if !text[i].hasPrefix("+") && !text[i].hasPrefix("-"){
            while !text[i].hasPrefix("+") && !text[i].hasPrefix("-"){
                if text[i] == ""{
                    text.remove(at: i)
                }else {
                    question = (text[i])
                    i += 1
                }
            }
            while text[i].hasPrefix("+") || text[i].hasPrefix("-") {
                if i >= (text.count - 1){
                    break
                } else {
                    answer.append(text[i])
                    i += 1
                }
            }
        }
        //priradi text otazky do QuestionLable
        QuestionLable.text = question
        
        
        //zobrazi spravne a spatne odpovedi
        for x in 0...answer.count - 1 {
            if answer[x].hasPrefix("+") {
                let text1 : String = String(answer[x].dropFirst())
                AnswerButtons[x].setTitle(text1, for: .normal)
                plus.append(text1)
            } else if answer[x].hasPrefix("-"){
                let text2 : String = String(answer[x].dropFirst())
                AnswerButtons[x].setTitle(text2, for: .normal)
                minus.append(text2)
            }
        }
        
        //vypnuti vsech tlacitek ktera jsou nevyplnena
        for x in 0...AnswerButtons.count - 1 {
            if AnswerButtons[x].currentTitle != nil{
                AnswerButtons[x].isEnabled = true
            } else {
                AnswerButtons[x].isEnabled = false
            }
        }
        //skryje tlacitko pro dalsi otazku a odkryje tlacitko pro kontrolu odpovedi
        HideReloadButton.isHidden = true
        HideReloadButton.isEnabled = false
        RevealEvaluationButton.isEnabled = true
        RevealEvaluationButton.isHidden = false
    }
    
    @IBAction func EvaluationButton(_ sender: Any) {
        var rightAnswer : Int = 0
        var wrongAnswer : Int = 0
        answered += 1
        QuestionDone.text = String(answered)
        //vyhodnocuje otazku
            for x in 0...AnswerButtons.count - 1{
                if AnswerButtons[x].isSelected == true && minus.isEmpty == false{
                    //kontroluje pritomnost vybrane odpovedi v poli spatnycho odpovedi pokud je spatna zobrazi cervene
                    for y in 0...minus.count - 1{ //problem s otazkami ktere nemaji spatnou odpoved "Can't form Range with upperBound < lowerBound"
                        if AnswerButtons[x].currentTitle == minus[y]{
                            AnswerButtons[x].backgroundColor = UIColor.red
                            wrongAnswer += 1
                            break
                        } else {
                            continue
                        }
                    }
                    
                }else {
                    continue
                }
            }
            for x in 0...AnswerButtons.count - 1 {
                if AnswerButtons[x].isSelected == true && plus.isEmpty == false {
                    //kontroluje pritomnost vybrane odpovedi v poli spatnycho odpovedi pokud je spravna zobrazi zelene
                    for y in 0...plus.count - 1{
                        if AnswerButtons[x].currentTitle == plus[y]{
                            AnswerButtons[x].backgroundColor = UIColor.green
                            rightAnswer += 1
                        } else {
                            continue
                        }
                    }
                    
                }else {
                    continue
                }
            }
        for x in 0...AnswerButtons.count - 1 {
            if (minus.isEmpty == false){
                for y in 0...minus.count - 1{
                    if AnswerButtons[x].currentTitle == minus[y]{
                        let currentTytle = AnswerButtons[x].currentTitle
                        let wrong = "❌"
                        let newTytle = currentTytle! + wrong
                        AnswerButtons[x].setTitle(newTytle, for: .normal)
                        
                    }
                }
            }
            if (plus.isEmpty == false){
                for y in 0...plus.count - 1{
                    if AnswerButtons[x].currentTitle == plus[y]{
                        let currentTytle = AnswerButtons[x].currentTitle
                        let right = "✅"
                        let newTytle = currentTytle! + right
                        AnswerButtons[x].setTitle(newTytle, for: .normal)
                    }
                }
            }
        }
        
        //pocita spravne a spatne odpovedi
        if rightAnswer == plus.count && wrongAnswer == 0 {
            answeredRight += 1
            QuestionsRight.text = String(answeredRight)
        } else {
            answeredWrong += 1
        }
        //skryje tlacitko pro kontrolu odpovedi a odktyje tlacitko pro dalsi otazku
        HideReloadButton.isHidden = false
        HideReloadButton.isEnabled = true
        RevealEvaluationButton.isEnabled = false
        RevealEvaluationButton.isHidden = true
        rightAnswer = 0
        wrongAnswer = 0
        
        for i in 0...AnswerButtons.count - 1 {
            AnswerButtons[i].setTitleColor(.black, for: .normal)
        }
        
        let percentageComputing = ((100 * answeredRight / answered))
        QuestionPercentage.text = String(percentageComputing) + ("%")
        
    }
    
    
    
    @IBAction func answerButtonPressed(_ sender: Any) {
        
        if (AnswerButtons[((sender as AnyObject).tag) - 1].isSelected == true)
        {
            AnswerButtons[((sender as AnyObject).tag) - 1].backgroundColor = UIColor.white
            AnswerButtons[((sender as AnyObject).tag) - 1].setTitleColor(.black, for: .normal)
            AnswerButtons[((sender as AnyObject).tag) - 1].isSelected = false
            
        }
        else
        {
            AnswerButtons[((sender as AnyObject).tag) - 1].backgroundColor = UIColor.blue
            AnswerButtons[((sender as AnyObject).tag) - 1].setTitleColor(.white, for: .normal)
            AnswerButtons[((sender as AnyObject).tag) - 1].isSelected = true
        }
    }
    
    
}

