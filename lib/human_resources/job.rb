require 'delegate'
require 'hashie'

module HumanResources
  class Job < SimpleDelegator
    attr_reader :slug

    def initialize(obj, opts={})      
      super(Hashie::Mash.new(obj))
      @slug = opts[:slug]

    end

    # basically an alias for :location, but returns an Array    
    def locations
      Array(location)
    end

    def locations_string(val=3)
      arr = val >= locations.length ? locations : (locations[0..(val-1)] + ['and more'])

      return arr.join(', ')
    end

    # things to be deprecated/moved
    def employer_name; self.employer.name; end
    def title; self.position.title; end
    def type; self.position.type; end
    def blurb; self[:blurb]; end
  end
end