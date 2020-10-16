class UsersController < ApplicationController
  def self.new_User(id, username, first_name, last_name)
    user = User.where(username: username)
    if user.count > 0
      if user[0].chat_id == id && user[0].first_name == first_name && user[0].last_name == last_name
        puts "El usuario #{username} esta al dia"
      else
        user.update(chat_id: id, first_name: first_name, last_name: last_name)
        puts "usuario actualizado #{user.username}"
      end
    else
      User.create(chat_id: id, username: username, first_name: first_name, last_name: last_name)
      puts "Usuario #{username} creado"
    end
  end

  def self.destroy(id)
    user = User.where(chat_id: id)
    if user.count > 0
      user.destroy
    else
      puts "el usuario no existe"
    end
  end

  def self.getUsers(names)
    users = []
    pp names
    if names == "Todos"
      list = User.all
      list.each do |user|
        users.push user.chat_id
      end
    else
      list = names.split(",", -1)
      list.each do |name|
        pp name
        data = name.split(" ", -1)
        user = User.where(first_name: data[0].capitalize, last_name: data[1].capitalize)[0]
        if user != nil
          users.push user.chat_id
        end
      end
    end
    users
  end
end
