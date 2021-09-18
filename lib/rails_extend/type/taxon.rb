module ActiveRecord::Type
  class Taxon < Json

    def input_type
      :taxon
    end

    def migrate_type
      :json
    end

  end
end

ActiveRecord::Type.register(:taxon, ActiveRecord::Type::Taxon)
