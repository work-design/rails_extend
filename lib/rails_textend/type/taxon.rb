module ActiveRecord::Type
  class Taxon < Json

    def input_type
      :taxon
    end

  end
end

ActiveRecord::Type.register(:taxon, ActiveRecord::Type::Taxon)
