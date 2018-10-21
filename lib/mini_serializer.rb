require "mini_serializer/version"

module MiniSerializer
  class Serializer

    def initialize(object_main,except_params={})
      @wams_has_one=[]
      @wams_has_many=[]
      @wams_association_object=[]
      @wams_association_for_to_json={}
      @wams_main_object=object_main
      if !except_params.empty?
        @wams_except_params_main_object=except_params[:except]
      else
        @wams_except_params_main_object={}
      end

    end

    def add_has_many(object,except_methods=[])
      wams_has_many.append [object,except_methods]
    end

    def add_has_one(object,except_methods=[])
      wams_has_one<<[object,except_methods]
    end

    def get_params_included_to_json(with_except:false)
      fetch_association_objects
      if with_except
        {include:wams_association_for_to_json,except:wams_except_params_main_object}
      else
        {include:wams_association_for_to_json}
      end
    end

    def json_serializer(object=nil)
      included_data=includes_to_serializer
      var_hash={}

      wams_has_many.map do |object_assosiation,except_params|
        var_hash.store(object_assosiation,{except: except_params})
      end
      wams_has_one.map do |object_assosiation,except_params|
        var_hash.store(object_assosiation,{except: except_params})
      end

      if !wams_except_params_main_object.empty? # have except params for main object
        unless object.nil?
            object.to_json({include:wams_association_for_to_json,except:wams_except_params_main_object})
          else
            included_data.to_json({include:wams_association_for_to_json,except:wams_except_params_main_object})
        end
      else
        unless object.nil?
            return object.to_json({include:wams_association_for_to_json})
          else
            return included_data.to_json({include:wams_association_for_to_json})
        end
      end
      # example output : wams_association_for_to_json is {'house_images':{except: [:id,:house_id]} }
    end

    def get_object_included
      return includes_to_serializer
    end

    private
    attr_accessor :wams_has_many,:wams_has_one ,:wams_association_object,
                  :wams_except_params,:wams_main_object,:wams_association_for_to_json,
                  :wams_except_params_main_object

    def includes_to_serializer
      data_with_includes=nil
      fetch_association_objects
      if wams_has_many.any?
        data_with_includes= wams_main_object.includes(wams_association_object)
      end
      if wams_has_one.any?
        data_with_includes.merge! wams_main_object.includes(wams_association_object)
      end
      if wams_has_one.empty? && wams_has_one.empty? # when main object not any has_one and has_many
        return wams_main_object # return main object
      end
      return data_with_includes
    end

    def fetch_association_objects
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
