class User < ActiveRecord::Base
  extend FriendlyId

  devise :trackable, :omniauthable, omniauth_providers: CONFIGURED_OMNIAUTH_PROVIDERS

  has_many :authorizations, dependent: :destroy
  has_many :clicks, class_name: 'AthleteClick', dependent: :destroy
  has_many :athletes, class_name: 'Athlete::Base', dependent: :destroy

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX  = /\A#{TEMP_EMAIL_PREFIX}/

  validates :email, format: { without: TEMP_EMAIL_REGEX }, on: :update
  validates :headline, presence: true, on: :update
  validates :name,     presence: true

  serialize :meta, JSON

  acts_as_voter

  friendly_id :name, use: :slugged

  def first_authorization
    authorizations.first
  end

  delegate :handle, to: :first_authorization, allow_nil: true

  def self.create_from_auth!(auth)
    auth.provider == 'instagram' ? name = auth.info.name : name = auth.extra.raw_info.name

    create! name: name,
            avatar: image_from_auth(auth),
            email: email_or_temp_from_auth(auth),
            meta: auth.extra.raw_info.to_h
  end

  def self.image_from_auth(auth)
    auth.info.image || auth.extra.raw_info.profile_image_url_https
  end

  def self.email_or_temp_from_auth(auth)
    email = auth.info.email
    email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Authorization.find_for_oauth auth
    user     = signed_in_resource ? signed_in_resource : identity.user
    user     = create_from_auth!(auth) unless user
    identity.update_attribute :user, user if identity.user != user
    user
  end

  def email_verified?
    email && email !~ TEMP_EMAIL_REGEX
  end
end
