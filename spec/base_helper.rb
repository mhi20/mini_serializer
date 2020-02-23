module Methods
  def all
    FakeRecords
  end
end

class House
  extend Methods
end

class ForeignHouse
  extend Methods
end

class FakeRecords
  def self.includes(_)
    { simple_field: 'TEXT' }
  end
end
