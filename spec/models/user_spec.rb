require 'spec_helper'

describe User do
  before { @user = User.new( name: "bongani", email: "some@gmail.com" ,password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate)}
  it { should be_valid }

  describe "When password is not valid " do
    before do
      @user = User.new( name: "bongani", email: "somethingnice@gmail.com", password: " ", password_confirmation: " ")
    end
    it { should_not be_valid}
  end

  describe "When password do not match" do
    before do
      @user.password_confirmation = "mismatch"
    end
    it { should_not be_valid}
  end

  describe "return a value of authenticated method" do
     before( @user.save )
    let(:found_user) { User.find_by(email: @user.email) }
  end

  describe "authenticate with valid password" do
    it { should eq found_user.authenticate(@User.password) }
  end

  describe "authenticate with invalid password" do
    let(:user_for_invalid_password) { found_user.authenticate("invalid")}

    it { should_not eq user_for_invalid_password }
    specify { expect(user_for_invalid_password).to be_false}
  end

  describe "when name is not present" do
  	before { @user.name = "" }
  	it { should_not be_valid }
  end

  describe "A name should not be too long" do
  	 before { @user.name = "a" * 51}
  	 it { should_not be_valid }
  	end

  	describe "When email address is invalid" do
  		it "should_not be_valid" do
  			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
            addresses.each do |invalid_address|
            	@user.email = invalid_address
            	expect(@user).not_to be_valid
            end
  		end
  	end

    describe "When email address is valid" do
      it "should be valid" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]

        addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end
    end

    # describe "when email address is already been taken" do
    #   before do
    #     user_with_the_same_email = @user.dup
    #     user_with_the_same_email = @user.email.upcase
    #     user_with_the_same_email.save
    #   end
    #   it { should_not be_valid}
    # end
end
