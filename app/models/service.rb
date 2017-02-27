class Service < ApplicationRecord
  validates :name, presence: true
  validates :project, presence: true

  belongs_to :project

  has_and_belongs_to_many :dependencies,
                            class_name: 'Service',
                            join_table: :dependencies,
                            foreign_key: :service_id,
                            association_foreign_key: :dependency_id,
                            uniq: true
                            
  has_and_belongs_to_many :external_resources
end
