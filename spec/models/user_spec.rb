# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  fixtures :users

  it 'maintains a list of meetings through attendances' do
    user = Factory(:user)
    user.should respond_to(:attendances)
    user.should respond_to(:meetings)
  end

  it 'maintains a list of social networks' do
    user = Factory(:user)
    user.should respond_to(:social_networks)
  end

  it 'provides a Gravatar image' do
    user = Factory.build(:user)
    user.should respond_to("gravatar_url")
  end

  describe 'when getting full_name' do
    it 'provides full_name with first_name and last_name present' do
      user = Factory.build(:user)
      user.full_name.should == 'First Last'
    end

    it 'provides full_name with last_name nil' do
      user = Factory.build(:user, :last_name => nil)
      user.full_name.should == 'First'
    end

    it 'provides full_name with last_name the empty string' do
      user = Factory.build(:user, :last_name => '')
      user.full_name.should == 'First'
    end

    it 'provides full_name with first_name nil' do
      user = Factory.build(:user, :first_name => nil)
      user.full_name.should == 'Last'
    end

    it 'provides full_name with first_name the empty string' do
      user = Factory.build(:user, :first_name => '')
      user.full_name.should == 'Last'
    end

    it 'returns the empty string if first_name and last_name are blank' do
      user = Factory.build(:user, :first_name => nil, :last_name => nil)
      user.full_name.should == ''
    end
  end

  describe 'being created' do
    before do
      @user = nil
      @creating_user = lambda do
        @user = create_user
        violated "#{@user.errors.full_messages.to_sentence}" if @user.new_record?
      end
    end

    it 'increments User#count' do
      @creating_user.should change(User, :count).by(1)
    end

    it 'initializes #activation_code' do
      @creating_user.call
      @user.reload
      @user.activation_code.should_not be_nil
    end

    it 'starts in pending state' do
      @creating_user.call
      @user.reload
      @user.should be_pending
    end

    it 'initializes logged_in_at with current time' do
      @creating_user.call
      @user.logged_in_at.should be_close(Time.now, 2.seconds)
    end
  end

  #
  # Validations
  #

  it 'requires identity_url' do
    lambda do
      u = create_user(:identity_url => nil)
      u.errors.on(:identity_url).should_not be_nil
    end.should_not change(User, :count)
  end

  it 'norimalizes the identity_url on create' do
    user = Factory(:user, :identity_url => 'example.com')
    user.identity_url.should == 'http://example.com/'
  end

  it 'norimalizes the identity_url on update' do
    user = Factory(:user)
    user.identity_url = 'example.com'
    user.save
    user.identity_url.should == 'http://example.com/'
  end

  it 'requires identity_url to be unique' do
    lambda do
      user = Factory(:user, :identity_url => 'http://example.com/')
      user.should be_valid
      steve = Factory.build(:steve, :identity_url => 'http://example.com/')
      steve.should_not be_valid
      steve.should have(1).error_on(:identity_url)
    end.should change(User, :count).by(1)
  end

  it 'makes a fake login on create when not provided' do
    lambda do
      u = create_user(:login => nil)
      u.errors.on(:login).should be_nil
    end.should change(User, :count).by(1)
  end

  describe 'allows legitimate logins:' do
    ['123', '1234567890_234567890_234567890_234567890',
     'hello.-_there@funnychar.com'].each do |login_str|
      it "'#{login_str}'" do
        lambda do
          u = create_user(:login => login_str)
          u.errors.on(:login).should     be_nil
        end.should change(User, :count).by(1)
      end
    end
  end
  describe 'disallows illegitimate logins:' do
    ['12', '1234567890_234567890_234567890_234567890_', "tab\t", "newline\n",
     "Iñtërnâtiônàlizætiøn hasn't happened to ruby 1.8 yet",
     'semicolon;', 'quote"', 'tick\'', 'backtick`', 'percent%', 'plus+', 'space '].each do |login_str|
      it "'#{login_str}'" do
        lambda do
          u = create_user(:login => login_str)
          u.errors.on(:login).should_not be_nil
        end.should_not change(User, :count)
      end
    end
  end

  it 'makes a fake password when not provided' do
    lambda do
      u = create_user(:password => nil)
      u.errors.on(:password).should be_nil
    end.should change(User, :count).by(1)
  end

  it 'makes a fake password confirmation when password not provided' do
    lambda do
      u = create_user(:password => nil)
      u.errors.on(:password_confirmation).should be_nil
    end.should change(User, :count).by(1)
  end

  it 'requires email' do
    lambda do
      u = create_user(:email => nil)
      u.errors.on(:email).should_not be_nil
    end.should_not change(User, :count)
  end

  describe 'allows legitimate emails:' do
    ['foo@bar.com', 'foo@newskool-tld.museum', 'foo@twoletter-tld.de', 'foo@nonexistant-tld.qq',
     'r@a.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail.com',
     'hello.-_there@funnychar.com', 'uucp%addr@gmail.com', 'hello+routing-str@gmail.com',
     'domain@can.haz.many.sub.doma.in', 'student.name@university.edu'
    ].each do |email_str|
      it "'#{email_str}'" do
        lambda do
          u = create_user(:email => email_str)
          u.errors.on(:email).should     be_nil
        end.should change(User, :count).by(1)
      end
    end
  end
  describe 'disallows illegitimate emails' do
    ['!!@nobadchars.com', 'foo@no-rep-dots..com', 'foo@badtld.xxx', 'foo@toolongtld.abcdefg',
     'Iñtërnâtiônàlizætiøn@hasnt.happened.to.email', 'need.domain.and.tld@de', "tab\t", "newline\n",
     'r@.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail2.com',
     # these are technically allowed but not seen in practice:
     'uucp!addr@gmail.com', 'semicolon;@gmail.com', 'quote"@gmail.com', 'tick\'@gmail.com', 'backtick`@gmail.com', 'space @gmail.com', 'bracket<@gmail.com', 'bracket>@gmail.com'
    ].each do |email_str|
      it "'#{email_str}'" do
        lambda do
          u = create_user(:email => email_str)
          u.errors.on(:email).should_not be_nil
        end.should_not change(User, :count)
      end
    end
  end

  describe 'allows legitimate first names:' do
    ['Andre The Giant (7\'4", 520 lb.) -- has a posse',
     '', '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890',
    ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_user(:first_name => name_str)
          u.errors.on(:first_name).should     be_nil
        end.should change(User, :count).by(1)
      end
    end
  end
  describe "disallows illegitimate first names" do
    ["tab\t", "newline\n",
     '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_',
     ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_user(:first_name => name_str)
          u.errors.on(:first_name).should_not be_nil
        end.should_not change(User, :count)
      end
    end
  end

  describe 'allows legitimate last names:' do
    ['Andre The Giant (7\'4", 520 lb.) -- has a posse',
     '', '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890',
    ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_user(:last_name => name_str)
          u.errors.on(:last_name).should     be_nil
        end.should change(User, :count).by(1)
      end
    end
  end
  describe "disallows illegitimate last names" do
    ["tab\t", "newline\n",
     '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_',
     ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_user(:last_name => name_str)
          u.errors.on(:last_name).should_not be_nil
        end.should_not change(User, :count)
      end
    end
  end

  it 'resets password' do
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    User.authenticate(nil, 'quentin', 'new password').should == users(:quentin)
  end

  it 'does not rehash password' do
    users(:quentin).update_attributes(:login => 'quentin2')
    User.authenticate(nil, 'quentin2', 'monkey').should == users(:quentin)
  end

  #
  # Authentication
  #

  it 'authenticates user' do
    User.authenticate(nil, 'quentin', 'monkey').should == users(:quentin)
  end

  it "doesn't authenticate user with bad password" do
    User.authenticate(nil, 'quentin', 'invalid_password').should be_nil
  end

 if REST_AUTH_SITE_KEY.blank?
   # old-school passwords
   it "authenticates a user against a hard-coded old-style password" do
     User.authenticate(nil, 'old_password_holder', 'test').should == users(:old_password_holder)
   end
 else
   it "doesn't authenticate a user against a hard-coded old-style password" do
     User.authenticate(nil, 'old_password_holder', 'test').should be_nil
   end

   # New installs should bump this up and set REST_AUTH_DIGEST_STRETCHES to give a 10ms encrypt time or so
   desired_encryption_expensiveness_ms = 0.1
   it "takes longer than #{desired_encryption_expensiveness_ms}ms to encrypt a password" do
     test_reps = 100
     start_time = Time.now; test_reps.times{ User.authenticate(nil, 'quentin', 'monkey'+rand.to_s) }; end_time   = Time.now
     auth_time_ms = 1000 * (end_time - start_time)/test_reps
     auth_time_ms.should > desired_encryption_expensiveness_ms
   end
 end

  #
  # Authentication
  #

  it 'sets remember token' do
    users(:quentin).remember_me
    users(:quentin).remember_token.should_not be_nil
    users(:quentin).remember_token_expires_at.should_not be_nil
  end

  it 'unsets remember token' do
    users(:quentin).remember_me
    users(:quentin).remember_token.should_not be_nil
    users(:quentin).forget_me
    users(:quentin).remember_token.should be_nil
  end

  it 'remembers me for one week' do
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    users(:quentin).remember_token.should_not be_nil
    users(:quentin).remember_token_expires_at.should_not be_nil
    users(:quentin).remember_token_expires_at.between?(before, after).should be_true
  end

  it 'remembers me until one week' do
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    users(:quentin).remember_token.should_not be_nil
    users(:quentin).remember_token_expires_at.should_not be_nil
    users(:quentin).remember_token_expires_at.should == time
  end

  it 'remembers me default two weeks' do
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    users(:quentin).remember_token.should_not be_nil
    users(:quentin).remember_token_expires_at.should_not be_nil
    users(:quentin).remember_token_expires_at.between?(before, after).should be_true
  end

  it 'suspends user' do
    users(:quentin).suspend!
    users(:quentin).should be_suspended
  end

  it 'does not authenticate suspended user' do
    users(:quentin).suspend!
    User.authenticate(nil, 'quentin', 'monkey').should_not == users(:quentin)
  end

  it 'deletes user' do
    users(:quentin).deleted_at.should be_nil
    users(:quentin).delete!
    users(:quentin).deleted_at.should_not be_nil
    users(:quentin).should be_deleted
  end

  describe "being unsuspended" do
    fixtures :users

    before do
      @user = users(:quentin)
      @user.suspend!
    end

    it 'reverts to active state' do
      @user.unsuspend!
      @user.should be_active
    end

    it 'reverts to passive state if activation_code and activated_at are nil' do
      User.update_all :activation_code => nil, :activated_at => nil
      @user.reload.unsuspend!
      @user.should be_passive
    end

    it 'reverts to pending state if activation_code is set and activated_at is nil' do
      User.update_all :activation_code => 'foo-bar', :activated_at => nil
      @user.reload.unsuspend!
      @user.should be_pending
    end
  end

protected
  def create_user(options = {})
    record = User.new({
      :identity_url => 'http://quire.example.com/',
      :login => 'quire',
      :email => 'quire@example.com',
      :password => 'quire69',
      :password_confirmation => 'quire69'}.merge(options))
    record.register! if record.valid?
    record
  end
end
