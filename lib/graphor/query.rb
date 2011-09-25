class Query < Sequel::Model
  unrestrict_primary_key

  one_to_many :derivatives,
    :class => Query,
    :key => :parent_alias

  one_to_one :parent,
    :class => Query,
    :primary_key => :parent_alias,
    :key => :alias

  def execute
    db = Sequel.connect(self[:database_url])
    x = []; y = []
    xlabels = [];
    db.fetch(self[:query]).each do |row|
      if row[:x].instance_of? Time
        xlabels << row[:x].to_s
        x << row[:x].to_i
      else
        x << row[:x]
      end
      y << row[:y]
    end
    {:x => x, :y => y, :xlabels => xlabels}
  end
end
