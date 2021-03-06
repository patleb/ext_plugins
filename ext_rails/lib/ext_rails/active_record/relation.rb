ActiveRecord::Relation.class_eval do
  def count_estimate
    return 0 if none? # values[:extending]&.include? ActiveRecord::NullRelation

    sql = limit(nil).offset(nil).reorder(nil).to_sql
    connection.execute("EXPLAIN #{sql}").first["QUERY PLAN"].match(/rows=(\d+)/)[1].to_i
  end

  def select_without(*fields)
    select(*(column_names - fields.map(&:to_s)))
  end
end
