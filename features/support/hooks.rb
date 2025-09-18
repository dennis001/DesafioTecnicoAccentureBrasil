Before do
  options = case BROWSER
            when :chrome
              Selenium::WebDriver::Chrome::Options.new.tap do |opts|
                opts.add_argument('--headless') if HEADLESS
                opts.add_argument('--window-size=1400,900')
              end
            when :firefox
              Selenium::WebDriver::Firefox::Options.new.tap do |opts|
                opts.add_argument('--headless') if HEADLESS
                opts.add_argument('--width=1400')
                opts.add_argument('--height=900')
              end
            else
              nil
            end

  @browser = Watir::Browser.new(BROWSER, options: options)
end

After do |scenario|
  if scenario.failed?
    pasta = 'reports/screenshots'
    FileUtils.mkdir_p(pasta) unless File.directory?(pasta)
    nome_arquivo = "#{pasta}/#{scenario.__id__}.png"
    @browser.screenshot.save(nome_arquivo)
    # Anexa o caminho do screenshot nos detalhes do cenário
    scenario.attach(nome_arquivo, 'image/png', 'Screenshot')
  end
end

After do
  @browser&.close
end