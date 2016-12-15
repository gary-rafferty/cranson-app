namespace :planning_applications do
  desc "import plans from file"
  task import: :environment do
    require 'cranson'

    xml_path = Rails.root.join('lib', 'applications_1216.xml')

    document = Cranson::Parser.new
    document.add_observer(Observer.new)
    parser = Nokogiri::XML::SAX::Parser.new(document)
    parser.parse(File.open(xml_path))
  end
end
