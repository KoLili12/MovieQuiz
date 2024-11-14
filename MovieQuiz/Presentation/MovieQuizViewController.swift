import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    var alertPresenter: AlertPresenterProtocol?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(deligate: self)
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - Private functions
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.ypBlack.cgColor // теперь края сбрасывают цвет
        yesButton.isEnabled = true // включаем кнопку
        noButton.isEnabled = true // включаем кнопку
    }
    
    func show(result: AlertModel) {
        alertPresenter?.presentAlert(modelPr: result)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func showNetworkError(message: String) {
        // создайте и покажите алерт
        let alert = AlertModel(title: "Ошибка", message: message, buttonTitle: "Попробовать еще раз")
        alertPresenter?.presentAlert(modelPr: alert)
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
            yesButton.isEnabled = false // выключаем кнопку
            presenter.yesButtonClicked()
        }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
            noButton.isEnabled = false // выключаем кнопку
            presenter.noButtonClicked()
        }
}

// MARK: - AlertDeligate

extension MovieQuizViewController: AlertDeligate {
    func didReceiveResultAlert() { // метод делегата для алерта
        self.presenter.restartGame()
    }
}
