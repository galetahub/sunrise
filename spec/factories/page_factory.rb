Factory.define :page, :class => PagePart do |p|
  p.key "main"
  p.content "Test content"
  p.association :partable, :factory => :structure_page
end
