class User < ApplicationRecord
    validates_presence_of :chat_id, :username
end
