#!/bin/bash
# Xcode Command Line Toolsがインストールされてなければインストールを促す。
if !(type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
    test -d "${xpath}" && test -x "${xpath}") ; then
    loop = true;
    while $loop; do
        read -p "Xcode Command Line Toolsが必要です。インストールしますか？ (y/N): " yn
        case "$yn" in
            [yY]*)
                $loop = false;
                xcode-select --install
                ;;   
                [nN]*) read -p "終了しますか？ (y)" yend
                case "$yend" in 
                    [yY]*) exit; ;;
                esac
                ;;
            *) read -p "不正な文字が入力されました。終了しますか？ (y)" yend
                case "$yend" in 
                    [yY]*) exit; ;;
                esac
                ;;
        esac
    done
fi
#保存先
dlDir=~/Videos/YouTube
command -v brew >/dev/null 2>&1 || { 
    loop = true
    while $loop; do
        read -p "Homebrewが必要です。インストールしますか？ (y/N): " yn
        case "$yn" in
            [yY]*)
                $loop = false;
                echo >&2 "Homebrewをインストールします。"; \
                /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; 
                git -C "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core" fetch --unshallow;
            ;;
            [nN]*) read -p "終了しますか？ (y)" yend
                case "$yend" in 
                    [yY]*) exit; ;;
                esac
                ;;
            *) read -p "不正な文字が入力されました。終了しますか？ (y)" yend
                case "$yend" in 
                    [yY]*) exit; ;;
                esac
            ;;
        esac
    done 
}
command -v youtube-dl >/dev/null 2>&1 || { 
    loop = true;
    while $loop; do 
        read -p "youtube-dlが必要です。インストールしますか? (y/N): " yn
        case "$yn" in
            [yY]*)
                $loop = false;
                echo >&2 "youtube-dlをインストールします。"
                brew install youtube-dl; 
            ;;
            [nN]*) read -p "終了しますか？ (y)" yend
                case "$yend" in 
                    [yY]*) exit; ;;
                esac
                ;;
            *) read -p "不正な文字が入力されました。終了しますか？ (y)" yend
                case "$yend" in 
                    [yY]*) exit; ;;
                esac
            ;;
            esac
    done
}
command -v ffmpeg >/dev/null 2>&1 || { 
    loop = true;
    while $loop; do 
        read -p "ffmpegが必要です。インストールしますか? (y/N): " yn
        case "$yn" in
            [yY]*)
                $loop = false;
                echo >&2 "ffmpegをインストールします。"
                brew install ffmpeg; 
            ;;
            [nN]*) read -p "終了しますか？ (y)" yend
                case "$yend" in 
                    [yY]*) exit; ;;
                esac
                ;;
            *) read -p "不正な文字が入力されました。終了しますか？ (y)" yend
                case "$yend" in 
                    [yY]*) exit; ;;
                esac
            ;;
        esac
    done
}
echo >&2 "Homebrewの更新を確認しています..."
brew update
read -p "ffmpegのアップデートをチェックしますか？ (y/N): " yn
    case "$yn" in
        [yY]*)
            brew upgrade ffmpeg; 
        ;;
        *) echo >&2 "ffmpegのアップデートをスキップしました。" ;;
    esac
read -p "youtube-dlのアップデートをチェックしますか？ (y/N): " yn
    case "$yn" in
        [yY]*)
            sudo youtube-dl -U;
        ;;
        *) echo >&2 "youtube-dlのアップデートをスキップしました。" ;;
    esac
if [ ! -d $dlDir ]; then
    echo >&2 "$dlDirにフォルダを作成します。"
    mkdir -p $dlDir
fi
re="https://([^/]+)/"
while true ;do
    cd $dlDir
    read -p "曲だけダウンロードしますか？ (y/N): " yn
    case "$yn" in 
        [yY]*) read -p "URLを入力してください (検索ワードでもOKです。): " search;
            if [[ $search =~ $re ]]; then 
            youtube-dl -x --audio-format mp3 --audio-quality 0 --embed-thumbnail -o '%(title)s.%(ext)s' $search;
            else
            youtube-dl -x --audio-format mp3 --audio-quality 0 --embed-thumbnail -o '%(title)s.%(ext)s' --default-search "ytsearch" "$search";
            fi
        ;;
        *) read -p "URLを入力してください (検索ワードでもOKです。): " search; 
            if [[ $search =~ $re ]]; then 
            youtube-dl -f 22,'bestvideo[ext=mp4]+bestaudio[ext=m4a]' --merge-output-format mp4 -o '%(title)s.%(ext)s' $search;
            else
            youtube-dl -f 22,'bestvideo[ext=mp4]+bestaudio[ext=m4a]' --merge-output-format mp4 -o '%(title)s.%(ext)s' --default-search "ytsearch" "$search";
            fi
        ;;
    esac
    read -p "続けてダウンロードしますか？ (y/N): " yn
    case "$yn" in
        [yY]*);;
        *) exit; ;;
    esac
done