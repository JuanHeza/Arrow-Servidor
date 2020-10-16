# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# uint32_t Colores[27] = {  Black, NavyBlue, Blue, Azure, Teal, Gray, Indigo, Violet, Purpule, Marron, Red, Pink, Magenta, Pink2, Fushia, White, Yellow2, Yellow, Orange, Gold, Lime, Mint2, Aqua, Cyan, Mint, Green, Ao};
# Alert.create(titulo: "stanby", secuencia: [
#      ['red', 'white', 'blue', 'green'],
#      ['green', 'red', 'white', 'blue'],
#      ['blue', 'green', 'red', 'white'],
#      ['white', 'blue', 'green', 'red']
#   ])
# Alert.create(titulo: 'Rojo', secuencia: [
#     ['red','red','red','red']
#   ] )
# Alert.create(titulo: 'Azul', secuencia:  [
#     ['blue','blue','blue','blue']
#   ])
# Alert.create(titulo: 'Blanco', secuencia:  [
#     ['white','white','white','white']
#   ])
# Alert.create(titulo: 'Verde', secuencia:  [
#     ['green','green','green','green']
#   ])
# Alert.create(titulo: 'Friends', secuencia:  [
#     ['red','black','yellow','black'],
#     ['black','yellow','black','blue'],
#     ['yellow','black','blue','black'],
#     ['black','blue','black','red'],
#     ['blue','black','red','black'],
#     ['black','red','black','yellow']
#   ])
Alert.create!(titulo: "Basico", secuencia: [[10, 15, 2, 25], [25, 10, 15, 2], [2, 25, 10, 15], [15, 2, 25, 10]])
Alert.create!(titulo: "Rojo", secuencia: [[10, 10, 10, 10]])
Alert.create!(titulo: "Azul", secuencia: [[2, 2, 2, 2]])
Alert.create!(titulo: "Blanco", secuencia: [[15, 15, 15, 15]])
Alert.create!(titulo: "Verde", secuencia: [[25, 25, 25, 25]])
Alert.create!(titulo: "Friends", secuencia: [[10, 0, 17, 0], [0, 17, 0, 2], [17, 0, 2, 0], [0, 2, 0, 10], [2, 0, 10, 0], [0, 10, 0, 17]])

Event.create!(titulo: "Friends", cuerpo: "Ya va siendo hora de ver friends", estado: true, fecha: Time.now.to_date, hora: "22:20", repeticion: "1", alert_id: Alert.where(titulo: "Friends")[0].id, users_id: [-1])
Event.create!(titulo: "Plantas", cuerpo: "Te toca regar las plantas", estado: true, fecha: Time.now.to_date + 1.day, hora: "10:00", repeticion: "2", alert_id: Alert.where(titulo: "Azul")[0].id, users_id: [-1])

Update.create!(titulo: "Via Web", cuerpo: "La alarma se ha Encendido", clase: "web")#, alert_id: 1, status: true)
Update.create!(titulo: "Via Telegram", cuerpo: "Juan Apago la alarma", clase: "telegram")#, alert_id: 1, status: false)
Update.create!(titulo: "Via Telegram", cuerpo: "Juan Encendio la alarma", clase: "telegram")#, alert_id: 1, status: true)
Update.create!(titulo: "Evento Friends activado", cuerpo: "Ya va siendo hora de ver friends", clase: "evento")#, alert_id: 7, status: true)
Update.create!(titulo: "Via Web", cuerpo: "La alarma se ha Apagado", clase: "web")#, alert_id: 7, status: false)
Update.create!(titulo: "Via Telegram", cuerpo: "Juan activo la serie Friends", clase: "telegram")#, alert_id: 7, status: false)
Update.create!(titulo: "Via Web", cuerpo: "Se activo la serie Friends", clase: "web")#, alert_id: 7, status: false)

# User.create!(chat_id: , username:, first_name:, last_name:, token:)
