# frozen_string_literal: true

def insert_user
  User.delete_all
  password = Rails.env.production? ? Devise.friendly_token : (1..9).to_a.join

  admin = User.new do |u|
    u.name = 'Administrator'
    u.email = 'dev@fodojo.com'
    u.password = password
    u.password_confirmation = password
    u.login = 'admin' if u.respond_to?(:login)
    u.role_type = RoleType.admin
  end

  admin.skip_confirmation!
  admin.save!

  puts "Admin: #{admin.email}, #{admin.password}"
end

def insert_structures
  Structure.delete_all

  main_page = Structure.create!(title: 'Главная страница', slug: 'main-page', structure_type: StructureType.main, parent: nil)
  # Structure.create!(title: "Трансляции", slug: "broadcasts", structure_type: StructureType.broadcasts, parent: main_page)
end

insert_user
insert_structures
