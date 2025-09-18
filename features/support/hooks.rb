Before do
  # Setup necessário antes de cada cenário de API
end

After do
  # Cleanup necessário após cada cenário de API
end

# AfterConfiguration do
#   at_exit do
#     ReportBuilder.configure do |config|
#       config.input_path = 'reports/report.json'
#       config.report_path = 'reports/automacao_api'
#       config.report_types = [:html]
#       config.report_title = 'Desafio Técnico Accenture - API'
#       config.color = 'indigo'
#       config.additional_info = { 'Projeto' => 'Desafio Accenture', 'Ambiente' => 'DemoQA', 'Data' => Time.now }
#     end
#     ReportBuilder.build_report
#   end
# end