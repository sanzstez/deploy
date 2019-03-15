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
  upload "config/templates/#{name}", to, opt
end

def script(name, to, opt={})
  opt.merge!(execute: true)
  upload "config/templates/services/#{name}", to, opt
end