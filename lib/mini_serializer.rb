require "mini_serializer/version"

module MiniSerializer
  class Serializer

    def initialize(object_main,except_params={})
      @wams_has_one=[]
      @wams_has_many=[]
      @wams_association_object=[]
      @wams_association_for_to_json={}
      @wams_main_object=object_main
      @wams_except_params_main_object=except_params[:except]
    end

    def self.add_has_many(object,except_methods=[])
      wams_has_many.append [object,except_methods]
    end

    def self.add_has_one(object,except_methods=[])
      wams_has_one<<[object,except_methods]
    end

    def self.get_included_objects
      return wams_association_object
    end

    def self.json_serializer
      included_data=includes_to_serlizer
      var_hash={}

      wams_has_many.map do |object_assosiation,except_params|
        var_hash.store(object_assosiation,{except: except_params})
      end
      wams_has_one.map do |object_assosiation,except_params|
        var_hash.store(object_assosiation,{except: except_params})
      end

      if wams_except_params_main_object.any? # have except params for main object
        return included_data.to_json({include:wams_association_for_to_json,except:wams_except_params_main_object})
      else
        return included_data.to_json({include:wams_association_for_to_json})
      end
      # example output : wams_association_for_to_json is {'house_images':{except: [:id,:house_id]} }
    end

    private
    attr_accessor :wams_has_many,:wams_has_one ,:wams_association_object,
                  :wams_except_params,:wams_main_object,:wams_association_for_to_json,
                  :wams_except_params_main_object

    def self.includes_to_serlizer
      data_with_includes=nil
      fetch_association_objects
      if wams_has_many.any?
        data_with_includes= wams_main_object.includes(wams_association_object)
      end
      if wams_has_one.any?
        data_with_includes.merge! wams_main_object.includes(wams_association_object)
      end
      return data_with_includes
    end

    def self.fetch_association_objects
      wams_has_many.map do  |object_asoc,except_params|
        wams_association_for_to_json.store(object_asoc,{except: except_params}) # for to_json hash
        wams_association_object<<object_asoc # for included (relation record)
      end

      wams_has_one.map do |object_asoc,except_params|
        wams_association_for_to_json.store(object_asoc,{except: except_params}) # for to_json hash
        wams_association_object<<object_asoc # for included (relation record)
      end
    end

  end
end
