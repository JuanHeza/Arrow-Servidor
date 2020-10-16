require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # ensure Todo model has a 1:m relationship with the Item model
  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:chat_id) }
  it { should validate_presence_of(:username) }
end
