namespace :planning_applications do
  desc "import plans from file"
  task :import, [:audit] => [:environment] do |t, args|
    require 'open-uri'
    require 'cranson'

    skip_auditing = args.audit == 'false'

    xml_path = "http://data.fingal.ie/datasets/xml/Planning_Applications.xml"

    Plan.auditing_enabled = false if skip_auditing

    authority = Authority.find_by name: 'Fingal County Council'

    document = Cranson::Parser.new
    observer = Observer.new(authority)

    document.add_observer(observer)

    parser = Nokogiri::XML::SAX::Parser.new(document)
    parser.parse(open(xml_path))

    Plan.auditing_enabled = true
  end
end
