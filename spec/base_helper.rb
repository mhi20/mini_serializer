class House
  def self.all
    FakeRecords
  end
end

class FakeRecords
  def self.includes(_)
    { simple_field: 'TEXT' }
  end
end
