//
//  ViewController.swift
//  TarasovEA_HW2.2.0
//
//  Created by Евгений Тарасов on 24/09/2019.
//  Copyright © 2019 Евгений Тарасов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // some code
    
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redLabelNum: UILabel!
    @IBOutlet var greenLabelNum: UILabel!
    @IBOutlet var blueLabelNum: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 13
        
        // redSlider.tintColor = .red
        // greenSlider.tintColor = .green
        
        setColor()
        setValue(for: redLabelNum, greenLabelNum, blueLabelNum)
        setValue(for: redTextField, greenTextField, blueTextField)

        addDoneButtonTo(redTextField, greenTextField, blueTextField)
    }
    
    //Изменение цветов слайдерами
    @IBAction func rgbSlider(_ sender: UISlider) {
        
        switch sender.tag {
        case 0:
            redLabelNum.text = String(format: "%.2f", sender.value)
            redTextField.text = String(format: "%.2f", sender.value)
        case 1:
            greenLabelNum.text = String(format: "%.2f", sender.value)
            greenTextField.text = String(format: "%.2f", sender.value)
        case 2:
            blueLabelNum.text = String(format: "%.2f", sender.value)
            blueTextField.text = String(format: "%.2f", sender.value)
        default:
            break
        }
        
        setColor()
    }
    
    // Цвет вью
    private func setColor() {
        colorView.backgroundColor = UIColor(red: CGFloat(redSlider.value),
                                            green: CGFloat(greenSlider.value),
                                            blue: CGFloat(blueSlider.value),
                                            alpha: 1)
    }
    
    private func setValue(for labels: UILabel... ) {
        labels.forEach { label in
            switch label.tag {
            case 0:
                redLabelNum.text = string(from: redSlider)
            case 1:
                greenLabelNum.text = String(format: "%.2f", greenSlider.value)
            case 2:
                blueLabelNum.text = String(format: "%.2f", blueSlider.value)
            default: break
            }
        }
    }
    
    private func setValue(for textFields: UITextField... ) {
        textFields.forEach { textField in
            switch  textField.tag {
            case 0:
                redTextField.text = String(format: "%.2f", redSlider.value)
            case 1:
                greenTextField.text = String(format: "%.2f", greenSlider.value)
            case 2:
                blueTextField.text = string(from: blueSlider)
            default: break
            }
        }
    }
    
    // Значения RGB
    private func string(from slider: UISlider) -> String {
        return String(format: "%.2f", slider.value)
    }

}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру нажатием на Return
    // данный метод используется ТОЛЬКО для БУКВЕННОЙ клавиатуры (в цифровой он не нужен)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Скрываем клавиатуру по тапу за пределами Text View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Скрывает клавиатуру вызванную для любого объекта
        view.endEditing(true)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // print(#function)
        
        guard let text = textField.text else { return }
        
        if let currentValue = Float(text) {
            
            switch textField.tag {
            case 0:
                redSlider.value = currentValue
                setValue(for: redLabelNum)
            case 1:
                greenSlider.value = currentValue
                setValue(for: greenLabelNum)
            case 2:
                blueSlider.value = currentValue
                setValue(for: blueLabelNum)
            default: break
            }
            
            setColor()
            
        } else {
            showAlert(title: "Wrong format!", message: "Please, enter correct value.")
        }
    }
}

extension ViewController {
    // Метод, для отображения кнопки Готово на цифровой клавиатуре
    private func addDoneButtonTo(_ textFields: UITextField... ) {
        
        textFields.forEach { textField in
            
            // создаем объект ТулБар (бар над клавиатурой)
            let keyboardToolBar = UIToolbar()
            
            // Это срочка говорит, что при нажатии на определенное текстовое поле у клавиатуры должен появиться ТулБар
            textField.inputAccessoryView = keyboardToolBar
            
            // Размещает вызванный тулбар по размеру клавиатуры
            keyboardToolBar.sizeToFit()
            
            // Создаем саму кноку DONE
            let doneButton = UIBarButtonItem(title: "Done",
                                             style: .done,
                                             target: self,
                                             action: #selector(didTapDone))
            
            // Данная сонстанта определяет, где будет находиться наша кнопка DONE, если мы ее создавать не будем, то кнопка будет находиться слева
            let flexBurButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
            
            // У тулбара может быть много разных элементов, но мы создали два, кнопку и пустое пространство (чтобы сместить кнопку вправо), и передали в наш тулбар
            keyboardToolBar.items = [flexBurButton, doneButton]
        }
    }
    
    // так как мы даннй метод передаем в селектор, то необходимо поставить пометку @objc
    // Скрываем клавиатуру
    @objc private func didTapDone() {
        view.endEditing(true)
    }
    
    
    // метод для отображения окна об ошибочном вводе
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

