class ActiveRecord::Base
  class << self
    def establish_connection_with_activerecord_import(*args)
      establish_connection_without_activerecord_import(*args)
      ActiveSupport.run_load_hooks(:active_record_connection_established, connection_pool)
    end
    alias establish_connection_without_activerecord_import establish_connection
    alias establish_connection establish_connection_with_activerecord_import
  end
end

ActiveSupport.on_load(:active_record_connection_established) do |connection_pool|
  if !ActiveRecord.const_defined?(:Import) || !ActiveRecord::Import.respond_to?(:load_from_connection_pool)
    require File.join File.dirname(__FILE__),  "activerecord-import/base"
  end
  ActiveRecord::Import.load_from_connection_pool connection_pool
end
