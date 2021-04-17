class User < ActiveRecord::Base
    has_secure_password
    validates_uniqueness_of :email
    validates_presence_of :email
    validates_presence_of :name
    has_many :pets
end
