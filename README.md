#OCR
 OCR web services gateway for Ruby.

#Description
  Recognize text and characters from image files using web services.

##Web services supported
  - [OCR Web Service](http://www.ocrwebservice.com/)([Online OCR](http://www.onlineocr.net/))
    * identify: Username and license code as password
    * languages: :brazilian, :byelorussian, :bulgarian, :catalan, :croatian, :czech, :danish, :dutch, :english, :estonian, :finnish, :french, :german, :greek, :hungarian, :indonesian, :italian, :latin, :latvian, :lithuanian, :moldavian, :polish, :portuguese, :romanian, :russian, :serbian, :slovakian, :slovenian, :spanish, :swedish, :turkish, :ukrainian
    * output formats: :doc, :pdf, :excel, :html, :txt, :rtf

#Installation
##From the command line

```shell
  gem install ocr
```

##Using Gemfile

1 Add to your application Gemfile

```ruby
gem 'ocr'
```

2 Type

```shell
  bundle install
```

# License
Released under the MIT license: [http://www.opensource.org/licenses/MIT](http://www.opensource.org/licenses/MIT)
