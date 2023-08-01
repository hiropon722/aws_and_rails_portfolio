require 'ffi'
require 'rbconfig'

module ApplicationHelper
  module User32
    extend FFI::Library

    case RbConfig::CONFIG['host_os']
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      ffi_lib 'user32'
      attach_function :GetForegroundWindow, [], :pointer
      attach_function :GetWindowTextA, [:pointer, :pointer, :int], :int
    when /darwin/
      # macOS用のメソッドはすでに定義しているので、ここでは何もする必要はありません
    else
      # Linux用のメソッドはすでに定義しているので、ここでは何もする必要はありません
    end
  end

  # macOS用のメソッド
  def get_active_window_title_macos
    script = 'tell application "System Events" to get name of first process whose frontmost is true'
    title = `osascript -e '#{script}'`.strip
  end

  # Linux用のメソッド
  def get_active_window_title_linux
      # DISPLAY変数を取得するためのコマンドを実行
    display_cmd = 'echo $DISPLAY'
    display = `#{display_cmd}`.strip

    # xpropコマンドでウィンドウのタイトルを取得
    xprop_cmd = "xprop -id $(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}') _NET_WM_NAME"
    title = `#{xprop_cmd} | awk -F '\"' '{print $2}'`.strip
  end

  # Windows用のメソッド
  def get_active_window_title_windows
    hWnd = User32.GetForegroundWindow
    title = ' ' * 1024
    User32.GetWindowTextA(hWnd, title, 1024)
    title.strip
  end

  # OSによる条件分岐を行い、適切なメソッドを呼び出す
  def get_active_window_title
    case RbConfig::CONFIG['host_os']
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      get_active_window_title_windows
    when /darwin/
      get_active_window_title_macos
    else
      get_active_window_title_linux
    end
  end

  def log_active_window_information
    prev_proc_name ||= ""

    proc_name = get_active_window_title

    # アクティブなプロセスが変わっていなければ何もしない
    if proc_name == prev_proc_name
      return
    end

    # 一件前の情報を覚える
    prev_proc_name = proc_name

    # ログメッセージを組み立てる
    log_message = "\t#{proc_name.gsub("\t", " ").gsub("\n", "")}"
    log_message = log_message.force_encoding("UTF-8")
    
    # ログ情報をUserデータベースに保存
    write_log(log_message, current_user)

    # ログメッセージを返すか、ビューに表示するためのインスタンス変数に格納するなどの実装も考えられます
    log_message

  end
  
  def write_log(log_message, user)
    begin
        log = user.logs.create(log_message: log_message)
        return true if log.persisted?
    rescue => e
      @error_message = e.message
      # 所詮ログファイルなので、書き込みに失敗しても無視する
    end
    return false
  end

end
