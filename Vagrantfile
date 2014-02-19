Vagrant::Config.run do |config|
  config.vm.box = "official-raring32"
  config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.network :bridged
end
