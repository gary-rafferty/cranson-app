# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
Authority.find_or_create_by(name: 'Fingal County Council')
Authority.find_or_create_by(name: 'Dublin City Council')
