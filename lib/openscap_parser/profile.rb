module OpenscapParser
  class Profile
    attr_acessor :id, :title, :description

    def to_h
      { :id => id, :title => title, :description => description }
    end
  end
end
