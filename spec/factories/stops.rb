# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stop do
    code "MyString"
    name "MyString"
    lat 1.5
    lng 1.5
  end
end
