namespace :setup do
  desc "Provisioning files"
  task :all do
    on roles(:all) do
      invoke "secrets:setup"
      invoke "nginx:setup"
      invoke "nginx:configtest"
      invoke "unicorn:setup"
      invoke "unicorn:script"
      invoke "monit:setup"
      invoke "munin:setup"
      invoke "logrotate:setup"
      invoke "nginx:restart"
    end
  end
end

namespace :secrets do
  desc "setup basic secrets.yml file"
  task :setup do
    template "secrets.yml.erb", fetch(:yml_conf_path), { user: fetch(:user), group: 'sudo' }
  end
end

def upload(from, to, opt={})
  user = opt[:user] || "root"
  group = opt[:group] || "root"
  permissions = opt[:permissions] || "644"
  executable = opt[:execute]
  content = opt[:content]

  file_content = content || File.new(from).read
  file = ERB.new(file_content).result(binding)
  tmp = "/tmp/#{File.basename(from, ".erb")}"
  on roles(:all) do
    upload! StringIO.new(file), tmp
    sudo "chmod #{permissions} #{tmp}"
    sudo "chown #{user}:#{group} #{tmp}"
    # sudo "touch #{tmp}"
    sudo "chmod +x #{tmp}" if executable
    sudo "mv #{tmp} #{to}"
  end
end

def mkdir(path, opt={})
  user = opt[:user] || fetch(:user)
  group = opt[:group] || "root"

  folders = path.split("/").reject(&:empty?)
  path_part = path
  folders.size.times do |i|
    break if test("[ -d #{path_part} ]")
    path_part = path_part[0..-2] if path_part[-1] == "/"
    path_part = path_part[/(^.+)\//]
  end
  sudo "mkdir -p #{path}"
  sudo "chmod -R 755 #{path_part}"
  sudo "chown -R #{user}:#{group} #{path_part}"
end

def template(name, to, opt={})
  upload "#{fetch(:templates_path)}/#{name}", to, opt
end

def script(name, to, opt={})
  opt.merge!(execute: true)
  upload "#{fetch(:scripts_path)}/#{name}", to, opt
end

def sync(from, service_name, opt={})
  to = "#{fetch(:download_path)}/#{service_name}"
  if opt.delete(:clear)
    clear_folder = opt[:recursive] ? "#{to}/#{from.split("/").last}" : to
    FileUtils.rm_rf clear_folder
    FileUtils::mkdir_p clear_folder
  end
  download! from, to, opt
end

def interact(command)
  cmd = "ssh -l #{fetch(:user)} #{host} -p #{fetch(:port)} -t '#{command}'"
  info "Connecting to #{host}"
  exec cmd
end
