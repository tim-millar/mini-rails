module ActiveRecord
  class Base
    def self.abstract_class=(value)
      # Not implemented
    end

    def self.find(id)
      find_by_sql("SELECT * FROM #{table_name} WHERE id = #{id.to_i}").first
    end

    def self.all
      ActiveRecord::Relation.new(self)
    end

    def self.where(*args)
      all.where(*args)
    end

    def self.find_by_sql(sql)
      connection.execute(sql).map { |attr| new(attr) }
    end

    def self.table_name
      name.downcase + 's'
    end

    def self.establish_connection(options)
      @@connection = ConnectionAdapter::SqliteAdapter.new(options[:database])
    end

    def self.connection
      @@connection
    end

    def initialize(attributes={})
      @attributes = attributes
    end

    def method_missing(name, *args)
      if columns.include?(name)
        @attributes[name]
      else
        super
      end
    end

    private

    def columns
      self.class.connection.columns(self.class.table_name)
    end
  end
end
