require "rails_helper"

# Test suite for the Todo model
RSpec.describe Alert, type: :model do
  # Association test
  # ensure Todo model has a 1:m relationship with the Item model
  it { should have_many(:events).dependent(:destroy) }
  # it { should have_many(:updates).dependent(:destroy) }
  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:titulo) }
  it { should validate_presence_of(:secuencia) }
end
