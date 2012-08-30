# encoding: utf-8

def insert_user  
  User.truncate!
  Role.truncate!
  password = Rails.env.production? ? Devise.friendly_token : (1..9).to_a.join
  
  admin = User.new(:name=>'Administrator', :email=>'dev@example.com',
                   :password=>password, :password_confirmation=>password)
  admin.login = 'admin' if admin.respond_to?(:login)
  admin.roles.build(:role_type => RoleType.admin)
  admin.skip_confirmation!
  admin.save!

  puts "Admin: #{admin.email}, #{admin.password}"
end

def insert_structures
  Structure.truncate!
  
  main_page = Structure.create!({:title => "Главная страница", :slug => "main-page", :structure_type => StructureType.main, :parent => nil}, :as => :admin)
  #Structure.create!({:title => "Трансляции", :slug => "broadcasts", :structure_type => StructureType.broadcasts, :parent => main_page}, :as => :admin)
  #Structure.create!({:title => "Прямые репортажи", :slug => "posts", :structure_type => StructureType.posts, :parent => main_page}, :as => :admin)
end

insert_user
insert_structures
