class Petition < CouchRest::ExtendedDocument
  property :name
  property :description
  property :signatures, :cast_as => ['Signature']
end
