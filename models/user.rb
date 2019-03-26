require 'active_record'

class User < ActiveRecord::Base
  has_one :test, dependent: :destroy
end
