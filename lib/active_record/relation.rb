module ActiveRecord
  class Relation
    extend Forwardable

    def_delegators :records,
       :to_a, :first, :last, :each

    def initialize(klass)
      @klass = klass
      @where_values = []
    end

    def where!(condition)
      @where_values += [condition]
      self
    end

    def where(condition)
      clone.where!(condition)
    end

    def to_sql
      sql = "SELECT * FROM #{@klass.table_name}"

      if @where_values.any?
        sql += " WHERE " + @where_values.join(' AND ')
      end

      sql
    end

    def records
      @records ||= @klass.find_by_sql(to_sql)
    end
  end
end
