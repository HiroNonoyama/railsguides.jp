require "cases/helper"

class Mysql2UnsignedTypeTest < ActiveRecord::Mysql2TestCase
  self.use_transactional_tests = false

  class UnsignedType < ActiveRecord::Base
  end

  setup do
    @connection = ActiveRecord::Base.connection
    @connection.create_table("unsigned_types", force: true) do |t|
      t.column :unsigned_integer, "int unsigned"
    end
  end

  teardown do
    @connection.drop_table "unsigned_types"
  end

  test "unsigned int max value is in range" do
    assert expected = UnsignedType.create(unsigned_integer: 4294967295)
    assert_equal expected, UnsignedType.find_by(unsigned_integer: 4294967295)
  end

  test "minus value is out of range" do
    assert_raise(RangeError) do
      UnsignedType.create(unsigned_integer: -10)
    end
  end
end