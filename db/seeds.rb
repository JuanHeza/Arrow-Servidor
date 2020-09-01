# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Alert.create(titulo: "stanby", secuencia: [
     ['red', 'white', 'blue', 'green'],
     ['green', 'red', 'white', 'blue'],
     ['blue', 'green', 'red', 'white'],
     ['white', 'blue', 'green', 'red']
  ])
Alert.create(titulo: 'Rojo', secuencia: [
    ['red','red','red','red']
  ] )
Alert.create(titulo: 'Azul', secuencia:  [
    ['blue','blue','blue','blue']
  ])
Alert.create(titulo: 'Blanco', secuencia:  [
    ['white','white','white','white']
  ])
Alert.create(titulo: 'Verde', secuencia:  [
    ['green','green','green','green']
  ])
Alert.create(titulo: 'Friends', secuencia:  [
    ['red','black','yellow','black'],
    ['black','yellow','black','blue'],
    ['yellow','black','blue','black'],
    ['black','blue','black','red'],
    ['blue','black','red','black'],
    ['black','red','black','yellow']
  ])