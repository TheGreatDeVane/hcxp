# collection @bands, root: 'bands'
object false
attributes :id, :name

node(:total) { @bands.length }

child @bands do
  extends "search/band"
end