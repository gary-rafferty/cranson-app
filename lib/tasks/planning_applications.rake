require 'open-uri'
require 'cranson'

namespace :planning_applications do
  namespace :fingal do
    desc "imports fingal planning applications"
    task :import, [:audit] => [:environment] do |t, args|

      skip_auditing = args.audit == 'false'

      xml_path = "http://data.fingal.ie/datasets/xml/Planning_Applications.xml"

      Plan.auditing_enabled = false if skip_auditing

      authority = Authority.find_by name: 'Fingal County Council'

      document = Cranson::Parsers::Fingal.new
      observer = Observer.new(authority)

      document.add_observer(observer)

      parser = Nokogiri::XML::SAX::Parser.new(document)
      parser.parse(open(xml_path))

      Plan.auditing_enabled = true
    end
  end

  namespace :dcc do
    desc "imports dublin city council planning applications"
    task :import, [:audit] => [:environment] do |t, args|

      skip_auditing = args.audit == 'false'

      csv_path = "http://opendata.dublincity.ie/PandDOpenData/DCC_PlanApps.csv"

      Plan.auditing_enabled = false if skip_auditing

      authority = Authority.find_by name: 'Dublin City Council'

      parser = Cranson::Parsers::Dcc.new
      observer = Observer.new(authority)

      parser.add_observer(observer)

      parser.parse(open(csv_path))

      Plan.auditing_enabled = true
    end
  end
end
