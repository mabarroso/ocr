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

## Using
  - Get a OCR: ocr = OCR.use <OCR_NAME>
  - Set the login Credentials: ocr.login <YOUR_USER>, <YOUR_PASSWORD>, [<EXTRA_LOGIN_DATA>]
  - Set proxy configuration: ocr.proxy p_addr, p_port = nil, p_user = nil, p_pass = nil
  - Set image to work: ocr.file= <FILE_NAME_AND_PATH>
  - Set languaje: ocr.file= <FILE_NAME_AND_PATH>
  - Set output format: ocr.format= <FORMAT_NAME>
  - Set output file: ocr.outputfile= <FILE_NAME_AND_PATH>
  - Test error: error = ocr.error if ocr.error?
  - Results: text = ocr.text unless ocr.error?

### OCR Web Service
  [OCR Web Service](http://www.ocrwebservice.com/).

  Extra properties convert_to_bw=<BOOLEAN>, multi_page_doc=<BOOLEAN>.

```ruby
  ocr = OCR.use :onlineocr

  ocr.login <YOUR_USER>, <YOUR_LICENSE_CODE>
  ocr.file= 'text_image.jpg'
  ocr.format= :pdf
  ocr.outputfile= 'text_doc.pdf'
  ocr.recognize

  puts "ERROR: #{ocr.error}" if ocr.error?
  puts "RESULT: #{ocr.text}" unless ocr.error?
```

# License
Released under the MIT license: [http://www.opensource.org/licenses/MIT](http://www.opensource.org/licenses/MIT)
