# frozen_string_literal: true

require 'spec_helper'

describe MiniSerializer::Serializer do
  describe '#initialize' do
    describe 'Association methods' do
      before :each do
        @object_serializer = described_class.new([{ simple_field: 'TEXT' }])
      end
      describe '#add_has_many' do
        context 'Create some object as add_has_many' do
          it 'one object for association' do
            expect(@object_serializer.add_has_many('products'))
              .to be == [['products', []]]
          end

          it 'two object for association' do
            @object_serializer.add_has_many('products')
            expect(@object_serializer.add_has_many('houses'))
              .to be == [['products', []], ['houses', []]]
          end
        end
      end

      describe '#add_has_one' do
        context 'Create some object as add_has_one' do
          it 'one object for association' do
            expect(@object_serializer.add_has_one('product'))
              .to be == [['product', []]]
          end

          it 'two object for association' do
            @object_serializer.add_has_one('product')
            expect(@object_serializer.add_has_one('house'))
              .to be == [['product', []], ['house', []]]
          end
        end
      end
    end
    # describe 'Get params included' do end
  end
end
