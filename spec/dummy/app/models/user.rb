class User < ActiveRecord::Base  
  def name
    raise "exception in model"
  end
end