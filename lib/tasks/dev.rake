namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") { %x(rails db:drop) }
      show_spinner("Criando BD...") { %x(rails db:create) }
      show_spinner("Migrando BD...") { %x(rails db:migrate) }
      show_spinner("Criando adm padrão") { %x(rails dev:add_default_admin) }
      show_spinner("Criando user padrão") { %x(rails dev:add_default_user) }
    else
      puts "Você não está em ambiente de desenvolvimento!"
    end
  end

  desc "Criação do usuário Administrador"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admteste@teste.com',
      password: 'adm123456',
      password_confirmation: 'adm123456'
    )
  end

  desc "Criação do usuário comum"
  task add_default_user: :environment do
    User.create!(
      email: 'userteste@teste.com',
      password: 'user123456',
      password_confirmation: 'user123456'
    )
  end


private

def show_spinner(msg_start, msg_end = "Concluído!")
  spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
  spinner.auto_spin
  yield
  spinner.success("(#{msg_end})")
end
end
