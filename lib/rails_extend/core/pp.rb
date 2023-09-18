class PP

  def pp_hash(obj)
    group(1, '{', '}') do
      seplist(obj, nil, :each_pair) do |k, v|
        group(1) do
          pp k
          text '=>'
          group(1) do
            breakable ''
            pp v
          end
        end
      end
    end
  end

end
