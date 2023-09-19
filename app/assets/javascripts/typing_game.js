  // app/assets/javascripts/application.js
  //= require jquery
  //= require jquery_ujs
  //= require chartkick
  //= require Chart.bundle

const startButton = document.getElementById("start-button");

// ゲームの単語リスト
let words = [];

let score = 0;
let timeLeft = 60;
let isPlaying = false;

const wordDisplay = document.getElementById("word-display");
const userInput = document.getElementById("user-input");
const scoreValue = document.getElementById("score-value");
const timerValue = document.getElementById("timer-value");

// ランダムな単語を表示
function showWord() {
    if (words.length === 0) {
        fetch('/words/random_word')
            .then(response => response.json())
            .then(data => {
                wordDisplay.textContent = data.word;
            })
            .catch(error => {
                console.error('Error fetching random word:', error);
            });
    } else {
        const randomIndex = Math.floor(Math.random() * words.length);
        wordDisplay.textContent = words[randomIndex];
    }
}

// ゲームの開始
function startGame() {
    if (!isPlaying) {
        isPlaying = true;
        score = 0;
        scoreValue.textContent = score;
        userInput.value = "";
        userInput.focus();

        // タイマーの設定
        const timerInterval = setInterval(() => {
            timeLeft--;
            timerValue.textContent = timeLeft + "秒";

            if (timeLeft <= 0) {
                clearInterval(timerInterval);
                isPlaying = false;
                wordDisplay.textContent = "ゲーム終了!";
            }
        }, 1000);

        showWord();
    }
}

startButton.addEventListener("click", startGame);

// 単語が正しいか確認
function checkWord() {
    if (isPlaying) {
        if (userInput.value === wordDisplay.textContent) {
            score++;
            scoreValue.textContent = score;
            userInput.value = "";
            showWord();
        }
    }
}

// イベントリスナーを設定
userInput.addEventListener("input", checkWord);
document.addEventListener("DOMContentLoaded", () => {
    userInput.addEventListener("input", checkWord);
    document.getElementById("start-button").addEventListener("click", startGame);
});