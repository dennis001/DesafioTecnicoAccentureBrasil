class ProgressBarPage
  include PageObject

  page_url 'https://demoqa.com/'

  button(:start_stop, id: 'startStopButton')
  div(:progress_bar, id: 'progressBar')
  element(:progress_bar_menu_item, xpath: "//*[text()='Progress Bar']")

  def navegar_ate_progress_bar
    self.goto
    widgets_card = browser.div(class: 'card-body', text: /Widgets/)
    browser.execute_script('arguments[0].scrollIntoView(true);', widgets_card)
    widgets_card.wait_until(&:present?)
    widgets_card.click
    
    browser.wait_until(timeout: 5) { browser.ul.exists? }

    progress_bar_menu_item_element.wait_until(&:present?)
    browser.execute_script('arguments[0].scrollIntoView(true);', progress_bar_menu_item_element.wd)
    progress_bar_menu_item_element.click
  end

  def iniciar_ou_parar_barra
    start_stop
  end

  def valor_atual
    progress_bar_element.text.delete('%').to_i
  end
end