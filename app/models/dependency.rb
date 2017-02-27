class Dependency < ApplicationRecord
  belongs_to :service
  belongs_to :towards, :class_name => :Service, :foreign_key => "dependency_id"

  enum :type [:internal, :external]

end
