namespace :planning_applications do
  desc "import plans from file"
  task import: :environment do
    require 'open-uri'
    require 'cranson'
    
    xml_path = "http://data.fingal.ie/datasets/xml/Planning_Applications.xml"

    document = Cranson::Parser.new
    document.add_observer(Observer.new)
    parser = Nokogiri::XML::SAX::Parser.new(document)
    parser.parse(open(xml_path))
  end
end
