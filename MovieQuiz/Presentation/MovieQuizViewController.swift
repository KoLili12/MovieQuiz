import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(deligate: self)
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
            presenter.yesButtonClicked()
        }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
            presenter.noButtonClicked()
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
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        
        // создайте и покажите алерт
        let alert = AlertModel(title: "Ошибка", message: message, buttonTitle: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alertPresenter?.presentAlert(modelPr: alert)
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
}

// MARK: - AlertDeligate

extension MovieQuizViewController: AlertDeligate {
    func didReceiveResultAlert() { // метод делегата для алерта
        self.presenter.restartGame()
    }
}
