class User < ActiveRecord::Base
  include BCrypt

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy



  #Does this work
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :small => '50x50>' }, :default_url => "rails.png", :provider => 'AWS',
                    :s3_credentials => {
                        :bucket  => "twitterclones-assets-users",
                        :access_key_id => ENV["aws_secret_access_key"],
                        :secret_access_key => ENV["aws_secert_key_id"]
                    }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  #Avatars are supser fuckign easy

#Following Sections
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end
#Following Sections


	attr_accessor :remember_token, :activation_token, :reset_token


  self.per_page = 15
	before_save :downcase_email
  before_create :create_activation_digest
  #private methods on bottom

	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 100}, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

	has_secure_password
	validates :password, length: { minimum: 5 }, allow_blank: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                 BCrypt::Engine.cost
    BCrypt::Password.create(string, :cost => cost)
  end
  #creates complicated numbers in order to secure validation etc.

  #returns a random token
  #for persistent login
  def User.new_token
  	SecureRandom.urlsafe_base64
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  #creates a random token

  def remember
  	self.remember_token = User.new_token
  	update_attribute(:remember_digest, User.digest(remember_token))
  end
  #updates the current attributes for the token


  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    password = BCrypt::Password.new(digest)
    password == token ? true : false
  end
  #if remember_digest if not nill which would mean theres a user_token
  #this will return true if there is a token authenticated.

  def forget
    update_attribute(:remember_digest, nil)
  end


  def activate
    update_attribute(:activated,  true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  #Createas a feed on users profile using active Record
  def feed
    #I create a followingID by digging into the SQL record using Select, from, and where.
    #than select the micropost that have the followers ID's.
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  private
    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
  #updates the forget(user) attribute.

end
