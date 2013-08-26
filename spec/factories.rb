FactoryGirl.define do
	factory :user do
		name  "Bongani"
		email "bon@gmail.com"
		password "foo"
		password_confirmation "foo"
	end
end