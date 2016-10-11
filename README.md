# 初期設定

## SwiftLint

    $ brew install swiftlint

### 設定
プロジェクトルートにある、.swiftlint.yml

## cocoapods
各環境でcocoapodsのバージョンを合わせるために、bundlerを使用する  

### ruby version
2.3.1

### bundler install

    $ [sudo] gem install bundler

rbenvを使用している場合は、下記のコマンド

    $ [sudo] rbenv exec gem install bundler
    $ rbenv rehash

Gemfileはプロジェクトルートに含めています

### bundle install

    $ cd $PROJECT_ROOT
    $ bundle install --path=vendor/bundle

### cocoapods command
プロジェクトルートのcocopadsを使用する場合は、下記のコマンドを使用する

    $ bundle exec pod --version
    $ bundle exec pod install
    $ bundle exec pod update


# 環境
+ Xcode 8.0
+ iOS10のみ対応
+ Swift3.0
