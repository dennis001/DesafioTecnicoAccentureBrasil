require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'report_builder'
require 'fileutils'

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.cucumber_opts = ENV['CUCUMBER_OPTS'] || ""
end

desc "Executa os testes"
task :default => :cucumber

desc "Gera o relatório com ReportBuilder"
task :report do
  FileUtils.mkdir_p('reports') unless File.directory?('reports')

  ReportBuilder.configure do |config|
    config.input_path = 'reports/report.json'
    config.report_path = 'reports/report_final'
    config.report_types = [:html]
    config.report_title = 'Relatório Automatizado'
    config.color = 'indigo'
    config.additional_info = { 'Ambiente' => ENV['AMBIENTE'] || 'local', 'Headless' => ENV['HEADLESS'] || 'false' }
  end
  ReportBuilder.build_report
end