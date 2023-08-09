  function getOS() {
  var userAgent = window.navigator.userAgent,
    platform = window.navigator.platform,
    macosPlatforms = ['Macintosh', 'MacIntel', 'MacPPC', 'Mac68K'],
    windowsPlatforms = ['Win32', 'Win64', 'Windows', 'WinCE'],
    iosPlatforms = ['iPhone', 'iPad', 'iPod'],
    os = null;

  if (macosPlatforms.indexOf(platform) !== -1) {
    os = 'Mac OS';
  } else if (iosPlatforms.indexOf(platform) !== -1) {
    os = 'iOS';
  } else if (windowsPlatforms.indexOf(platform) !== -1) {
    os = 'Windows';
  } else if (/Android/.test(userAgent)) {
    os = 'Android';
  } else if (/Linux/.test(platform)) {
    os = 'Linux';
  }

  return os;
  }
    // クライアント側のウィンドウ情報をサーバーに送信  
    function getActiveWindowTitle() {
      var activeWindowTitle = document.title; // この部分を適切なコードに置き換える
      return activeWindowTitle;
    }
    
    // サーバーにウィンドウ情報を送信する関数
    function sendLogDataToServer(data) {
      var csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
      
      var xhr = new XMLHttpRequest();
      xhr.open("POST", "/save-log", true); // サーバーのエンドポイントに合わせて変更
      xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
      xhr.setRequestHeader("X-CSRF-Token", csrfToken); // CSRFトークンをヘッダーに追加
      xhr.send(JSON.stringify(data));
    }
    
    function sendActiveWindowInfoToServer() {
      var csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
      var activeWindowTitle = getActiveWindowTitle();
      var data = {
        active_window: activeWindowTitle,
        authenticity_token: csrfToken // 取得したCSRFトークンを使う
        };
  
    fetch('/save-active-window', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    })
  .then(response => {
    if (response.ok) {
      console.log('Active window info saved successfully');
    } else {
      console.error('Failed to save active window info');
    }
  })
  .catch(error => {
    console.error('Error saving active window info:', error);
  });
}

// 一定の間隔でアクティブなウィンドウの情報を送信
//setInterval(sendActiveWindowInfoToServer, 60000); // 60秒ごとに送信

    
   // ページが読み込まれたときに最初のOS情報を取得
 document.addEventListener('DOMContentLoaded', function() {
    var clientOS = getOS();
    var osInfoElement = document.getElementById('os-info');
    osInfoElement.textContent = '現在のOS: ' + clientOS;
    
    var activeWindowTitle = getActiveWindowTitle();
    var windowInfoElement = document.getElementById('window-info');
    windowInfoElement.textContent = 'アクティブなウィンドウ: ' + activeWindowTitle;

  　var data = {
    os: clientOS,
    windowInfo: activeWindowTitle
  　};    
  　
    sendLogDataToServer(data);
  });
  