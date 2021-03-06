require 'spec_helper'

describe MiniSerializer::Serializer do
  describe '#get_params_included_to_json' do
    before :each do
      @object_serializer = described_class.new(House.all)
    end
    context 'Format' do
      before :each do
        @object_serializer.add_has_one 'product'
        @object_serializer.add_has_many 'categories'
      end

      it 'Not empty response' do
        expect(@object_serializer
                   .get_params_included_to_json.empty?)
            .not_to be_truthy
      end
      it 'Get Hash response get_params_included_to_json method' do
        expect(@object_serializer
                   .get_params_included_to_json.class)
            .to be == Hash
      end

      it 'Get Hash include:categories response data' do
        expect(@object_serializer
                   .get_params_included_to_json[:include]['categories'].class)
            .to be == Hash
      end

      it 'Get Hash include:categories:except response data' do
        expect(@object_serializer
                   .get_params_included_to_json[:include]['categories'][:except].class)
            .to be == Array
      end

      it 'Get Hash include:product response data' do
        expect(@object_serializer
                   .get_params_included_to_json[:include]['product'].class)
            .to be == Hash
      end

      it 'Get Hash include:product:except response data' do
        expect(@object_serializer
                   .get_params_included_to_json[:include]['product'][:except].class)
            .to be == Array
      end

      it 'Include param must be symbol' do
        expect(@object_serializer
                   .get_params_included_to_json
                   .keys
                   .first
                   .class)
            .to be == Symbol
      end

      it 'Categories param must be string' do
        expect(@object_serializer
                   .get_params_included_to_json[:include]
                   .keys[0]
                   .class)
            .to be == String
      end

      it 'Product param must be string' do
        expect(@object_serializer
                   .get_params_included_to_json[:include]
                   .keys[1]
                   .class)
            .to be == String
      end

      it 'Product param with_except argument must be Hash' do
        expect(@object_serializer
                   .get_params_included_to_json(with_except: true)[:except]
                   .class)
            .to be == Hash
      end
    end

    context 'Response data' do
      it 'One product and many categories' do
        @object_serializer.add_has_one 'product'
        @object_serializer.add_has_many 'categories'
        expect(@object_serializer.get_params_included_to_json)
            .to match include: { 'categories' => { except: [] }, 'product' =>
                { except: [] }}
      end

      it 'One product & many categories & many staffs' do
        @object_serializer.add_has_one 'product'
        @object_serializer.add_has_many 'categories'
        @object_serializer.add_has_many 'staffs'
        expect(@object_serializer.get_params_included_to_json)
            .to match include: { 'categories' => { except: [] },
                                 'staffs' => { except: [] },
                                 'product' => { except: [] } }
      end

      it 'With except argument' do
        @object_serializer = described_class.new(House.all,
                                                 except: [:name])
        @object_serializer.add_has_one 'product'
        @object_serializer.add_has_many 'categories'
        @object_serializer.add_has_many 'staffs'

        expect(@object_serializer.get_params_included_to_json(with_except: [:name]))
            .to match include: { 'categories' => { except: [] },
                                 'staffs' => { except: [] },
                                 'product' => { except: [] } },
                      except: [:name]
      end

      context '#add_foreign_object' do
        before :each do
          @object_serializer = described_class.new(House.all,
                                                   except: [:name])
          @object_serializer.add_has_one 'product'
          @object_serializer.add_has_many 'categories'
        end

        it 'response data' do
          object = @object_serializer.add_foreign_object(ForeignHouse.all, :custom_name, [:simple_field])
          expect(object).to match simple_field: 'TEXT'
        end

        it 'response json_serializer data' do
          @object_serializer.add_foreign_object(ForeignHouse.all, :custom_name, { custom_obj: 'simple_field' })
          expect(@object_serializer.json_serializer[:included].any?).to be_truthy
        end
      end

      context '#json_serializer' do
        before :each do
          @object_serializer = described_class.new(House.all,
                                                   except: [:name])
          @object_serializer.add_has_one 'product'
          @object_serializer.add_has_many 'categories'
          @object_serializer.add_has_many 'staffs'
        end

        it 'check hash type' do
          expect(@object_serializer.json_serializer.class).to eq Hash
        end

        it 'check return data string' do
          expect(@object_serializer.json_serializer).to match('simple_field' => 'TEXT')
        end
      end

      context '#get_object_included' do
        before :each do
          @object_serializer = described_class.new(House.all,
                                                   except: [:name])
          @object_serializer.add_has_one 'product'
          @object_serializer.add_has_many 'categories'
        end

        it 'check return data' do
          expect(@object_serializer.get_object_included).to match(simple_field: 'TEXT')
        end

      end

    end
  end
end